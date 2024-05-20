pipeline {
    environment {
        webDockerImageName = "martinez42/ligne-rouge-web"
        dbDockerImageName = "martinez42/ligne-rouge-db"
        webDockerImage = ""
        dbDockerImage = ""
        registryCredential = 'docker-credentiel'
        KUBECONFIG = "/home/rootkit/.kube/config"
        TERRA_DIR  = "/home/rootkit/ligne-rouge/terraform"
    }
    agent any
    stages {
        stage('Checkout Source') {
            steps {
                git 'https://github.com/issa2580/ligne-rouge.git'
            }
        }
        stage('Build Web Docker image') {
            steps {
                script {
                    webDockerImage = docker.build webDockerImageName, "-f App.Dockerfile ."
                }
            }
        }
        stage('Build DB Docker image') {
            steps {
                script {
                    dbDockerImage = docker.build dbDockerImageName, "-f Db.Dockerfile ."
                }
            }
        }
        stage('Pushing Images to Docker Registry') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        webDockerImage.push('latest')
                        dbDockerImage.push('latest')
                    }
                }
            }
        }
        stage('Set Permissions for Kubernetes Config') {
            steps {
                script {
                    sh """
                    sudo chown jenkins:jenkins ${KUBECONFIG}
                    sudo chmod 777 ${KUBECONFIG}
                    """
                }
            }
        }
        stage("Terraform Initialiization") {
            steps {
                script {
                    sh """
                    sudo chown -R jenkins:jenkins ${terra_dir}
                    sudo chmod -R 777 ${terra_dir}
                    cd ${terra_dir} && terraform init
                    """
                }
            }
        }
        stage("Terraform Plan") {
            steps {
                script {
                    sh "cd ${TERRA_DIR} && terraform plan"
                }
            }
        }
        stage("Terraform Apply") {
            steps {
                script {
                    sh "cd ${TERRA_DIR} && terraform apply --auto-approve"
                }
            }
        }
    }
    post {
        success {
            slackSend channel: 'groupe4', message: 'Success to deploy'
        }
        failure {
            slackSend channel: 'groupe4', message: 'Failed to deploy'
        }
    }
}