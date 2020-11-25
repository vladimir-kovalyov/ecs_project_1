resource "aws_ecs_cluster" "mike_al_cluster" {
  name = "mike-al-cluster"
}

resource "aws_iam_role" "mike_al_ecs_instance_role" {
  name               = "mike-al-ecs-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.mike_al_ecs_instance_policy.json
}

data "aws_iam_policy_document" "mike_al_ecs_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "mike_al_ecs_instance_role_attachment" {
  role       = aws_iam_role.mike_al_ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "mike-al-ecs-instance-profile"
  path = "/"
  role = aws_iam_role.mike_al_ecs_instance_role.id
  provisioner "local-exec" {
    command = "sleep 10"
  }
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
      "memory": 512,
      "cpu": 2
    }
  ]
  DEFINITION
  requires_compatibilities = ["EC2"]  # Stating that we are using ECS Fargate
  network_mode             = "awsvpc" # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512      # Specifying the memory our container requires
  cpu                      = 256      # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.mike_al_ex_role.arn
}

resource "aws_ecs_service" "mike_al_service" {
  name            = "mike_al_service"
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
    subnets = [
      aws_subnet.mike_al_VPC_SubnetOne.id,
      aws_subnet.mike_al_VPC_SubnetTwo.id
    ]
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

# Setting resources for auto-scaling group - START
data "aws_iam_policy_document" "mike_al_ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "mike_al_ecs_agent" {
  name               = "mike-al-ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.mike_al_ecs_agent.json
}


resource "aws_iam_role_policy_attachment" "mike_al_ecs_agent" {
  role       = aws_iam_role.mike_al_ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "mike_al_ecs_agent" {
  name = "mike-al-ecs-agent"
  role = aws_iam_role.mike_al_ecs_agent.name
}

resource "aws_launch_configuration" "mike_al_ecs_launch_config" {
  image_id             = "ami-0bf2c3827d202c3bb"
  iam_instance_profile = aws_iam_instance_profile.mike_al_ecs_agent.name
  security_groups      = [aws_security_group.mike_al_VPC_Security_Group.id]
  user_data            = <<EOF
    "#!/bin/bash"
    "echo ECS_CLUSTER=mike-al-cluster >> /etc/ecs/ecs.config"
    EOF
  instance_type        = "t2.micro"
  key_name = "mike-al-keypair"
}

resource "aws_autoscaling_group" "mike_al_failure_analysis_ecs_asg" {
  name                 = "mike-al-asg"
  vpc_zone_identifier  = [aws_subnet.mike_al_VPC_SubnetOne.id]
  launch_configuration = aws_launch_configuration.mike_al_ecs_launch_config.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
}
# Setting resources for auto-scaling group - END

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
  role       = aws_iam_role.mike_al_ex_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
