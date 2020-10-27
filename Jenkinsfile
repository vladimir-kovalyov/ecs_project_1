pipeline {

    agent any

    options {
        timestamps()
    }

    stages {
        stage('Build') {
            steps {
                echo 'This is Build stage'
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
                sshPublisher(publishers: [sshPublisherDesc(configName: 'Web', 
                transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'mv index.html /var/www/html/index.html', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'index.html')], 
                usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                
            }
        }
            
    }

}