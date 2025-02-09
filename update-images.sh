#!/bin/bash

eval $(minikube -p minikube docker-env)
# Get the current directory
BASE_DIR=$(pwd)

# Loop through each subdirectory (1 level deep)
for dir in */ ; do
    # Remove the trailing slash to get the folder name
    FOLDER_NAME=$(basename "$dir")

    # Check if it's a directory
    if [ -d "$dir" ]; then
        echo "Processing $FOLDER_NAME..."

        # Change to the directory
        cd "$BASE_DIR/$FOLDER_NAME" || exit
        IMAGE_NAME=localhost:5000/betting-app/$FOLDER_NAME
        # Execute Maven command
        mvn clean spring-boot:build-image -Dspring-boot.build-image.imageName="$IMAGE_NAME"
        docker push "$IMAGE_NAME"

        # Return to the base directory
        cd "$BASE_DIR" || exit
    fi
done
