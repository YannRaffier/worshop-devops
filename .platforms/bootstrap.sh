#!/bin/bash

# Fonctions / Variables transverses
source .platforms/bootstrap-commons.sh

##########################################################################
# Variables
##########################################################################

# Répertoire de travail "Docker"
WORKDIR=$(clean_path "/code")

# Nom du projet
PROJECT_NAME="workshop-devops"