#!/bin/sh
# ******************************************************************************
#  Oracle WebLogic Server Docker image build file.
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
DOCKER_REGISTRY=docker
DOCKER_REGISTRY_NAMESPACE=remal
IMAGE_NAME_ADMIN=hello-welogic-world-admin-server
IMAGE_NAME_MANAGED=hello-welogic-world-managed-server
IMAGE_VERSION=1.0.0
PUSH_IMAGE=${1:-false}

# *******************************
# main program starts from here
# *******************************
echo -e "\n--> building admin-server image..."
cd oracle-weblogic-admin-server/
sh ./build.sh $DOCKER_REGISTRY $DOCKER_REGISTRY_NAMESPACE $IMAGE_NAME_ADMIN $IMAGE_VERSION $PUSH_IMAGE
cd ..

echo -e "\n--> building managed-server image..."
cd oracle-weblogic-managed-server
sh ./build.sh $DOCKER_REGISTRY $DOCKER_REGISTRY_NAMESPACE $IMAGE_NAME_MANAGED $IMAGE_VERSION $PUSH_IMAGE
cd ..
