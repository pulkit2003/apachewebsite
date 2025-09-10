pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "pulkitm2003/apachewebsite:latest"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub-cred-id', url: 'https://index.docker.io/v1/']) {
                        sh '''
                            echo "Building Docker image..."
                            docker build -t $DOCKER_IMAGE .

                            echo "Pushing Docker image to DockerHub..."
                            docker push $DOCKER_IMAGE
                        '''
                    }
                }
            }
        }

        stage('Deploy to EKS via Ansible') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        echo "Exporting AWS credentials..."
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=ap-south-1

                        echo "Activating Ansible virtual environment..."
                        . /home/ubuntu/ansible-env/bin/activate

                        echo "Running Ansible playbook for Kubernetes deployment..."
                        ansible-playbook deploy-k8s.yaml
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "Stage skipped if deployment failed"
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
