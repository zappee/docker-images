#!/bin/sh
# ******************************************************************************
#  Oracle WebLogic 12.2.1.4.0 Managed Server docker image build file.
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
DOCKER_REGISTRY="$1"
DOCKER_REGISTRY_NAMESPACE="$2"
IMAGE_NAME="$3"
IMAGE_VERSION="$4"
PUSH_IMAGE="$5"

docker build --no-cache -t "$DOCKER_REGISTRY/$DOCKER_REGISTRY_NAMESPACE/$IMAGE_NAME":"$IMAGE_VERSION" .
docker rmi "$(docker image ls -qf dangling=true)"

if [ "$PUSH_IMAGE" = "true" ] ; then
    echo "pushing the image to the registry..."
    docker push "$DOCKER_REGISTRY/$DOCKER_REGISTRY_NAMESPACE/$IMAGE_NAME":"$IMAGE_VERSION"
fi
