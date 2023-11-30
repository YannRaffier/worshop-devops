#!/bin/bash

# ./.platforms/ci/package.sh --with-push
source .platforms/bootstrap.sh
source .env

# Registry Docker
DOCKER_REGISTRY="localhost:18044"

# Package Back Office Docker Image
docker build -t workshop-devops -f ".platforms/ci/dockerfiles/Dockerfile-App" .
docker tag workshop-devops "${DOCKER_REGISTRY}/workshop/workshop-devops:${PROJECT_VERSION}"

# Push Docker Image
if [ "$1" = "--with-push" ]; then
  docker push "${DOCKER_REGISTRY}/workshop/workshop-devops:${PROJECT_VERSION}"
fi
