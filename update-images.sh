#!/bin/bash

# Set up Docker environment for Minikube
eval $(minikube -p minikube docker-env)

# Get the current directory
BASE_DIR=$(pwd)

# Check if an argument was provided
if [ -n "$1" ]; then
    IFS=',' read -r -a SERVICES <<< "$1"
else
    # If no argument is provided, get all subdirectories
    mapfile -t SERVICES < <(find . -maxdepth 1 -type d -not -path '.' -exec basename {} \;)
fi

# Loop through the specified services
for FOLDER_NAME in "${SERVICES[@]}"; do
    if [ -d "$FOLDER_NAME" ]; then
        echo "Processing $FOLDER_NAME..."

        # Change to the directory
        cd "$BASE_DIR/$FOLDER_NAME" || exit
        IMAGE_NAME=localhost:5000/betting-app/$FOLDER_NAME

        # Execute Maven command
        mvn clean spring-boot:build-image -Dspring-boot.build-image.imageName="$IMAGE_NAME"
        docker push "$IMAGE_NAME"

        # Return to the base directory
        cd "$BASE_DIR" || exit
    else
        echo "Skipping $FOLDER_NAME: Directory not found."
    fi
done