resource "aws_ecr_repository" "acad_proj2_al_michael" {
  name = "acad-proj2-al-michael"
}

resource "aws_ecs_cluster" "mike_al_cluster" {
  name = "mike-al-cluster"
}

resource "aws_ecs_service" "mike_al_service" {
  name            = "mike-al-service"
  cluster         = aws_ecs_cluster.mike_al_cluster.id
  task_definition = aws_ecs_task_definition.mike_al_task.arn
  launch_type     = "EC2"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.mike_al_alb_tg.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.mike_al_task.family
    container_port   = 80
  }

  network_configuration {
    subnets          = [aws_subnet.mike_al_VPC_Subnet.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "mike_al_task" {
  family                   = "mike-al-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "mike-al-task",
      "image": "aws_ecr_repository.acad-proj2-al-michael.repository_url:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "memory": 512,
      "cpu": 2
    }
  ]
  DEFINITION
  requires_compatibilities = ["EC2"]  # Stating that we are using ECS Fargate
  network_mode             = "awsvpc" # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512      # Specifying the memory our container requires
  cpu                      = 2        # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "mike_al_ex_role" {
  name               = "mike_al_ex_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "mike_al_ex_role_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}