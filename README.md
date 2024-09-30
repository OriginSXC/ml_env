# ml_env
My machine-learning environment setup
## Support Platform/Arch
- [x]  Linux/Amd64
- [ ]  Linux/Arm64
[docker_hub]([https://example.com](https://hub.docker.com/repository/docker/cheng19930723/ml_env/general))

## English Version

This Docker image provides an optimized environment for machine learning tasks with NVIDIA GPU acceleration. The key features of this image are:

1. **CUDA and CUDNN Support:**
   - Based on NVIDIA's CUDA 11.8 image with CUDNN, enabling GPU-accelerated computation for deep learning models.

2. **Python 3.11 Environment:**
   - Python 3.11 is installed and set as the default version, providing compatibility with modern Python libraries and features.

3. **Development Tools:**
   - Includes essential development tools (`build-essential`, Git) and the latest CMake (version 3.28+) for compiling software, allowing users to build machine learning packages from source.

4. **OpenCL and CUDA Libraries:**
   - Provides OpenCL and CUDA-related dependencies for GPU-based computation, ensuring compatibility for a wide range of ML workloads.

5. **LightGBM with CUDA:**
   - LightGBM is compiled with CUDA support for GPU-accelerated training, installed globally for accessibility across environments.

6. **Python Virtual Environment:**
   - A virtual environment is created with access to system-level packages, containing key ML libraries to streamline development, including:
     - `PyTorch`, `TorchVision`, `TorchAudio`: Deep learning libraries for model building and audio/image processing.
     - `XGBoost`, `CatBoost`: Gradient boosting frameworks for decision trees.
     - `Optuna`: A hyperparameter optimization framework for machine learning models.
     - `Openpyxl`: A library to read/write Excel files.
     - `NeuralProphet`: A tool for time-series forecasting based on Facebook Prophet.

7. **RAPIDS Suite for GPU Acceleration:**
   - NVIDIA RAPIDS libraries (`cuDF`, `cuML`, `cuGraph`, etc.) are included for accelerated data manipulation and processing, improving the performance of large-scale data tasks.

8. **Environment Configuration:**
   - Proper configuration of CUDA and Python environment variables ensures that the GPU and Python tools are available and easy to use.

9. **Ease of Use:**
   - The default shell starts with an activated virtual environment, making the image easy to use for data science and machine learning tasks immediately.

This image is ideal for researchers and data scientists needing a GPU-accelerated environment that comes pre-configured with popular ML libraries, offering the flexibility to compile custom GPU-optimized software.

---

## 中文版

这个 Docker 镜像提供了一个经过优化的环境，用于使用 NVIDIA GPU 加速的机器学习任务。该镜像的主要特点包括：

1. **CUDA 和 CUDNN 支持：**
   - 基于 NVIDIA CUDA 11.8 镜像并包含 CUDNN，支持深度学习模型的 GPU 加速计算。

2. **Python 3.11 环境：**
   - 安装 Python 3.11 并设置为默认版本，提供对现代 Python 库和特性的兼容性。

3. **开发工具：**
   - 包含必要的开发工具（`build-essential`、Git）以及最新的 CMake（版本 3.28+），方便用户编译机器学习相关的软件包。

4. **OpenCL 和 CUDA 库：**
   - 提供 OpenCL 和 CUDA 相关依赖，确保对基于 GPU 的计算兼容，适用于多种机器学习工作负载。

5. **LightGBM 支持 CUDA：**
   - 使用 CUDA 支持编译了 LightGBM，可在 GPU 上进行加速训练，并全局安装以便跨环境访问。

6. **Python 虚拟环境：**
   - 创建了一个虚拟环境，能够访问系统级别的软件包，并包含关键的机器学习库以简化开发过程，包括：
     - `PyTorch`、`TorchVision`、`TorchAudio`：用于模型构建以及音频/图像处理的深度学习库。
     - `XGBoost`、`CatBoost`：基于决策树的梯度提升框架。
     - `Optuna`：用于机器学习模型的超参数优化框架。
     - `Openpyxl`：用于读取/写入 Excel 文件的库。
     - `NeuralProphet`：基于 Facebook Prophet 的时间序列预测工具。

7. **RAPIDS GPU 加速套件：**
   - 包含 NVIDIA RAPIDS 库（`cuDF`、`cuML`、`cuGraph` 等），用于加速数据处理和分析，提高大规模数据任务的性能。

8. **环境配置：**
   - 适当配置了 CUDA 和 Python 环境变量，确保 GPU 和 Python 工具的可用性和易用性。


9. **使用简便：**
   - 默认 shell 启动时会激活虚拟环境，使数据科学和机器学习任务的使用变得更加简单便捷。

这个镜像非常适合需要 GPU 加速环境的研究人员和数据科学家，提供了预先配置的流行机器学习库，并具备编译自定义 GPU 优化软件的灵活性。

---
# How to Use This Docker Image
## Host Machine Requirements

To utilize the GPU capabilities inside the Docker container, the host machine must have the following installed:

### 1. Docker
Ensure Docker is installed on your host machine. You can follow the official Docker installation guide [here](https://docs.docker.com/get-docker/).

### 2. NVIDIA Driver
The appropriate NVIDIA driver for your GPU must be installed on the host machine. The driver allows the GPU hardware to communicate with the Docker container.

### 3. NVIDIA Container Toolkit
You need to install the NVIDIA Container Toolkit to enable GPU support in Docker containers. The toolkit allows Docker to access the GPU hardware. Follow these steps:

#### Installation Steps

1. **Set Up the Package Repository and Install Dependencies**:

   ```sh
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
   curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
   sudo apt-get update
   ```

2. **Install the NVIDIA Container Toolkit**:

   ```sh
   sudo apt-get install -y nvidia-docker2
   ```

3. **Restart Docker**:
   ```sh
   sudo systemctl restart docker
   ```

After installing the NVIDIA Container Toolkit, you can run Docker containers with GPU support using the '--gpus' flag, as shown in the usage instructions for running the Docker image.
## Pulling the Docker Image
For more details, refer to the official NVIDIA documentation: NVIDIA Container Toolkit Documentation.

## To get started, you can pull the Docker image from Docker Hub using the following command:

```sh
docker pull cheng19930723/ml_env
```
This command will download the latest version of the image to your local system.

## Running the Docker Container
To run a container using the downloaded image, you can use the following command:
```sh
docker run --gpus all -it --name my_linux_env_container -v <local_directory>:/app cheng19930723/ml_env
```
Explanation:
- `--gpus all`: Enables GPU support, allowing the container to use all available GPUs on your machine.
- `-it`: Runs the container in interactive mode with a TTY session.
- `--name my_linux_env_container`: Names the container as my_linux_env_container for easy reference.
- `-v <local_directory>:/app`: Mounts a local directory (<local_directory>) to the /app directory inside the container. Replace <local_directory> with the absolute path to the folder you want to share with the container.
### Example:
If you want to mount a local directory /home/user/project to the /app directory in the container, the command would be:
```sh
docker run --gpus all -it --name my_linux_env_container -v /home/user/project:/app cheng19930723/ml_env
```





