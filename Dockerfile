# 使用指定的 NVIDIA CUDA 基础镜像，包含 nvcc
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# 切换到 root 用户以获得足够权限
USER root

# 更新包列表并安装 wget 和依赖工具
RUN apt-get update && \
    apt-get install -y wget curl sudo && \
    rm -rf /var/lib/apt/lists/*

# 安装 Python 3.11 和相关工具
RUN apt-get update && \
    apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

# 安装构建工具，包括 Git
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git && \
    rm -rf /var/lib/apt/lists/*

# 安装 OpenCL 相关的工具
RUN apt-get update && \
    apt-get install -y \
    ocl-icd-libopencl1 \
    ocl-icd-opencl-dev \
    clinfo && \
    rm -rf /var/lib/apt/lists/*

# 移除旧版 CMake
# RUN apt-get remove -y cmake

# 下载并安装新版 CMake 3.28+
RUN wget https://github.com/Kitware/CMake/releases/download/v3.28.0/cmake-3.28.0-linux-x86_64.sh && \
    chmod +x cmake-3.28.0-linux-x86_64.sh && \
    ./cmake-3.28.0-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.28.0-linux-x86_64.sh

# 安装 LightGBM 编译的依赖
RUN apt-get update && \
    apt-get install -y \
    libboost-dev \
    libboost-system-dev \
    libboost-filesystem-dev && \
    rm -rf /var/lib/apt/lists/*

# 设置 Python 3.11 为默认 Python 版本
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# 创建 python 指向 python3 的符号链接
RUN ln -s /usr/bin/python3 /usr/bin/python

# 克隆 LightGBM 仓库并编译 CUDA 版本并安装到系统环境中
RUN git clone --recursive https://github.com/microsoft/LightGBM && \
    cd LightGBM && \
    mkdir build && \
    cd build && \
    cmake -DUSE_CUDA=1 .. && \
    make -j4 && \
    cd ../ && \
    pip install --upgrade pip && \
    sh ./build-python.sh install --precompile

# 创建虚拟环境，允许使用系统环境中的包
RUN python3 -m venv /opt/venv --system-site-packages

# 激活虚拟环境并安装其他 Python 包到虚拟环境中
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    /opt/venv/bin/pip install \
    xgboost catboost optuna lightning openpyxl neuralprophet && \
    /opt/venv/bin/pip install \
    --extra-index-url=https://pypi.nvidia.com \
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
RUN echo "source /opt/venv/bin/activate" >> /root/.bashrc

# 设置镜像的默认命令为 bash，激活虚拟环境
CMD ["bash", "-l", "-c", "source /opt/venv/bin/activate && exec /bin/bash"]
