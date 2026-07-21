# Minimal, self-contained infrastructure to run the Task Manager API on
# AWS ECS Fargate behind an Application Load Balancer, using the default
# VPC to keep the example approachable. Intended to be run as a
# VCS-driven Terraform Enterprise / HCP Terraform workspace (see backend.tf).

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "alb" {
  name        = "task-manager-alb-${var.environment}"
  description = "Allow inbound HTTP to the Task Manager ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
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

  tags = var.tags
}

resource "aws_security_group" "service" {
  name        = "task-manager-service-${var.environment}"
  description = "Allow inbound traffic from the ALB to the Fargate service"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_lb" "app" {
  name               = "task-manager-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.default.ids

  tags = var.tags
}

resource "aws_lb_target_group" "app" {
  name        = "task-manager-tg-${var.environment}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
  }

  tags = var.tags
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_ecs_cluster" "app" {
  name = "task-manager-${var.environment}"
  tags = var.tags
}

resource "aws_ecs_task_definition" "app" {
  family                   = "task-manager-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name         = "task-manager-api"
      image        = var.app_image
      portMappings = [{ containerPort = var.container_port, protocol = "tcp" }]
      environment  = [{ name = "PORT", value = tostring(var.container_port) }]
      essential    = true
    }
  ])

  tags = var.tags
}

resource "aws_ecs_service" "app" {
  name            = "task-manager-${var.environment}"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.service.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name    = "task-manager-api"
    container_port    = var.container_port
  }

  depends_on = [aws_lb_listener.app]

  tags = var.tags
}
