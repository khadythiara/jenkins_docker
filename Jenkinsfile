pipeline {
  environment {
     DOCKER_HOST = 'unix:///var/run/docker.sock'
    imagename = "khadydiagne/jenkins_docker"
    registryCredential = 'Dockerhub' 
    dockerImage = ''
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'https://github.com/khadythiara/jenkins_docker.git', branch: 'main'])

      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build(imagename, ".")
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')

          }
        }
      }
    }
    
 
     stage('Run Docker Container') {
          steps {
              script {
                    // Exécution du conteneur Docker
                    dockerImage.run("-d -p 8085:80")
                }
            }
        }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi -f $imagename:$BUILD_NUMBER"
         sh "docker rmi -f $imagename:latest"

      }
    }
  }
}
