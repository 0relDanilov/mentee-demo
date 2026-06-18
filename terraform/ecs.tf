resource "aws_ecs_cluster" "main" {
  name = "mentee-demo-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "mentee-demo"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "mentee-demo"
    image     = "${aws_ecr_repository.app.repository_url}:latest"
    essential = true

    portMappings = [{
      containerPort = 8080
      protocol      = "tcp"
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  # Pipeline-driven deploys register new task def revisions with updated
  # image tags. Without this, every `terraform apply` would try to revert
  # container_definitions back to the seed image, fighting the pipeline.
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

resource "aws_ecs_service" "app" {
  name            = "mentee-demo-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  # The Deploy stage bumps the service's task_definition revision per release.
  # Letting Terraform manage it would cause every plan to want to roll the
  # service back to the initial revision.
  lifecycle {
    ignore_changes = [task_definition]
  }
}
