pipeline {
  environment {
    DOCKER_HOST = 'unix://var/run/docker.sock'
     DOCKER_CERT_PATH = '/certs/client'
    imagename = "khadydiagne/push_jenkins_docker" // Nom de l'image Docker
    registryCredential = 'Dockerhub' // Credential ID pour Docker Hub
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'https://github.com/khadythiara/jenkins_docker.git', branch: 'main'])
      }
    }
    stage('Building image') {
      steps {
        sh 'docker build -t $imagename:${BUILD_NUMBER} .' // Construire l'image Docker avec le numéro de build
        sh 'docker tag $imagename:${BUILD_NUMBER} $imagename:latest' // Taguer l'image avec 'latest'
      }
    }

stage('Debug Docker Connection') {
    steps {
        script {
            sh 'docker info'
            sh 'ping docker -c 4'
        }
    }
}

    
    stage('Deploy Image') {
      steps {
        script {
          // Récupérer le mot de passe Docker depuis les credentials Jenkins
          withCredentials([usernamePassword(credentialsId: registryCredential, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin' // Login à Docker Hub
            sh 'docker push $imagename:${BUILD_NUMBER}' // Pousser l'image avec le numéro de build
            sh 'docker push $imagename:latest' // Pousser l'image avec le tag 'latest'
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps {
        sh 'docker rmi $imagename:${BUILD_NUMBER}' // Supprimer l'image avec le numéro de build
        sh 'docker rmi $imagename:latest' // Supprimer l'image avec le tag 'latest'
      }
    }
  }
}
