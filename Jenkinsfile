pipeline {
    agent any

    environment {
        TF_VERSION = "1.5.7"  // Replace with your desired Terraform version
        TF_WORKSPACE = "default"
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
       // REPO_NAME = "${params.REPO_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git branch: 'main', url: 'https://github.com/abhigyanbasu/terraform.git'
            }
        }

    /*    stage('Install Terraform') {
            steps {
                
                // Install Terraform using a package manager or manually download it
                sh '''
                    if ! terraform -v | grep ${TF_VERSION}; then
                        curl -o terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                        unzip terraform.zip
                        sudo mv terraform /usr/local/bin/
                        rm terraform.zip
                    fi
                    terraform -v
                '''
            }
        }*/

        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                // Generate and display an execution plan
                def REPO_NAME = "${params.REPO_NAME}"
                sh 'terraform plan -var="ecr_repo_name=$REPO_NAME" -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the Terraform plan with approval
                input message: 'Approve Terraform Apply?'
                sh 'terraform apply tfplan'
            }
        }
    }

    post {
        always {
            // Clean up the workspace
            cleanWs()
        }
        success {
            echo 'Terraform script executed successfully!'
        }
        failure {
            echo 'Terraform script execution failed.'
        }
    }
}
