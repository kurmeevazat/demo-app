pipeline {
    agent { label 'local' }

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'Git branch to build')
        string(name: 'GIT_URL', defaultValue: 'https://github.com/kurmeevazat/demo-app.git', description: 'Git repository URL')
    }

    environment {
        COMMIT_HASH = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Проверка кода из указанной ветки
                    checkout([$class: 'GitSCM',
                        userRemoteConfigs: [[url: "${params.GIT_URL}"]],
                        branches: [[name: "*/${params.BRANCH}"]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: []])
                }
            }
        }
        stage('Build Java Application') {
            steps {
                script {
                    // Сборка Docker образа Java приложения
                    sh "docker build -t my-demo-app:${COMMIT_HASH} ."
                }
            }
        }
        stage('Deploy with Docker Compose') {
            steps {
                script {
                    // Проверяем, существуют ли контейнеры
                    def containersExist = sh(script: 'docker ps -a -q', returnStdout: true).trim()
                    
                    if (containersExist) {
                        // Если контейнеры существуют, останавливаем и удаляем только контейнер demo-app
                        sh '''
                        if [ "$(docker ps -q -f name=my-demo-app)" ]; then
                            docker stop my-demo-app
                            docker rm my-demo-app
                        fi
                        '''
                    }
                    
                    // Запуск всех контейнеров
                    sh 'docker-compose up -d'
                }
            }
        }
    }
    post {
        always {
            // Сборка и отображение логов
            sh 'docker-compose logs'
        }
    }
}