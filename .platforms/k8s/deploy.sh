#!/bin/bash

# cd workspace
# ./.platforms/k8s/deploy.sh prod

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

# Création du namespace (si besoin)
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Installation / upgrade
helm upgrade --recreate-pods --install --debug --namespace $NAMESPACE "workshop-devops-${DEPLOY_TO}" -f ./.platforms/k8s/helm/values-$DEPLOY_TO.yaml ./.platforms/k8s/helm
