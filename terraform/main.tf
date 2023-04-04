# Criando o ECR

resource "aws_ecr_repository" "foo" {
  name                 = "bar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Cluster ECS

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

# Criando um task definition para rodar a image

resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  container_definitions    = jsonencode([{
    name      = "my-container"
    image     = "my-image"
    cpu       = 256
    memory    = 512
    portMappings = [
      {
        containerPort = 3000
        hostPort      = 0
      }
    ]
  }])
}

# criacao de ecs service

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn

  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.my_sg.id]
    subnets         = [aws_subnet.my_subnet.id]
  }
}





