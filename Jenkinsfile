node() {
    // Nom du Projet Gitlab
    String projetcName = "workshop-devops"
    // Branche GIT à builder/packager/déployer
    String projectBranch = params.BRANCH_NAME
    // Environnement sur lequel on souhaite déployer l'application
    String deployTo = params.DEPLOY_TO
    // Version de l'application que l'on souhaite déployer
    String version = params.PROJECT_VERSION

    try {

        if (version == "") {
            version = projectBranch
        }

        stage('Prepare') {
            currentBuild.description = "Deploy ${projetcName}"
            checkout scm
            // Mise à jour des droits
            sh("chmod 777 -R ./.platforms")
            // Mise à jour de la variable "PROJECT_VERSION" dans le fichier ".env"
            //sh('sed -ir \"s/^[#]*\\s*PROJECT_VERSION=.*/PROJECT_VERSION=' + version + '/\" .env')
        }

        stage("Build") {
            println "Building project"
            sh "bash ./.platforms/ci/build.sh"
        }

//        stage("Sonarqube") {
//            println "Qualimetry Sonarqube"
//            sh "bash ./.platforms/ci/sonar.sh"
//        }

        stage("Package") {
            // DockerService.instance().login(DockerRegistry.getDefaultRegistry())
            println "Creating Docker Images"
            sh "bash ./.platforms/ci/package.sh"
        }

//        stage("Deploy") {
//            println "Deploy project"
//            sh "bash ./.platforms/k8s/deploy.sh ${deployTo}"
//        }

        // Notification (Teams, Mattermost, etc)
        println "Déploiement du projet '${projetcName}' réalisé avec succès"

    } catch (err) {
        // Notification (Teams, Mattermost, etc)
        currentBuild.result = 'FAILURE'
        echo(err.dump())
    }
}
