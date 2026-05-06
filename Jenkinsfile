pipeline {
    agent any

    environment {
        EMAIL = "ankitkumarmth02052004@gmail.com"
    }

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

        stage('Send Email Notification') {
            steps {
                emailext(
                    subject: "HTML App Deployed Successfully on Docker!",
                    body: """
                    Hello,

                    Your HTML project has been deployed successfully using Docker container on Jenkins.

                    Container Name: html-container
                    Port: 80

                    Regards,
                    Jenkins CI/CD Pipeline
                    """,
                    to: "${EMAIL}"
                )
            }
        }
    }
}
