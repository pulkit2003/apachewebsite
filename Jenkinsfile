pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "pulkitm2003/apachewebsite:latest"
        EKS_CLUSTER_NAME = "Pulkit-eks"
        AWS_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout Repo') {
            steps {
                git branch: 'master', url: 'https://github.com/pulkit2003/apachewebsite.git'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // Ensure DockerHub credentials are configured in Jenkins with ID 'docker'
                    withDockerRegistry(credentialsId: 'docker', url: '') {
                        sh """
                        echo "Building Docker image..."
                        docker build -t $DOCKER_IMAGE .
                        echo "Pushing Docker image to DockerHub..."
                        docker push $DOCKER_IMAGE
                        """
                    }
                }
            }
        }

        stage('Deploy to EKS via Ansible') {
            steps {
                script {
                    sh """
                    echo "Activating Ansible environment..."
                    . /home/ubuntu/ansible-env/bin/activate

                    echo "Running Ansible playbook for Kubernetes deployment..."
                    ansible-playbook /home/ubuntu/deploy-k8s.yaml

                    deactivate
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh """
                echo "Checking Kubernetes pods..."
                kubectl get pods -o wide

                echo "Checking Kubernetes services..."
                kubectl get svc
                """
            }
        }
    }

    post {
        success {
            echo '✅ Deployment succeeded!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
