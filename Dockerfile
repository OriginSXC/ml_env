# Based on the NVIDIA PyTorch container (Release 24.04) with Python 3.10 and CUDA 12.4
FROM nvcr.io/nvidia/pytorch:24.04-py3

# Switch to root user for sufficient permissions
USER root

# Set timezone and non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Edmonton

# Update package list and install required software and tools
# The base image uses Ubuntu 22.04 with Python 3.10 as the default python3.
# python3-venv and python3-dev will target Python 3.10.
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y  \
        wget \
        curl \
        python3-venv \
        python3-dev \
        python3-pip \
        build-essential \
        git \
        libboost-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        ocl-icd-libopencl1 \
        ocl-icd-opencl-dev \
        clinfo \
        postgresql-client \
        mysql-client \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

# Reset DEBIAN_FRONTEND to avoid affecting subsequent commands
ENV DEBIAN_FRONTEND=dialog

# Download and install new CMake 3.30.4
RUN wget https://github.com/Kitware/CMake/releases/download/v3.30.4/cmake-3.30.4-linux-x86_64.sh && \
    chmod +x cmake-3.30.4-linux-x86_64.sh && \
    ./cmake-3.30.4-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.30.4-linux-x86_64.sh

# Create or overwrite a symbolic link python -> python3 (Python 3.10 is the default python3 in the base image)
# Using -sf to force the link creation, overwriting if it exists.
# This helps with scripts that expect 'python'
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Set OpenCL vendor file, pointing to the correct OpenCL library path from CUDA (CUDA 12.4 in this base)
# This is kept as other packages might use OpenCL
RUN mkdir -p /etc/OpenCL/vendors && echo "/usr/local/cuda/targets/x86_64-linux/lib/libOpenCL.so" > /etc/OpenCL/vendors/nvidia.icd

# LightGBM installation sections have been removed.

# Create virtual environment using Python 3.10 from the base image,
# allowing use of system site packages (for PyTorch, RAPIDS 24.02 etc. from the base image)
RUN python3 -m venv /opt/venv --system-site-packages

# Install Python packages into the virtual environment
RUN VENV_PIP="/opt/venv/bin/pip" && \
    # Upgrade pip within the venv
    $VENV_PIP install --upgrade pip && \
    # Upgrade setuptools and wheel, install numpy and ninja as they are common build dependencies
    $VENV_PIP install --upgrade setuptools wheel && \
    $VENV_PIP install numpy ninja && \
    \
    # PyTorch, torchvision, and torchaudio are expected to be provided by the base image (nvcr.io/nvidia/pytorch:24.04-py3)
    # and accessible via --system-site-packages in the venv. Thus, explicit installation is removed.
    \
    # Install causal-conv1d from GitHub (dependency for Mamba)
    # This will be built against the Python 3.10 and PyTorch from the base image.
    $VENV_PIP install git+https://github.com/Dao-AILab/causal-conv1d.git && \
    \
    # Clone Mamba repository, build and install Mamba from source, then clean up
    git clone https://github.com/state-spaces/mamba.git && \
    cd mamba && \
    CAUSAL_CONV1D_FORCE_BUILD=TRUE CAUSAL_CONV1D_SKIP_CUDA_BUILD=TRUE CAUSAL_CONV1D_FORCE_CXX11_ABI=TRUE $VENV_PIP install --no-build-isolation . && \
    cd .. && \
    rm -rf mamba && \
    \
    # Install other common database and data science packages
    $VENV_PIP install \
        psycopg2-binary asyncpg sqlalchemy tenacity mysql-connector-python pymysql \
        xarray cftime \
        xgboost \
        catboost \
        optuna \
        lightning \
        openpyxl \
        neuralprophet \
        scikit-learn \
        pandas \
        joblib \
        pytorch-tabular\
        xlsxwriter tensorboard optuna-integration[pytorch_lightning] \
        pytorch-forecasting \
        scipy && \
    # Optional: Final pip upgrade with fast-deps feature
    $VENV_PIP install --use-feature=fast-deps --upgrade pip

# Install NVIDIA's additional RAPIDS packages (cuDF, cuML, etc.)
# These will be installed into the virtual environment.
# The base image includes RAPIDS 24.02; these installs target 25.4.* (newer).
# The "-cu12" packages are for CUDA 12.x, compatible with CUDA 12.4 in the base image.
RUN /opt/venv/bin/pip install \
    --extra-index-url=https://pypi.nvidia.com \
    "cudf-cu12==25.4.*" "dask-cudf-cu12==25.4.*" "cuml-cu12==25.4.*" \
    "cugraph-cu12==25.4.*" "nx-cugraph-cu12==25.4.*" "cuspatial-cu12==25.4.*" \
    "cuproj-cu12==25.4.*" "cuxfilter-cu12==25.4.*" "cucim-cu12==25.4.*" \
    "pylibraft-cu12==25.4.*" "raft-dask-cu12==25.4.*" "cuvs-cu12==25.4.*"

# Set environment variables
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
# CUDA_HOME and LD_LIBRARY_PATH should be set by the base NVIDIA image,
# but explicitly setting them can ensure consistency.
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
ENV CUDA_HOME=/usr/local/cuda

# Create working directory
WORKDIR /app

# Set default shell, ensuring Python virtual environment is activated upon login
RUN echo "source /opt/venv/bin/activate" >> /root/.bashrc && \
    echo "source /opt/venv/bin/activate" >> /etc/bash.bashrc

# Set the default command for the image to bash (login shell)
CMD ["/bin/bash", "-l"]
