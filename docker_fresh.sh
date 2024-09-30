#!/bin/bash

# Step 1: Check if the .tar file exists, if so load the image
if [ -f "/mnt/c/Users/cheng/Desktop/docker/ml_env_updated.tar" ]; then
    # Load the image if the ml_env_updated.tar file exists
    docker load -i /mnt/c/Users/cheng/Desktop/docker/ml_env_updated.tar
    IMAGE_NAME="ml_env_updated"
else
    # If the .tar file does not exist, use the original image ml_env
    IMAGE_NAME="ml_env"
fi

# Step 2: Remove any existing container with the same name (if exists)
if [ "$(docker ps -aq -f name=my_linux_env_container)" ]; then
    echo "Removing existing container with the name 'my_linux_env_container'..."
    docker rm -f my_linux_env_container
fi

# Step 3: Run the container and mount 'app' directory, use GPU for computation
docker run --gpus all -it --name my_linux_env_container -v /mnt/c/Users/cheng/Desktop/docker/app:/app $IMAGE_NAME

# Step 4: Save container as a new image after it stops
echo "Saving container as a new image..."
if [ "$(docker ps -aq -f name=my_linux_env_container)" ]; then
    docker commit my_linux_env_container ml_env_updated
    docker save -o /mnt/c/Users/cheng/Desktop/docker/ml_env_updated.tar ml_env_updated
    echo "Container saved and exported to ml_env_updated.tar"
else
    echo "No such container found to save."
fi

# Step 5: Remove the container after saving
if [ "$(docker ps -aq -f name=my_linux_env_container)" ]; then
    docker rm my_linux_env_container
fi
