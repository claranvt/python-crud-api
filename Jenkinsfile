pipeline {
    agent any

    environment {
        IMAGE_NAME     = 'python-crud-api'
        CONTAINER_NAME = 'production-api-container'
        NETWORK_NAME   = 'jenkins-net'
        PORT_MAPPING   = '5000:5000'
        VOLUME_NAME    = 'production-api-data'
    }

    stages {
        stage('1. Checkout Code') {
            steps { checkout scm }
        }

        stage('2. Code Syntax Verification') {
            steps { sh 'python3 -m py_compile app.py' }
        }

        stage('3. Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .'
                sh 'docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest'
            }
        }

        stage('4. Automated Deployment') {
            steps {
                sh '''
                    docker network create ${NETWORK_NAME} || true
                    docker volume create ${VOLUME_NAME}
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        --network ${NETWORK_NAME} \
                        -p ${PORT_MAPPING} \
                        -v ${VOLUME_NAME}:/var/lib/backend_data \
                        ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('5. Health Check') {
            steps {
                sh 'sleep 3'
                sh 'curl -fsS http://${CONTAINER_NAME}:5000/health'
                sh 'docker logs --tail 20 ${CONTAINER_NAME}'
            }
        }
    }

    post {
        success { echo 'Pipeline completed successfully.' }
        failure { echo 'Pipeline failed. Inspect Console Output.' }
    }
}