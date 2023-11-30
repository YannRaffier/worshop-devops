#!/bin/bash

# cd workspace
# ./.platforms/k8s/undeploy.sh prod

DEPLOY_TO="local"
NAMESPACE="workshop"

# Environnement cible (valid, prod, etc)
#DEPLOY_TO=$1
#if [ "$DEPLOY_TO" = "prod" ]; then
#  echo "Déploiement sur l'environnement de Prod"
#  NAMESPACE="workshop-prod"
#else
#  echo "Déploiement sur l'environnement Local"
#  DEPLOY_TO="local"
#  NAMESPACE="workshop"
#fi

# Désinstallation
helm --namespace $NAMESPACE delete workshop-devops-${DEPLOY_TO}