pipeline {
    agent {
        label 'wsl'
    }
    
    environment {
        DOCKER_REGISTRY = 'surajmishra07/py_proj'
        HELM_CHART_PATH = 'helm/python_proj'
        HELM_VALUES_FILE = 'helm/python_proj/values.yaml'
        KUBERNETES_NAMESPACE = 'python-app-ns'
        APP_NAME = 'python-app'
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                echo '=== Pulling Code from Repository ==='
                script {
                    // Clean workspace and checkout code
                    sh '''
                        git config --global --add safe.directory "*"
                        git config --global --add safe.directory $(pwd)
                    '''
                    checkout scm
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo '=== Building Docker Image ==='
                script {
                    def imageName = "majorproject-app"
                    def imageTag = "${BUILD_NUMBER}-${env.GIT_COMMIT?.take(7) ?: 'latest'}"
                    def fullImageName = "${imageName}:${imageTag}"
                    
                    // Store image details for later stages
                    env.DOCKER_IMAGE_NAME = imageName
                    env.DOCKER_IMAGE_TAG = imageTag
                    env.DOCKER_FULL_IMAGE_NAME = fullImageName
                    
                    sh """
                        echo "Building Docker image: ${fullImageName}"
                        docker build -t ${fullImageName} .
                        echo "Docker image built successfully"
                    """
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo '=== Pushing Docker Image to Docker Hub ==='
                script {
                    def dockerHubImage = "${env.DOCKER_REGISTRY}:${env.DOCKER_IMAGE_TAG}"
                    env.DOCKER_HUB_IMAGE = dockerHubImage
                    
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh """
                            echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin
                            docker tag ${env.DOCKER_FULL_IMAGE_NAME} ${dockerHubImage}
                            docker push ${dockerHubImage}
                            docker logout
                        """
                    }
                }
            }
        }
        
        stage('Trivy Security Scan') {
            steps {
                echo '=== Scanning Docker Image with Trivy ==='
                script {
                    def timestamp = new Date().format('yyyyMMdd-HHmmss')
                    def reportDir = "trivy-reports"
                    def tableReport = "${reportDir}/trivy-scan-${env.DOCKER_IMAGE_NAME}-${env.BUILD_NUMBER}-${timestamp}.txt"
                    
                    sh """
                        echo "Creating reports directory..."
                        mkdir -p ${reportDir}
                        
                        echo "Running Trivy scan on image: ${env.DOCKER_FULL_IMAGE_NAME}"
                        trivy image --format table -o ${tableReport} ${env.DOCKER_FULL_IMAGE_NAME} || echo "Table report generation failed"
                        
                        echo "Trivy scan completed. Report saved to: ${tableReport}"
                    """       
                }
            }
        }
        
        stage('Update Helm Values and Deploy') {
            steps {
                echo '=== Updating Helm Values and Deploying ==='
                script {
                    def newImageTag = env.DOCKER_IMAGE_TAG
                    
                    sh """
                        
                        yq e '.image.tag = "${newImageTag}"' -i ${env.HELM_VALUES_FILE}
                        helm upgrade ${env.APP_NAME} ${env.HELM_CHART_PATH} \\
                            --namespace ${env.KUBERNETES_NAMESPACE} \\
                            --wait \\
                            --timeout=300s \\
                            --set image.pullPolicy=Always
                        
                    """
                }
            }
        }
        
        stage('Commit Changes') {
            steps {
                echo '=== Committing Updated Helm Values to GitHub ==='
                script {
                    def commitMessage = "Update image tag to ${env.DOCKER_IMAGE_TAG} - Build #${env.BUILD_NUMBER}"
                    
                    withCredentials([usernamePassword(credentialsId: 'git-creds', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_TOKEN')]) {
                        sh """
                            echo "Configuring Git..."
                            git config user.email "jenkins@nagarro.com"
                            git config user.name "Jenkins Pipeline"
                            
                            git remote set-url origin https://\${GIT_USERNAME}:\${GIT_TOKEN}@github.com/SurajMishraNagarro/MajorProject.git
                            
                            git add ${env.HELM_VALUES_FILE}
                            git commit -m "${commitMessage}"
                            git push origin HEAD:main

                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo '=== Pipeline Execution Completed ==='
            
            // Clean up Docker images to save space
            script {
                if (env.DOCKER_FULL_IMAGE_NAME) {
                    sh """
                        echo "Cleaning up local Docker images..."
                        docker rmi ${env.DOCKER_FULL_IMAGE_NAME} || echo "Failed to remove local image"
                        docker rmi ${env.DOCKER_HUB_IMAGE} || echo "Failed to remove tagged image"
                        
                        docker system prune -f || echo "Docker system prune failed"
                    """
                }
            }
            
            // Clean workspace
            cleanWs()
        }
        
        success {
            echo '=== Pipeline executed successfully ==='
        }
        
        failure {
            echo '=== Pipeline execution failed ==='
        }
        
        unstable {
            echo '=== Pipeline completed with warnings ==='
        }
    }
}