#!/bin/bash
# Make sure you are using buildx and have the qemu binaries installed
# Make sure you are logged in to push to your image registry

# DOCKER_PLATFORMS="linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6,linux/mipsle,darwin/arm64,darwin/amd64,windows/amd64"

# Cannot build darwin/arm64,darwin/amd64 because it will use 'strip' instead of 'llvm-strip'
DOCKER_PLATFORMS="linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6,linux/mipsle,windows/amd64"
DOCKER_IMAGE=ghcr.io/slazurin/pppwn_cpp
docker buildx build -t "$DOCKER_IMAGE" --platform "$DOCKER_PLATFORMS" --push .
mkdir -p build
# docker run --rm -v "$(pwd)/build:/host" pppwn