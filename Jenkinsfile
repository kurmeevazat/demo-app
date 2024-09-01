pipeline {
    agent { label 'local' }

    parameters {
        string(name: 'BRANCH', defaultValue: 'jenkins-test', description: 'Git branch to build')
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
                    sh 'docker build -t my-demo-app:${COMMIT_HASH} .'
                }
            }
        }
        stage('Deploy with Docker Compose') {
            steps {
                script {
                    // Остановка и удаление только старого контейнера demo-app, если он существует
                    sh '''
                    if [ "$(docker ps -q -f name=my-demo-app)" ]; then
                        docker stop my-demo-app
                        docker rm my-demo-app
                    fi
                    '''
                    
                    // Запуск контейнера demo-app с новой версией образа
                    sh 'docker-compose up -d demo-app'
                }
            }
        }
    }
    post {
        always {
            // Сборка и отображение логов
            sh 'docker-compose logs'
        }
        // Uncomment if cleanup is required
        // cleanup {
        //     sh 'docker system prune -f'
        // }
    }
}