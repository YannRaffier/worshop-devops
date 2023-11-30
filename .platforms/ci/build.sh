#!/bin/bash

# cd workspace
# ./.platforms/ci/build.sh
source .platforms/bootstrap.sh

# Compilation
DOCKER_EXTRA_OPTS="-v ${WORKSPACE}/sources:/code -v $USER_HOME/.m2:/root/.m2"
docker run --rm --name "builder" -w /code ${DOCKER_EXTRA_OPTS} maven:3.8.5-openjdk-17 //bin/bash -c 'mvn clean package -Dmaven.wagon.http.ssl.insecure=true'
# dockerRun "${PROJECT_NAME}-mvn-builder" "${WORKDIR}" "${DOCKER_EXTRA_OPTS}" "maven:3.8.5-openjdk-17" "mvn clean package -Dmaven.wagon.http.ssl.insecure=true"

# Fix permission
chmod 777 -R ${WORKSPACE}/sources/target