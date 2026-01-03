terraform {
  backend "s3" {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/alb/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {}

locals {
  workspace          = terraform.workspace == "default" ? "" : "-${terraform.workspace}"
  project_name       = data.terraform_remote_state.shared.outputs.git_repository_name_game_sys_test_task
  env                = data.terraform_remote_state.globalvars.outputs.environment
  long_project_name  = "${local.project_name}-${local.env}${local.workspace}"
  default_port = one([for k, v in var.alb_port_mappings : k if v.is_default])
}

data "terraform_remote_state" "globalvars" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/_global/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "tarlekon-self-aws-terraform-service-infrastructure"
    key    = "dev/game-sys-test-task/_shared/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_security_group" "alb_sg" {
  name   = "ALB-SG-${local.long_project_name}"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "egress" {
    for_each = var.alb_port_mappings
    content {
      cidr_blocks = ["0.0.0.0/0"] //TODO FIXME, comment this line
      //security_groups = [var.ecs_service_sg_id] //TODO FIXME, uncomment this line :)
      from_port =  tonumber(egress.key)
      to_port   =  tonumber(egress.key)
      protocol  = "tcp"
    }
  }

  tags = merge(data.terraform_remote_state.globalvars.outputs.default_tags, {
    Name = "ALB-SG-${local.long_project_name}"
  })
}

resource "aws_lb" "alb" {
  name               = "ALB-${local.long_project_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnets_ids

  tags = merge(data.terraform_remote_state.globalvars.outputs.default_tags, {
    Name = "ALB-${local.long_project_name}"
  })
}

resource "aws_lb_target_group" "port_tg" {
  for_each = var.alb_port_mappings
  name        = "TG-${each.key}-${local.long_project_name}"
  port        = tonumber(each.key)
  protocol    = data.terraform_remote_state.shared.outputs.alb_protocol
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  target_type = "ip" # Fot ECS Fargate use "ip", for EC2 - "instance"

  health_check {
    path                = each.value.health_check
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = data.terraform_remote_state.shared.outputs.alb_port
  protocol          = data.terraform_remote_state.shared.outputs.alb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.port_tg[local.default_port].arn
  }
}

resource "aws_lb_listener_rule" "rules" {
  for_each = { for k, v in var.alb_port_mappings : k => v if !v.is_default }

  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.port_tg[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
}