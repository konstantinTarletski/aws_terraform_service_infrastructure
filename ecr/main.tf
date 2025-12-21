terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
provider "aws" {

}

resource "aws_ecr_repository" "app" {
  name = "game-sys-test-task"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}

resource "aws_ecr_lifecycle_policy" "keep_last_10" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}

resource "aws_iam_role" "ecr_pusher" {
  name = "ecr-pusher-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          //"token.actions.githubusercontent.com:sub" = "repo:ORG/REPO:*"
          "token.actions.githubusercontent.com:sub" = "repo:konstantinTarletski/game-sys-test-task:*"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "ecr_push" {
  role = aws_iam_role.ecr_pusher.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = aws_ecr_repository.app.arn
      }
    ]
  })
}

/*resource "null_resource" "update_github_thumbprint" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = file("./data/script.sh")
  }
}
*/
/*resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  //thumbprint_list = ["7560d6f40fa55195f740ee2b1b7c0b4836cbe103"]
  thumbprint_list = [trim(file("./data/github_thumbprint.txt"), " \n\r\t")]
  depends_on     = [null_resource.update_github_thumbprint]
}

*/
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # Берем отпечаток напрямую из сертификата
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}