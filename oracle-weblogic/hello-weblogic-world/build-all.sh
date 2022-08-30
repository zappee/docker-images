#!/bin/sh
# ******************************************************************************
#  Hello-weblogic-world Docker image build file.
#
#  Since : Jun, 2022
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Usage:
#     $ ./build.sh           build the image locally
#     $ ./build.sh true      build and push the image to the image registry
#
#  Copyright (c) 2020-2022 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
# ******************************************************************************
DOCKER_REGISTRY=docker
DOCKER_REGISTRY_NAMESPACE=remal
IMAGE_NAME_ADMIN=hello-welogic-world-admin-server
IMAGE_NAME_MANAGED=hello-welogic-world-managed-server
IMAGE_VERSION=2.0.1
PUSH_IMAGE=${1:-false}

echo "building the admin-server image..."
cd oracle-weblogic-admin-server/ || { echo "Error while trying to change directory from $(pwd) to oracle-weblogic-admin-server/"; exit 1; }
sh ./build.sh "$DOCKER_REGISTRY" "$DOCKER_REGISTRY_NAMESPACE" "$IMAGE_NAME_ADMIN" "$IMAGE_VERSION" "$PUSH_IMAGE"
cd ..

echo "building the managed-server image..."
cd oracle-weblogic-managed-server/ || { echo "Error while trying to change directory from $(pwd) to oracle-weblogic-managed-server/"; exit 1; }
sh ./build.sh "$DOCKER_REGISTRY" "$DOCKER_REGISTRY_NAMESPACE" "$IMAGE_NAME_MANAGED" "$IMAGE_VERSION" "$PUSH_IMAGE"
cd ..
