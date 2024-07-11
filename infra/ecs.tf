module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = var.environment

  cluster_settings = [
    {
      "name" : "containerInsights",
      "value" : "enabled"
    }
  ]

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
        base   = 50
      }
      enable_cloudwatch_logging = true
    }
  }
}

resource "aws_ecs_task_definition" "task_django_api" {
  family                   = "task_django_api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.iamRole.arn
  container_definitions = jsonencode(
    [
      {
        "name"      = var.environment
        "image"     = "${var.aws_account_number}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.environment}:${var.image_tag}"
        "cpu"       = 256
        "memory"    = 512
        "essential" = true
        "portMappings" = [
          {
            "containerPort" = 8000
            "hostPort"      = 8000
          }
        ]
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "/aws/ecs/production",
            "awslogs-region" : "us-west-2",
            "awslogs-stream-prefix" : "django-api"
          }
        }
      }
    ]
  )
}

resource "aws_ecs_service" "service_django_api" {
  name            = "service_django_api"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.task_django_api.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target_ip.arn
    container_name   = "${var.environment}"
    container_port   = 8000
  }

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.private_sg.id, aws_security_group.vpc_endpoint_service.id]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

