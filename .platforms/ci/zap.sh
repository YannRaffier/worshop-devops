#!/bin/bash

# ./.platforms/ci/zap.sh
source ./.platforms/bootstrap.sh

SITE_URL="http://10.35.140.22:8000/api/"

# Répertoire où sont générés les rapport
OUTPUT_DIR="$WORKSPACE/reports"
mkdir -p $OUTPUT_DIR

# Paramètre Docker
DOCKER_COMMAND="zap-baseline.py -t $SITE_URL -g gen.conf -r report.html -I"
dockerRun "zap_proxy" "/zap/wrk" "-v $OUTPUT_DIR:/zap/wrk:rw -t" "owasp/zap2docker-stable:2.14.0" "$DOCKER_COMMAND"
