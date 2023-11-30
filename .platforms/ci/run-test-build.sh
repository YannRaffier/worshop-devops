#!/bin/bash

# ./.platforms/ci/run.sh
source .platforms/bootstrap.sh

# Lancement du projet
USER_HOME=${USER_HOME} WORKSPACE=${WORKSPACE} docker compose -p ${PROJECT_NAME} -f .platforms/ci/docker-compose/docker-compose-test-build.yml up
