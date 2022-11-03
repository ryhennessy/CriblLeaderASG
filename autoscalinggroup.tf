resource "aws_security_group" "leader_instance_sg" {
  name        = "LeaderInstanceSG"
  description = "Allow Ports for Leader Communication"
  vpc_id      = var.AWS_VPC

  ingress {
    from_port   = 9000
    to_port     = 9000
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  ingress {
    from_port   = 4200
    to_port     = 4200
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "CriblLeaderSG"
  }
}



resource "aws_launch_template" "cribl_leader" {
  name = "CriblLeader"
  //Need to create a data source to pull the latest image id
  image_id               = "ami-0b8b40dbcaecb0eb1"
  instance_type          = "c6g.large"
  vpc_security_group_ids = [aws_security_group.leader_instance_sg.id]
  user_data              = base64encode(templatefile("leader.tpl", { efsname = aws_efs_file_system.criblfailover.id, awsregion = var.AWS_REGION, license = var.CRIBL_LIC }))
  key_name               = var.SSHKEYNAME
  monitoring {
    enabled = false
  }
}

resource "aws_autoscaling_group" "cribl_leader" {
  name                      = "CriblLeaderFO"
  max_size                  = var.NUMOFINST
  min_size                  = var.NUMOFINST
  health_check_grace_period = 300
  desired_capacity          = var.NUMOFINST
  force_delete              = false
  launch_template {
    name = aws_launch_template.cribl_leader.name
  }
  vpc_zone_identifier = [for subnet in data.aws_subnets.instance_subnets.ids : subnet]
  target_group_arns   = toset([aws_lb_target_group.alb_cribl_leader_ui.arn, aws_lb_target_group.nlb_cribl_leader_port_4200.arn, aws_lb_target_group.nlb_cribl_leader_port_9000.arn])
  health_check_type   = "EC2"
  depends_on          = [aws_efs_access_point.criblfailover, aws_lb.Cribl_Leader_UI, aws_lb.Cribl_Leader_Worker_LB]
}




