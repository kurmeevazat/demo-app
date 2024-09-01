pipeline {  
    agent { label 'local' }

    environment {   
        COMMIT_HASH = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${BRANCH}", url: "${env.GIT_URL}"
            }
        }
        stage('Build Java Application') {
            steps {
                script {
                    // Сборка Docker образа Java приложения
                    sh 'docker build -t my-demo-app:latest .'
                }
            }
        }
        stage('Deploy with Docker Compose') {
            steps {
                script {
                    // Остановка предыдущей версии контейнеров (если они запущены)
                    sh 'docker-compose down || true'
                    // Запуск приложения с помощью Docker Compose
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
        //cleanup {
            // Удаление неиспользуемых ресурсов, если необходимо
        //    sh 'docker system prune -f'
        //}
    }
}