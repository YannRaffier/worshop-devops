#!/bin/bash

# ./.platforms/ci/run.sh
source .platforms/bootstrap.sh

# Lancement du projet
UserID=${UserID} GroupID=${GroupID} USER_HOME=${USER_HOME} WORKSPACE=${WORKSPACE} docker-compose -p ${PROJECT_NAME} -f .platforms/dev/docker-compose.yml up
