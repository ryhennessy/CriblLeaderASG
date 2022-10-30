resource "aws_lb_target_group" "alb_cribl_leader_ui" {
  name     = "alb-cribl-leader-ui"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = var.AWS_VPC

  health_check {
    path                = "/api/v1/health"
    port                = 9000
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "nlb_cribl_leader_port_9000" {
  name     = "nlb-cribl-leader-port-9000"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = var.AWS_VPC

  health_check {
    path                = "/api/v1/health"
    port                = 9000
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 10
    matcher             = "200"
  }
}


resource "aws_lb_target_group" "nlb_cribl_leader_port_4200" {
  name     = "nlb-cribl-leader-port-4200"
  port     = 4200
  protocol = "HTTP"
  vpc_id   = var.AWS_VPC

  health_check {
    path                = "/api/v1/health"
    port                = 9000
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 10
    matcher             = "200"
  }
}
