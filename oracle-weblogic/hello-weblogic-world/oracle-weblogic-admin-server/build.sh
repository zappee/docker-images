#!/bin/sh
# ******************************************************************************
#  Oracle WebLogic Administration Server docker image build file.
#
#  Since : July, 2021
#  Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
#  Copyright (c) 2020-2021 Remal Software and Arnold Somogyi All rights reserved
#  BSD (2-clause) licensed
#
#  Usage:
#     $ ./build.sh           build the image locally
#     $ ./build.sh true      build and push the image to the image registry
# ******************************************************************************
DOCKER_REGISTRY=$1
DOCKER_REGISTRY_NAMESPACE=$2
IMAGE_NAME=$3
IMAGE_VERSION=$4
PUSH_IMAGE=$5

echo "DOCKER_REGISTRY:           "$DOCKER_REGISTRY
echo "DOCKER_REGISTRY_NAMESPACE: "$DOCKER_REGISTRY_NAMESPACE
echo "IMAGE_NAME:                "$IMAGE_NAME
echo "IMAGE_VERSION:             "$IMAGE_VERSION
echo "PUSH_IMAGE:                "$PUSH_IMAGE

docker build --no-cache -t $DOCKER_REGISTRY/$DOCKER_REGISTRY_NAMESPACE/$IMAGE_NAME:$IMAGE_VERSION .
docker rmi $(docker image ls -qf dangling=true)

# upload image to GitLab image registry
if [ "$PUSH_IMAGE" = true ] ; then
    echo "pushing the image to the registry..."
    docker push $DOCKER_REGISTRY/$DOCKER_REGISTRY_NAMESPACE/$IMAGE_NAME:$IMAGE_VERSION
fi
