#!/bin/bash

# ./.platforms/tools/run.sh
source .platforms/bootstrap.sh

# Création des répertoires
sudo mkdir -p /var/jenkins_home
sudo chmod 777 -R /var/jenkins_home

sudo mkdir -p /opt/workshop/nexus/nexus-data
sudo mkdir -p /opt/workshop/sonarqube/conf
sudo mkdir -p /opt/workshop/sonarqube/data
sudo mkdir -p /opt/workshop/sonarqube/extensions
sudo mkdir -p /opt/workshop/sonarqube/logs
sudo mkdir -p /opt/workshop/sonarqube/temp
sudo mkdir -p /opt/workshop/sonarqube/postgresql/data
sudo chmod 777 -R /opt/workshop/

# Lancement du projet
WORKSPACE=${WORKSPACE} docker-compose -p devops-tools -f .platforms/tools/docker-compose.yml up
