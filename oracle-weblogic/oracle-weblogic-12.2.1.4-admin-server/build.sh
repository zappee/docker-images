#!/bin/sh

# ******************************************************************************
#  Oracle WebLogic Server 12.2.1.4.0 Administration Server Dockerfile.
#
#  Since : February, 2021
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
#
#  Usage:
#     $ ./build.sh           build the image locally
#     $ ./build.sh true      build and push the image to the image registry
# ******************************************************************************
DOCKER_REGISTRY=docker
DOCKER_REGISTRY_NAMESPACE=remal
IMAGE_NAME=oracle-weblogic-admin-12.2.1.4
IMAGE_VERSION=1.1.0
PUSH_IMAGE=${1:-false}

docker build --no-cache -t $DOCKER_REGISTRY/$DOCKER_REGISTRY_NAMESPACE/$IMAGE_NAME:$IMAGE_VERSION .
docker rmi "$(docker image ls -qf dangling=true)"

if [ "$PUSH_IMAGE" = "true" ] ; then
    echo "pushing the image to the registry..."
    docker push $DOCKER_REGISTRY/$DOCKER_REGISTRY_NAMESPACE/$IMAGE_NAME:$IMAGE_VERSION
fi
