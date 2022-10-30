resource "aws_security_group" "allow_leader_ui_lb" {
  name        = "allow_lb_leader_ui"
  description = "Allow Access to Cribl UI for the ALB"
  vpc_id      = var.AWS_VPC

  ingress {
    description = "Leader Port 9000"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 9000
    to_port          = 9000 
    protocol         = "tcp"
    security_groups  = [aws_security_group.leader_instance_sg.id]
  }


  tags = {
    Name = "cribl_leader_ui"
  }
}

data "aws_subnets" "instance_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.AWS_VPC]
  }
}


resource "aws_lb" "Cribl_Leader_UI" {
  name               = "CriblLeaderUI"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_leader_ui_lb.id]
  subnets            = [for subnet in data.aws_subnets.instance_subnets.ids : subnet]

  tags = {
    Environment = "cribl"
  }
}


resource "aws_lb_listener" "cribl_ui_listener" {
  load_balancer_arn = aws_lb.Cribl_Leader_UI.arn
  port              = "9000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_cribl_leader_ui.arn
  }
}
