# ALB Target Group
resource "aws_lb_target_group" "ror_target_group" {
  name        = "${var.project_name}-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

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

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "ror_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_subnet_1, var.public_subnet_2]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ror_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ror_target_group.arn
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "ror_cluster" {
  name = "${var.project_name}-cluster"
}

# ECS Task Definition (No IAM Role here)
resource "aws_ecs_task_definition" "ror_task" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "ror-app"
      image     = "${var.ecr_repo_url}:v1"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      environment = [
        { name = "DATABASE_HOST", value = var.db_host },
        { name = "DATABASE_USERNAME", value = var.db_username },
        { name = "DATABASE_PASSWORD", value = var.db_password },
        { name = "AWS_REGION", value = var.aws_region }
      ]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "ror_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.ror_cluster.id
  task_definition = aws_ecs_task_definition.ror_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = [var.private_subnet_1, var.private_subnet_2]
    assign_public_ip = false
    security_groups = [aws_security_group.alb_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ror_target_group.arn
    container_name   = "ror-app"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.http
  ]
}

