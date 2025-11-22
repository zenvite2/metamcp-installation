#!/bin/bash

# Get the current user information
USER_NAME=$(whoami)
USER_UID=$(id -u)
USER_GID=$(id -g)
USER_HOME="/home/$USER_NAME"

# Get the Docker group ID from the host system
DOCKER_GID=$(getent group docker | cut -d: -f3)

# If we couldn't get the Docker group ID, default to 999
if [ -z "$DOCKER_GID" ]; then
    echo "Could not determine Docker group ID, defaulting to 999"
    DOCKER_GID=999
else
    echo "Found Docker group ID: $DOCKER_GID"
fi

# Update the .env file with the user information and Docker group ID
sed -i "s/^HOST_UID=.*/HOST_UID=$USER_UID/" .env
sed -i "s/^HOST_GID=.*/HOST_GID=$USER_GID/" .env
sed -i "s/^USER_NAME=.*/USER_NAME=$USER_NAME/" .env
sed -i "s#^USER_HOME=.*#USER_HOME=$USER_HOME#" .env
sed -i "s/^DOCKER_GID=.*/DOCKER_GID=$DOCKER_GID/" .env

echo "Updated .env file with:"
echo "  USER_NAME=$USER_NAME"
echo "  HOST_UID=$USER_UID"
echo "  HOST_GID=$USER_GID"
echo "  USER_HOME=$USER_HOME"
echo "  DOCKER_GID=$DOCKER_GID"