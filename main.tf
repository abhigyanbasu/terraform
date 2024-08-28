# Declare the AWS provider
provider "aws" {
  region = "ap-south-1"  # Specify your desired AWS region
}

# Declare a variable for the repository name
variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "my-default-ecr-repo"  # Provide a default value if desired
}

# Create the ECR repository using the variable
resource "aws_ecr_repository" "this" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"  # Options: MUTABLE, IMMUTABLE

  image_scanning_configuration {
    scan_on_push = true
  }

  # Optional: encryption configuration
  encryption_configuration {
    encryption_type = "AES256"  # Default encryption, can be changed to KMS
  }
  
  # Optional: lifecycle policy
  lifecycle_policy {
    policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only the last 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
  }
}

# Output the repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
  description = "The URL of the ECR repository"
}
