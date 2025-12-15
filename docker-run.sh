#!/bin/bash
# Docker run script for GNU Radio development
# Runs container as current user to avoid permission issues

IMAGE_NAME="gnuradio-dev"
CONTAINER_NAME="gnuradio-dev-container"

# Get current user info
USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER_NAME=$(id -un)

# Build the image if it doesn't exist
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Building Docker image '$IMAGE_NAME'..."
    docker build -t "$IMAGE_NAME" "$(dirname "$0")"
fi

# Build device arguments for USB access
DEVICE_ARGS=""
if [ -d /dev/bus/usb ]; then
    DEVICE_ARGS="$DEVICE_ARGS -v /dev/bus/usb:/dev/bus/usb"
fi
if [ -d /dev/serial ]; then
    DEVICE_ARGS="$DEVICE_ARGS -v /dev/serial:/dev/serial"
fi

# Run the container with:
# - Current user's UID/GID
# - Mount current directory to /src/gnuradio
# - Interactive terminal
# - Remove container on exit
# - X11 forwarding for GUI applications
# - USB device access for SDRs (privileged mode)
docker run -it --rm \
    --name "$CONTAINER_NAME" \
    --user "$USER_ID:$GROUP_ID" \
    --privileged \
    -v "$(pwd):/src/gnuradio" \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    -v "$HOME/.Xauthority:/home/$USER_NAME/.Xauthority:ro" \
    -e DISPLAY="$DISPLAY" \
    -e HOME="/home/$USER_NAME" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --network host \
    $DEVICE_ARGS \
    "$IMAGE_NAME" \
    "$@"
