#!/bin/bash

# Permet de vérifier qu'une commande n'est pas en erreur
check_rc() {
    RC=$?
    if [ $RC != 0 ]; then
        echo "ERROR command failure, exiting with return code $RC"
        exit $RC;
    fi
}

# Permet de savoir si on travaille dans un environnement WSL
isWSL() {
    OS_KERNEL_RELEASE=$(uname -r)
    OS_KERNEL_TYPE=${OS_KERNEL_RELEASE##*-}

    if [ "$OS_KERNEL_TYPE" == "Microsoft" ]; then
        echo true
    else
        echo false
    fi
}

# Permet de savoir si on travaille dans un environnement WSL 2
isWSL2() {
    if [ -d "/run/WSL" ]; then
        echo true
    else
        echo false
    fi
}

# Permet de savoir si on travaille dans un environnement Linux
isLinux() {
    OS_KERNEL_NAME=$(echo $(uname -s))
    if [ "$OS_KERNEL_NAME" = "Linux" ] && [ $(isWSL) = false ]; then
        echo true
    else
        echo false
    fi
}

# Permet de savoir si on travaille dans un environnement MacOs
isMac() {
    OS_KERNEL_NAME=$(echo $(uname -s))
    if [ "$OS_KERNEL_NAME" = "Darwin" ]; then
        echo true
    else
        echo false
    fi
}

# Permet de savoir si on travaille dans un environnement Windows
isWindows() {
    if [ $(isLinux) = false ] && [ $(isWSL) = false ] && [ $(isGitBash) = false ] && [ $(isMac) = false ]; then
        echo true
    else
        echo false
    fi
}

# Permet de savoir si on travaille dans un environnement Git Bash
isGitBash() {
    OS_KERNEL_NAME=$(echo $(uname -s))
    if [[ "$OS_KERNEL_NAME" = *"MINGW"* ]]; then
        echo true
    else
        echo false
    fi
}

# Permet d'adapter un PATH en fonction du context d'exécution (Windows/Linux/WSL)
clean_path() {
    # Path linux/windows/wsl/gitbash
    VAR_PATH="$1"

    if [ $(isWSL) = true ]; then
        # Fix docker volume path Sub System Windows OS
        VAR_PATH=$(echo $VAR_PATH | sed 's/\/mnt//g')
    elif [ $(isGitBash) = true ]; then
        # Fix docker volume path pour Git Bash
        VAR_PATH=$(echo /$VAR_PATH)
    elif [ $(isWindows) = true ]; then
        # Transforme le path pour compatibilité Windows
        VAR_PATH=$(echo "$VAR_PATH" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')
    fi

    echo $VAR_PATH
}

# Permet de lancer une commande de type "docker run ... /bin/bash -c $CMD"
# $1 > <container-name> --name > Nom Temporaire du container
# $2 > <workdir> -w            > Workdir, Emplacement dans le container qui sera utilisé comme emplacement par défaut au lancement de la commande
# $3 > <docker-run-opts>       > Liste d'option à ajouter à la commande "docker run" (ex: -v blabla)
# $4 > <image-name>            > Nom de l'image à utiliser pour lancer la commande
# $5 > CMD                     > La commande à lancer dans le "Workdir" via "image-name"
dockerRun() {
    DOCKER_CONTAINER_NAME=$1
    WORKDIR=$2
    DOCKER_IMAGE_EXTRA_OPTS=$3
    DOCKER_IMAGE_NAME=$4
    CMD=$5

    # Gestion des options docker par défaut
    DOCKER_IMAGE_EXTRA_OPTS="$DOCKER_IMAGE_EXTRA_OPTS -v $USER_HOME:$HOME"
    if [[ "$DOCKER_IMAGE_EXTRA_OPTS" != *"--user"* ]] && ([  $(isWSL) = true ] || [  $(isLinux) = true ]); then
        DOCKER_IMAGE_EXTRA_OPTS="$DOCKER_IMAGE_EXTRA_OPTS -v $USER_HOME/passwd:/etc/passwd:ro -v $USER_HOME/group:/etc/group:ro --user $(id -u):$(id -g)"
    fi

    # Début Chronomètre
    START=$(date +%s)

    # On lance la commande via un container
    docker run --rm --name $DOCKER_CONTAINER_NAME -w $WORKDIR $DOCKER_IMAGE_EXTRA_OPTS $DOCKER_IMAGE_NAME //bin/bash -c "$CMD"
    check_rc

    # Fin Chronomètre
    END=$(date +%s)
    DIFF=$(( $END - $START ))
    echo "Execution Time: $DIFF seconds"
}

# On récupère l'emplacement du répertoire parent
WORKSPACE=$(clean_path "${PWD}")
USER_HOME=$(clean_path "${HOME}")

if [ $(isLinux) = true ] || [ $(isWSL) = true ]; then
    if [ ! -f $HOME/passwd ]; then
      cp /etc/passwd $HOME
    fi

    if [ ! -f $HOME/group ]; then
      cp /etc/group $HOME
    fi

    # Fix USER/GROUP from AD/SSSD qui ne sont pas présent dans les fichiers "/etc/passwd" et "/etc/group"
    grep -qF "$USER" $HOME/passwd || sudo bash -c "echo \"$USER:x:$(id -u):$(id -g):$USER,,,:$HOME:$SHELL\" >> $HOME/passwd"
    grep -qF ":$(id -g):" $HOME/group || sudo bash -c "echo \"domaine:x:$(id -g):$USER\" >> $HOME/group"
fi

# Gestion du fichier "kubeconfig"
KUBECONFIG=${HOME}/.kube/kubeconfig-local

# Suppression des containers inutiles
sudo docker rm $( docker ps -q -f status=exited)

echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++"
echo "> Liste des variables disponibles"
echo "+++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo "# Fichier kubeconfig local"
echo "+ KUBECONFIG = ${KUBECONFIG}"
echo ""
echo "# Répertoire utilisateur (épuré ou non de /mnt en fonction du contexte d'exécution)"
echo "+ HOME = ${HOME}"
echo "+ USER_HOME = ${USER_HOME}"
echo ""
echo "# Répertoire courant (épuré ou non de /mnt en fonction du contexte d'exécution)"
echo "+ PWD = ${PWD}"
echo "+ WORKSPACE = ${WORKSPACE}"
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++"
echo ""

set -xe
