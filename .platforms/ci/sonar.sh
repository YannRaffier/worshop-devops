#!/bin/bash

# ./.platforms/ci/sonar.sh
source .platforms/bootstrap.sh

# Lancer une conteneur qui va analyser le code du projet localement et ensuite envoyer les résultats au serveur SonarQube
SONAR_IMAGE_EXTRA_OPTS="-v ${WORKSPACE}/sources:${WORKDIR} -v /etc/hosts:/etc/hosts"
dockerRun "sonar-scanner" "${WORKDIR}" "${SONAR_IMAGE_EXTRA_OPTS}" "sonarsource/sonar-scanner-cli:4.8.1" "sonar-scanner -X $SONAR_PARAMS"
