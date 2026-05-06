pipeline {
    agent any

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                url: 'https://github.com/Ankit-0395/devops.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building HTML Project'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker rm -f html-container || true

                docker run -d \
                --name html-container \
                -p 80:80 \
                -v $WORKSPACE/html:/usr/share/nginx/html:ro \
                nginx
                '''
            }
        }
    }
}
