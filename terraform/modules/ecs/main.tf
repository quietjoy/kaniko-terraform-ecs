resource "aws_security_group" "alb_sg" {
  name        = "${var.identifier}-alb-sg"
  description = "Allow inbound traffic from the whitelisted CIDR to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.inbound_cidr_whitelist
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.identifier}-ecs-sg"
  description = "Allow inbound traffic from the ALB to the ECS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "ecs_assumption_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_policy" {
  name        = "${var.identifier}-ecs-policy"
  description = "Allow ECS to pull images from ECR"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:*",
        Effect   = "Allow"
      },
      {

        Effect : "Allow",
        Action : [
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_role" {
  name               = "ecs"
  assume_role_policy = data.aws_iam_policy_document.ecs_assumption_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.identifier}-cluster"
}

data "template_file" "ecs_task_definition" {
  template = file("${path.module}/task_definition.json.tpl")

  vars = {
    identifier     = var.identifier
    kankio_ecr_url = var.kankio_ecr_url
    app_ecr_url    = var.app_ecr_url
    repo_url       = var.repo_url
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.identifier
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_role.arn
  container_definitions    = data.template_file.ecs_task_definition.rendered
}

resource "aws_ecs_service" "service" {
  name            = "${var.identifier}-executor"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.target_group.arn
    container_name   = var.identifier
    container_port   = 80
  }
}

resource "aws_alb" "alb" {
  name            = "${var.identifier}-alb"
  internal        = false
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.public_subnet_ids
}

resource "aws_alb_target_group" "target_group" {
  name        = "${var.identifier}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target_group.arn
  }
}
