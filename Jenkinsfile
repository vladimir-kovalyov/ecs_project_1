pipeline {

    agent any

    options {
        timestamps()
    }

    stages {
        stage('Build') {
            steps {
                echo 'This is Build stage' // To be removed later   
                sh 'rm build.tgz' // Removing old archive
                sh 'tar -czvf build.tgz *' // Archiving all files into one
                archiveArtifacts artifacts: 'build.tgz', fingerprint: true, followSymlinks: false // Saving archive
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
                // Now move artifact to AWS server and extract archive into /var/www/html
                sshPublisher(publishers: [sshPublisherDesc(configName: 'Web', 
                transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'tar -xzvf build.tgz -C /var/www/html/', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'build.tgz')], 
                usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                
            }
        }
            
    }

}