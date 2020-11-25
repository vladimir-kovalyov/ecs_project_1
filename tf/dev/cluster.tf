resource "aws_ecs_cluster" "mike_al_cluster" {
  name = "mike-al-cluster"
}

resource "aws_ecs_task_definition" "mike_al_task" {
  family                   = "worker" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "worker",
      "image": "603825719481.dkr.ecr.eu-west-1.amazonaws.com/acad-proj2-al-michael:prod-latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "mike-al-cw",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "memory": 1024,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 1024
  cpu                      = 256
  execution_role_arn       = aws_iam_role.mikeAlEcsTaskExecutionRole.arn
}

resource "aws_ecs_service" "mike_al_service" {
  name            = "mike_al_service"
  cluster         = aws_ecs_cluster.mike_al_cluster.id
  task_definition = aws_ecs_task_definition.mike_al_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.mike_al_alb_tg.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.mike_al_task.family
    container_port   = 80
  }

  network_configuration {
    subnets = [
      aws_subnet.mike_al_VPC_SubnetOne.id,
      aws_subnet.mike_al_VPC_SubnetTwo.id
    ]
    assign_public_ip = true # Providing our containers with public IPs
  }
}

resource "aws_security_group" "mike_al_service_sg" {
  vpc_id = aws_vpc.mike_al_VPC.id
  name   = "mike-al-service-sg"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.mike_al_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "mikeAlEcsTaskExecutionRole" {
  name               = "mikeAlEcsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.mike_al_assume_role_policy.json
}

data "aws_iam_policy_document" "mike_al_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "mikeAlEcsTaskExecutionRole_policy" {
  role       = aws_iam_role.mikeAlEcsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
