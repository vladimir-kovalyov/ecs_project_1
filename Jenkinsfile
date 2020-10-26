pipeline {

    agent any

    options {
        timestamps()
    }

    stages {
        stage('Build') {
            steps {
                echo 'This is Bbuild stage'
            }
        }

        stage('Test') {
            parallel {
                stage('Unit Test') {
                    steps {
                        echo 'This is Unit Test stage'
                    }
                }

                stage('UI Testing') {
                    steps {
                        echo 'this is UI Testing stage'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'This is Deploy stage'
            }
        }
            
    }

}