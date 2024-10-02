#!/bin/bash

# Step 0: Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Step 1: Load image from .tar if it exists
if [ -f "/mnt/c/Users/cheng/Desktop/docker/ml_env_updated.tar" ]; then
    echo "Loading Docker image from ml_env_updated.tar..."
    docker load -i /mnt/c/Users/cheng/Desktop/docker/ml_env_updated.tar
    IMAGE_NAME="cheng19930723/ml_env_updated"
else
    echo "No .tar file found. Using the original image ml_env..."
    IMAGE_NAME="cheng19930723/ml_env"
fi

# Step 2: Remove any existing container with the same name
if [ "$(docker ps -aq -f name=my_linux_env_container)" ]; then
    echo "Removing existing container named 'my_linux_env_container'..."
    docker rm -f my_linux_env_container
fi

# Step 3: Run container and mount 'app' directory, use GPU
echo "Running new container from image '$IMAGE_NAME'..."
docker run --gpus all -it --name my_linux_env_container -v /mnt/c/Users/cheng/Desktop/docker/app:/app $IMAGE_NAME

# Step 4: Check if container still exists after stopping
if [ "$(docker ps -aq -f name=my_linux_env_container)" ]; then
    # Ask user if they want to save the container as a new image
    read -p "Do you want to save the container as a new image? (y/n) " SAVE_RESPONSE
    if [[ "$SAVE_RESPONSE" == "y" || "$SAVE_RESPONSE" == "Y" ]]; then
        read -p "Enter the tag for the new image (default: ml_env_updated): " NEW_TAG
        NEW_TAG=${NEW_TAG:-ml_env_updated}

        echo "Saving container as a new image with tag '$NEW_TAG'..."
        docker commit my_linux_env_container "$NEW_TAG"
        docker save -o /mnt/c/Users/cheng/Desktop/docker/${NEW_TAG}.tar "$NEW_TAG"
        echo "Container saved and exported as ${NEW_TAG}.tar"

        # Step 5: Ask if the user wants to push the new image
        read -p "Do you want to push the new image to a remote repository? (y/n) " PUSH_RESPONSE
        if [[ "$PUSH_RESPONSE" == "y" || "$PUSH_RESPONSE" == "Y" ]]; then
            read -p "Enter the remote repository URL (default: cheng19930723/ml_env:latest): " REPO_URL
            REPO_URL=${REPO_URL:-cheng19930723/ml_env:latest}
            docker tag "$NEW_TAG" "$REPO_URL"
            docker push "$REPO_URL"
            echo "Image pushed to $REPO_URL"
        fi
    fi

    # Step 6: Remove container after saving
    echo "Removing container 'my_linux_env_container'..."
    docker rm my_linux_env_container
else
    echo "Container 'my_linux_env_container' not found."
fi

echo "Script execution completed."