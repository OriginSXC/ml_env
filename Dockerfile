# 使用指定的 NVIDIA CUDA 基础镜像，包含 nvcc
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# 切换到 root 用户以获得足够权限
USER root

# 更新包列表并安装 wget 和依赖工具
RUN apt-get update && \
    apt-get install -y wget curl sudo \
    python3.11 python3.11-venv python3.11-dev python3-pip \
    build-essential git libboost-dev libboost-system-dev libboost-filesystem-dev \
    ocl-icd-libopencl1 ocl-icd-opencl-dev clinfo && \
    rm -rf /var/lib/apt/lists/*

# 下载并安装新版 CMake 3.30.4
RUN wget https://github.com/Kitware/CMake/releases/download/v3.30.4/cmake-3.30.4-linux-x86_64.sh && \
    chmod +x cmake-3.30.4-linux-x86_64.sh && \
    ./cmake-3.30.4-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.30.4-linux-x86_64.sh

# 设置 Python 3.11 为默认 Python 版本
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# 创建 python 指向 python3 的符号链接
RUN ln -s /usr/bin/python3 /usr/bin/python

# 设置 OpenCL vendor 文件，指向正确的 OpenCL 库路径
RUN mkdir -p /etc/OpenCL/vendors && echo "/usr/local/cuda/targets/x86_64-linux/lib/libOpenCL.so" > /etc/OpenCL/vendors/nvidia.icd

# 克隆 LightGBM 仓库
RUN git clone --recursive https://github.com/microsoft/LightGBM

# 编译 LightGBM（使用 GPU 支持）
RUN cd LightGBM && \
    cmake -B build -S . -DUSE_GPU=1 -DOpenCL_LIBRARY=/usr/local/cuda/targets/x86_64-linux/lib/libOpenCL.so -DOpenCL_INCLUDE_DIR=/usr/local/cuda/targets/x86_64-linux/include && \
    cmake --build build -j$(nproc) && \
    pip install --upgrade pip && \
    sh ./build-python.sh install --precompile

# 创建虚拟环境，允许使用系统环境中的包
RUN python3 -m venv /opt/venv --system-site-packages

# 激活虚拟环境并逐步安装其他 Python 包到虚拟环境中
RUN /opt/venv/bin/pip install --upgrade pip
RUN /opt/venv/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN /opt/venv/bin/pip install xgboost
RUN /opt/venv/bin/pip install catboost
RUN /opt/venv/bin/pip install optuna
RUN /opt/venv/bin/pip install lightning
RUN /opt/venv/bin/pip install openpyxl
RUN /opt/venv/bin/pip install neuralprophet
RUN /opt/venv/bin/pip install scikit-learn
RUN /opt/venv/bin/pip install pandas
RUN /opt/venv/bin/pip install joblib
RUN /opt/venv/bin/pip install xlsxwriter tensorboard optuna-integration[pytorch_lightning]
RUN /opt/venv/bin/pip install pytorch-forecasting
RUN /opt/venv/bin/pip install scipy
RUN /opt/venv/bin/pip install --use-feature=fast-deps --upgrade pip

# 安装 NVIDIA 的额外包
RUN /opt/venv/bin/pip install --extra-index-url=https://pypi.nvidia.com \
    cudf-cu11==24.8.* dask-cudf-cu11==24.8.* cuml-cu11==24.8.* \
    cugraph-cu11==24.8.* cuspatial-cu11==24.8.* cuproj-cu11==24.8.* \
    cuxfilter-cu11==24.8.* cucim-cu11==24.8.* pylibraft-cu11==24.8.* \
    raft-dask-cu11==24.8.* cuvs-cu11==24.8.* nx-cugraph-cu11==24.8.*

# 设置环境变量
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV CUDA_HOME=/usr/local/cuda

# 创建工作目录
WORKDIR /app

# 设置默认的 shell，确保每次进入容器时激活 Python 虚拟环境
RUN echo "source /opt/venv/bin/activate" >> /root/.bashrc && \
    echo "source /opt/venv/bin/activate" >> /etc/bash.bashrc

# 设置镜像的默认命令为 bash
CMD ["/bin/bash", "-l"]