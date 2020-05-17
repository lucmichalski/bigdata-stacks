pipeline {
    agent {
        node {
            label 'ansible-ci'
        }       
    }

    parameters {        
        choice(
            name: 'deploy',
            choices: ['release','documentation'],
            description: 'Choice option to Deploy'
        )
    }

    environment {
        BUILD_VERSION  = sh(script: 'date +%Y.%m.%d', , returnStdout: true).trim()
        COMMIT_VERSION = sh(script: 'git rev-parse --short HEAD', , returnStdout: true).trim()
    }

    stages { 
        stage('Build Release') {
            when {
                branch 'master'
                expression { params.deploy == 'release' }
            }
            steps {
                sh "cat release/commit.sh.template | sed -e 's/COMMIT_VERSION/${COMMIT_VERSION}/' > .warp/lib/commit.sh"
                sh "cat release/version.sh.template | sed -e 's/BUILD_VERSION/${BUILD_VERSION}/' > .warp/lib/version.sh"

                sh "tar cJf warparchive.tar.xz .warp/."
                sh "cat warp > dist/warp"
                sh "cat warparchive.tar.xz >> dist/warp"
                sh "chmod +x dist/warp"
                sh "cp dist/warp dist/warp_${BUILD_VERSION}"
            }            
        }

        stage('Generate Tag') {
            when {
                branch 'master'
                expression { params.deploy == 'release' }
            }
            steps {
                script {
                    sshagent (credentials: ['BITBUCKET']) {
                        sh """
                                ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts
                                git config user.email "${env.EMAIL_DEVOPS}"
                                git config user.name "Jenkins"
                                git tag ${BUILD_VERSION}
                                git push origin ${BUILD_VERSION}
                        """
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'master'
                expression { params.deploy == 'release' }
            }
            steps {
                script {
                    withCredentials([
                        [
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'AWS_SUMMA_CREDENTIALS',
                            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]
                    ]) 
                    {
                        sh "aws s3 cp ./dist/warp s3://ct.summasolutions.net/warp-engine/warp"
                        sh "aws s3 cp ./dist/warp s3://ct.summasolutions.net/warp-engine/old/warp_${BUILD_VERSION}"
                    }
                }   
            }
            post {
                success {
                    echo "Success!"   
                    slackSend (
                        channel: "${env.CHANNEL_SLACK_WARP}",
                        color: "good",
                        message: ":docker: *NEW VERSION WARP ${BUILD_VERSION}* :docker: \n Documentation: https://summasolutions.github.io/warp-engine/  \n More info at: https://github.com/SummaSolutions/warp-engine/blob/master/CHANGES.md"
                    )
                }   
                failure {   
                    echo "Failure!"   
                    slackSend (
                        channel: "${env.CHANNEL_SLACK_WARP}",
                        color: "danger",
                        message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}"
                    )
                }
            }
        }

        stage('Deploy to Github') {
            echo "deploy to github"
            // For SSH private key authentication, try the sshagent step from the SSH Agent plugin.
            //sshagent (credentials: ['GITHUB']) {
            //    sh('ssh-keyscan -H github.com >> ~/.ssh/known_hosts')
            //    sh('git push origin master')
            //    sh("git push origin ${BUILD_VERSION}")
            //}
        }

        stage('Documentation') {
            when {
                branch 'master'
                expression { params.deploy == 'documentation' }
            }
            steps {
                sh "python -m pip install -r requirements.txt"
                sh "mkdocs build --site-dir docs"
                script {                 
                    sshagent (credentials: ['BITBUCKET']) {                        
                        sh """
                                ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts
                                git config user.email "${env.EMAIL_DEVOPS}"
                                git config user.name "Jenkins"
                                git add docs wiki_docs
                                git commit -m "build documentation ${BUILD_VERSION}_${COMMIT_VERSION}"
                                git push origin master
                        """
                    }
                }   
            }
        }
    }

    post {
        always {
            dir("${WORKSPACE}") {
                deleteDir()
            }
            echo "delete temporary workspace"
        }
    }
}