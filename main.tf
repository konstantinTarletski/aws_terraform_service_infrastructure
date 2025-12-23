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

terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "dev-network" {
  source                = "git@github.com:konstantinTarletski/aws_terraform_modules.git//network"
  environment           = "dev"
  db_subnets_cidrs      = []
  private_subnets_cidrs = []
  //public_subnets_cidrs  = ["10.0.1.0/24", ]
  default_tags = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}

module "dev-ecr-repo" {
  source                    = "git@github.com:konstantinTarletski/aws_terraform_modules.git//ecr_and_iam_role"
  ecr_repository_name       = "game-sys-test-task"
  git_repository_name       = "game-sys-test-task"
  git_repository_owner      = "konstantinTarletski"
  git_repository_token_link = "https://token.actions.githubusercontent.com"
  ecr_force_delete          = true
  default_tags = {
    Manufactor = "terraform",
    Design     = "tarlekon",
    Source     = "module"
  }
}


data "aws_region" "current" {}

resource "aws_ecs_cluster" "main" {
  name = "demo-cluster"
}

data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/game-sys-task"
  retention_in_days = 7
}

resource "aws_security_group" "ecs_public_sg" {
  name        = "allow-app-access"
  description = "Allow inbound access to my Java app"
  vpc_id      = module.dev-network.vpc_id

  ingress {
    from_port   = 8815
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. СТРОГАЯ РОЛЬ КЛЮЧНИКА (Execution Role)
resource "aws_iam_role" "ecs_exec_role" {
  name = "game-sys-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# Прямая политика: разрешаем только ОДИН репозиторий ECR
resource "aws_iam_policy" "strict_ecr_pull" {
  name = "StrictECRPullPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Разрешаем скачивать образы ТОЛЬКО из этого репозитория
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Effect   = "Allow"
        Resource = "*"
        //TODO FIXME Uncomment
        //Resource = "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/game-sys-test-task"
      },
      {
        # Общее разрешение на получение токена авторизации (нельзя ограничить по ресурсу)
        Action   = "ecr:GetAuthorizationToken"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        # Разрешаем писать логи в нашу группу
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.ecs_logs.arn}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_strict_pull" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = aws_iam_policy.strict_ecr_pull.arn
}

# 4. ПРАВА ДЛЯ GITHUB (Деплоер)
resource "aws_iam_policy" "github_deploy_policy" {
  name = "GithubDeployOnly"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Разрешаем создавать новые версии чертежей
        Action   = "ecs:RegisterTaskDefinition"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        # Доверенность (PassRole): Разрешаем GitHub ПЕРЕДАВАТЬ роль Ключника
        Action   = "iam:PassRole"
        Effect   = "Allow"
        Resource = aws_iam_role.ecs_exec_role.arn
      }
    ]
  })
}

# Привязываем к вашей существующей роли GitHub
resource "aws_iam_role_policy_attachment" "attach_github" {
  role       = "ecr-pusher_repo_game-sys-test-task" # Имя вашей роли
  policy_arn = aws_iam_policy.github_deploy_policy.arn
}

# 5. TASK DEFINITION (Чертеж)
resource "aws_ecs_task_definition" "app" {
  family                   = "game-sys-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_exec_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "tomcat:latest"
      essential = true
      portMappings = [{
        containerPort = 8080
        hostPort      = 8080
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

locals {
  # Объединяем все списки подсетей из разных AZ в один общий список объектов
  all_public_subnets = flatten(values(module.dev-network.public_subnets_ids_and_cidrs))
}

resource "aws_ecs_service" "main" {
  name            = "game-sys-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1           # Сколько копий приложения запустить
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [for s in local.all_public_subnets : s.id]
    //В настройках подсети есть галочка "Auto-assign public IPv4", но для Fargate она игнорируется.
    assign_public_ip = true     # Чтобы вы могли зайти на него из браузера
    security_groups  = [aws_security_group.ecs_public_sg.id]
  }
}
