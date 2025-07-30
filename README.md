# 仓库概览

## 支持平台/架构

✅ Linux/Amd64
❌ Linux/Arm64

---

## 更新日志
**2025年7月30日**： 
    * 增加支持`pytorch_tabular`。
    
**2025年5月8日**：
* **基础镜像更新**: 采用 `nvcr.io/nvidia/pytorch:24.04-py3`。
    * 该基础镜像包含：Ubuntu 22.04, Python 3.10, NVIDIA CUDA 12.4, cuDNN 9.1.0.70, NCCL 2.21.5, RAPIDS 24.02, TensorRT 8.6.3, PyTorch, TensorBoard 2.9.0, JupyterLab 2.3.2, TransformerEngine 1.5 等。
* **CMake 版本**: 安装 CMake 3.30.4。
* **新增库**:
    * 添加 `xarray` 和 `cftime` (用于长时间序列数据)。
    * 编译并安装 `mamba-ssm` 及其依赖 `causal-conv1d`。
* **RAPIDS 更新**: 在虚拟环境中安装 RAPIDS 25.4.* (针对 CUDA 12.x)，这将优先于基础镜像中的 RAPIDS 24.02。
* **移除**: 移除了 `LightGBM` 的支持。
* **系统依赖**: 添加了 `postgresql-client` 和 `mysql-client`。
* **Python 环境**:
    * Python 虚拟环境 (`/opt/venv`) 使用 `python3 -m venv --system-site-packages` 创建，可访问基础镜像的系统级 Python 包。
    * 显式安装的 Python 包包括 (在虚拟环境中): `psycopg2-binary`, `asyncpg`, `sqlalchemy`, `tenacity`, `mysql-connector-python`, `pymysql`, `xgboost`, `catboost`, `optuna`, `lightning`, `openpyxl`, `neuralprophet`, `scikit-learn`, `pandas`, `joblib`, `xlsxwriter`, `tensorboard` (虚拟环境内版本), `optuna-integration[pytorch_lightning]`, `pytorch-forecasting`, `scipy`。

**2024年10月18日**：添加 `mySQL`、`PostgreSQL` 支持，以及 `tenacity`、`sqlalchemy`包。

**2024年10月4日**：添加 `xlsxwriter`、`tensorboard`，以及 `optuna-integration[pytorch_lightning]` 包。

**2024年10月2日**：测试完成。添加 `sklearn` 包，更新 `Cmake` 至 3.30.4 版本。添加 `joblib` 和 `pytorch-forecasting` 包。(注意: LightGBM 支持后被移除)

---

## English Version

This Docker image provides an optimized environment for machine learning tasks with NVIDIA GPU acceleration, based on the NVIDIA PyTorch container (Release 24.04).

**Base Image (`nvcr.io/nvidia/pytorch:24.04-py3`) Highlights:**
* **OS:** Ubuntu 22.04
* **Python:** Python 3.10
* **NVIDIA Stack:** CUDA 12.4, cuDNN 9.1.0.70, cuBLAS 12.4.5.8, NCCL 2.21.5
* **Pre-installed NVIDIA Libraries:** RAPIDS™ 24.02, NVIDIA TensorRT™ 8.6.3, Torch-TensorRT 2.3.0a0, NVIDIA DALI® 1.36
* **Pre-installed Tools:** PyTorch, TorchVision, TorchAudio, TensorBoard 2.9.0, JupyterLab 2.3.2, TransformerEngine 1.5, Nsight Compute/Systems.

**Key Features of This Derived Image:**

1.  **Enhanced CUDA Ecosystem:**
    -   Leverages CUDA 12.4, cuDNN 9.1.0.70, cuBLAS 12.4.5.8, and NCCL 2.21.5 from the base image for robust GPU acceleration.

2.  **Python 3.10 Virtual Environment:**
    -   A Python 3.10 virtual environment (`/opt/venv`) is created with `--system-site-packages`, allowing access to base image packages (like PyTorch, TensorBoard 2.9.0, JupyterLab 2.3.2, TensorRT, etc.).

3.  **Up-to-date Development Tools:**
    -   Includes essential development tools (`build-essential`, Git), CMake version 3.30.4, and client tools for PostgreSQL (`postgresql-client`) and MySQL (`mysql-client`).

4.  **OpenCL Support:**
    -   Provides OpenCL and CUDA-related dependencies for broad GPU workload compatibility.

5.  **Curated Python Libraries in Virtual Environment:**
    -   **Core ML/DL (from base, accessible in venv):** `PyTorch`, `TorchVision`, `TorchAudio`, `TensorRT`.
    -   **Sequence Modeling (installed in venv):** `Mamba-SSM` (built from source with `causal-conv1d`).
    -   **Gradient Boosting (installed in venv):** `XGBoost`, `CatBoost`.
    -   **General ML & Data Processing (installed in venv):** `scikit-learn`, `Pandas`, `SciPy`, `Joblib`,`pytorch_tabular`.
    -   **Time Series (installed in venv):** `NeuralProphet`, `pytorch-forecasting`, `Xarray`, `CFTime`.
    -   **Hyperparameter Optimization & Training (installed in venv):** `Optuna` (with `optuna-integration[pytorch_lightning]`), `Lightning`.
    -   **Database Connectivity (installed in venv):** `SQLAlchemy`, `Tenacity`, `psycopg2-binary` (PostgreSQL), `mysql-connector-python`, `pymysql` (MySQL).
    -   **Utilities (installed in venv):** `Openpyxl`, `XlsxWriter`, `TensorBoard` (venv version), `Ninja`.

6.  **Latest RAPIDS Suite:**
    -   While the base image includes RAPIDS 24.02, this image installs NVIDIA RAPIDS libraries version `25.4.*` (for CUDA 12, e.g., `cudf-cu12`, `cuml-cu12`, `cugraph-cu12`) into the virtual environment. This version will be active when the venv is sourced.

7.  **Optimized Environment Configuration:**
    -   Proper configuration of CUDA (`CUDA_HOME`, `LD_LIBRARY_PATH`) and Python environment variables (`VIRTUAL_ENV`, `PATH`). The virtual environment is activated by default in `.bashrc` and `/etc/bash.bashrc`.

8.  **Ease of Use:**
    -   The default shell (`/bin/bash -l`) starts with an activated virtual environment, ready for immediate use.

This image is ideal for researchers and data scientists needing a GPU-accelerated environment that comes pre-configured with a comprehensive suite of ML libraries, offering the flexibility to compile custom GPU-optimized software.

---

## 中文版

这个 Docker 镜像基于 NVIDIA PyTorch 容器 (24.04 版本)，提供了一个经过优化的环境，用于使用 NVIDIA GPU 加速的机器学习任务。

**基础镜像 (`nvcr.io/nvidia/pytorch:24.04-py3`) 主要特性:**
* **操作系统:** Ubuntu 22.04
* **Python 版本:** Python 3.10
* **NVIDIA 技术栈:** CUDA 12.4, cuDNN 9.1.0.70, cuBLAS 12.4.5.8, NCCL 2.21.5
* **预装 NVIDIA 库:** RAPIDS™ 24.02, NVIDIA TensorRT™ 8.6.3, Torch-TensorRT 2.3.0a0, NVIDIA DALI® 1.36
* **预装工具:** PyTorch, TorchVision, TorchAudio, TensorBoard 2.9.0, JupyterLab 2.3.2, TransformerEngine 1.5, Nsight Compute/Systems.

**此衍生镜像的主要特点:**

1.  **增强的 CUDA 生态系统:**
    -   利用基础镜像提供的 CUDA 12.4, cuDNN 9.1.0.70, cuBLAS 12.4.5.8 和 NCCL 2.21.5，实现强大的 GPU 加速。

2.  **Python 3.10 虚拟环境:**
    -   创建了一个 Python 3.10 虚拟环境 (`/opt/venv`)，并使用 `--system-site-packages` 选项，允许访问基础镜像的包（如 PyTorch, TensorBoard 2.9.0, JupyterLab 2.3.2, TensorRT 等）。

3.  **最新的开发工具:**
    -   包含必要的开发工具（`build-essential`、Git）、CMake 3.30.4 版本，以及 PostgreSQL (`postgresql-client`) 和 MySQL (`mysql-client`) 的客户端工具。

4.  **OpenCL 支持:**
    -   提供 OpenCL 和 CUDA 相关依赖，确保对广泛的 GPU 计算工作负载的兼容性。

5.  **精心挑选的 Python 虚拟环境库:**
    -   **核心机器学习/深度学习 (来自基础镜像, venv中可访问):** `PyTorch`, `TorchVision`, `TorchAudio`, `TensorRT`。
    -   **序列建模 (安装于 venv):** `Mamba-SSM` (与 `causal-conv1d` 一同从源码编译)。
    -   **梯度提升 (安装于 venv):** `XGBoost`, `CatBoost`。
    -   **通用机器学习与数据处理 (安装于 venv):** `scikit-learn`, `Pandas`, `SciPy`, `Joblib`,`pytorch_tabular`。
    -   **时间序列 (安装于 venv):** `NeuralProphet`, `pytorch-forecasting`, `Xarray`, `CFTime`。
    -   **超参数优化与训练 (安装于 venv):** `Optuna` (及 `optuna-integration[pytorch_lightning]`)、`Lightning`。
    -   **数据库连接 (安装于 venv):** `SQLAlchemy`, `Tenacity`, `psycopg2-binary` (PostgreSQL)、`mysql-connector-python`、`pymysql` (MySQL)。
    -   **实用工具 (安装于 venv):** `Openpyxl`, `XlsxWriter`, `TensorBoard` (venv 内版本)、`Ninja`。

6.  **最新的 RAPIDS 套件:**
    -   尽管基础镜像包含 RAPIDS 24.02，此镜像在虚拟环境中安装了 NVIDIA RAPIDS 库 `25.4.*` 版本 (针对 CUDA 12，例如 `cudf-cu12`, `cuml-cu12`, `cugraph-cu12` 等)。当虚拟环境被激活时，此版本将优先使用。

7.  **优化的环境配置:**
    -   正确配置了 CUDA (`CUDA_HOME`, `LD_LIBRARY_PATH`) 和 Python 环境变量 (`VIRTUAL_ENV`, `PATH`)。虚拟环境已在 `.bashrc` 和 `/etc/bash.bashrc` 中设置为默认激活。

8.  **使用简便:**
    -   默认 shell (`/bin/bash -l`) 启动时会激活虚拟环境，使数据科学和机器学习任务的使用变得更加简单便捷。

这个镜像非常适合需要 GPU 加速环境的研究人员和数据科学家，它预配置了一套全面的机器学习库，并具备编译自定义 GPU 优化软件的灵活性。

---

# 如何使用此 Docker 镜像

## 主机要求

要在 Docker 容器内部利用 GPU 功能，主机必须安装以下软件：

### 1. Docker
确保您的主机已安装 Docker。您可以参考官方 Docker 安装指南：[点此查看](https://docs.docker.com/get-docker/)。

### 2. NVIDIA 驱动程序
主机上必须安装适用于您 GPU 的 NVIDIA 驱动程序。该驱动程序允许 GPU 硬件与 Docker 容器通信。

### 3. NVIDIA Container Toolkit
您需要安装 NVIDIA Container Toolkit 以在 Docker 容器中启用 GPU 支持。该工具包允许 Docker 访问 GPU 硬件。请按照以下步骤操作：

#### 安装步骤

1.  **设置软件包仓库并安装依赖项**：
    ```sh
    curl -fsSL [https://nvidia.github.io/libnvidia-container/gpgkey](https://nvidia.github.io/libnvidia-container/gpgkey) | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L [https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list](https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list) | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update
    ```

2.  **安装 NVIDIA Container Toolkit**：
    ```sh
    sudo apt-get install -y nvidia-container-toolkit
    ```

3.  **重启 Docker**：
    ```sh
    sudo systemctl restart docker
    ```
安装 NVIDIA Container Toolkit 后，您可以使用 `--gpus` 标志运行支持 GPU 的 Docker 容器，如下面的 Docker 镜像运行说明所示。
更多详细信息，请参阅官方 NVIDIA 文档：[NVIDIA Container Toolkit 文档](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)。

## 拉取 Docker 镜像

首先，您可以使用以下命令从 Docker Hub 拉取 Docker 镜像：

```sh
docker pull cheng19930723/ml_env
```
此命令会将最新版本的镜像下载到您的本地系统。

## 运行 Docker 容器

要使用下载的镜像运行容器，您可以使用以下命令：
```sh
docker run --gpus all -it --name my_linux_env_container -v <local_directory>:/app cheng19930723/ml_env
```
说明：
-   `--gpus all`: 启用 GPU 支持，允许容器使用您机器上所有可用的 GPU。
-   `-it`: 以交互模式运行容器并分配一个 TTY 会话。
-   `--name my_linux_env_container`: 将容器命名为 `my_linux_env_container` 以方便引用。
-   `-v <local_directory>:/app`: 将本地目录 (`<local_directory>`) 挂载到容器内的 `/app` 目录。请将 `<local_directory>` 替换为您要与容器共享的文件夹的绝对路径。

### 示例：
如果您想将本地目录 `/home/user/project` 挂载到容器内的 `/app` 目录，命令如下：
```sh
docker run --gpus all -it --name my_linux_env_container -v /home/user/project:/app cheng19930723/ml_env
