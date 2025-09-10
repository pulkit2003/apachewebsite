pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "pulkitm2003/apachewebsite:latest"
        EKS_CLUSTER_NAME = "Pulkit-eks"
        AWS_REGION = "ap-south-1"

        // Manually set your AWS credentials here (use Jenkins credentials binding)
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')   // Jenkins secret text credential ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key') // Jenkins secret text credential ID
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
                    echo "Exporting AWS credentials..."
                    export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                    export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                    export AWS_DEFAULT_REGION=${AWS_REGION}

                    echo "Running Ansible playbook for Kubernetes deployment..."
                    ansible-playbook deploy-k8s.yaml
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
