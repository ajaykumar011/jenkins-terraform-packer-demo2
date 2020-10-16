resource "aws_elb" "app-elb" {
  name            = "app-elb"
  subnets         = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  security_groups = [aws_security_group.elb-securitygroup.id]
}

resource "aws_elb_listener" "app-elb" {
  load_balancer_arn = aws_elb.app-elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_elb_target_group.app-elb-blue.id
    target_group_index = 0
    type             = "forward"
  }
  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}

resource "aws_elb_target_group" "app-elb-blue" {
  name                 = "app-http-blue"
  port                 = "80"
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "30"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
  }
}
resource "aws_elb_target_group" "app-elb-green" {
  name                 = "app-http-green"
  port                 = "80"
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = "30"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 30
    target              = "HTTP:80/"
    interval            = 30
  }
}




