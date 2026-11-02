pipeline {
    agent any

    environment {
        PYTHONUNBUFFERED = '1'
        REGISTRY_NAME    = 'python-crud-api'
        CONTAINER_NAME  = 'production-api-container'
        PORT_MAPPING    = '5000:5000'
        VOLUME_NAME     = 'production-api-data'
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                echo 'Checking out source code from GitHub'
                checkout scm
            }
        }

        stage('2. Code Syntax Verification') {
            steps {
                sh 'python3 -m py_compile app.py'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                sh 'docker build -t ${REGISTRY_NAME}:${BUILD_NUMBER} .'
                sh 'docker tag ${REGISTRY_NAME}:${BUILD_NUMBER} ${REGISTRY_NAME}:latest'
            }
        }

        stage('4. Automated Deployment') {
            steps {
                sh '''
                    docker volume create $VOLUME_NAME || true
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                    docker run -d \
                      --name $CONTAINER_NAME \
                      --network jenkins-net \
                      -p $PORT:$PORT \
                      -v $VOLUME_NAME:/var/lib/backend_data \
                      $IMAGE_NAME:latest
                '''
            }
        }

        stage('5. Health Check') {
            steps {
                sh 'sleep 3'
                sh 'curl -fsS http://$CONTAINER_NAME:$PORT/health'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Inspect Console Output.'
        }
    }
}