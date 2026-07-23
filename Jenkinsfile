pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
metadata:
spec:
    serviceAccountName: jenkins
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - sleep
    args:
    - 9999999
  - name: git
    image: alpine/git
    command:
    - sleep
    args:
    - 9999999
'''
        }
    }
    environment {
        ECR_REPO = "974436228692.dkr.ecr.us-west-2.amazonaws.com/lesson-8-9-ecr"
        GIT_BRANCH = "final-project"
    }
    stages {
        stage('Build and Push to ECR') {
            steps {
                container('kaniko') {
                    sh '''
                    export AWS_SDK_LOAD_CONFIG=true
                    export AWS_DEFAULT_REGION=us-west-2
                    
                    /kaniko/executor --context `pwd`/app \
                    --dockerfile `pwd`/app/Dockerfile \
                    --destination ${ECR_REPO}:${BUILD_NUMBER} \
                    --destination ${ECR_REPO}:latest
                    '''
                }
            }
        }
        stage('Update Helm Chart and Push to Git') {
            steps {
                container('git') {
                    withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        sh '''
                        git config --global user.email "jenkins@ci.com"
                        git config --global user.name "Jenkins CI"
                        
                        git clone -b ${GIT_BRANCH} https://${GIT_USER}:${GIT_PASS}@github.com/AlexSimakhin/goit-devops.git repo
                        cd repo
                        
                        sed -i "s/tag: .*/tag: ${BUILD_NUMBER}/g" charts/django-app/values.yaml
                        
                        git add charts/django-app/values.yaml
                        git commit -m "Jenkins: Update image tag to ${BUILD_NUMBER}"
                        git push origin ${GIT_BRANCH}
                        '''
                    }
                }
            }
        }
    }
}