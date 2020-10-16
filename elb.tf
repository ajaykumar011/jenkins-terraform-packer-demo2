resource "aws_elb" "app-elb" {
  name            = "app-elb"
  subnets         = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  security_groups = [aws_security_group.elb-securitygroup.id]
  tags {
    Name = "app-elb-tag"
  }
}

resource "aws_elb_listener" "app-elb-http" {
  load_balancer_arn = aws_elb.app-elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_elb_target_group.app-elb-tg1.id
    // target_group_index = 0
    type             = "forward"
  }
  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}

// resource "aws_elb_listener" "app-elb-https" {
//   load_balancer_arn = aws_elb.app-elb.arn
//   port              = "443"
//   protocol          = "HTTPS"
//   ssl_policy        = "ELBSecurityPolicy-2016-08"
//   certificate_arn   = var.certificate_arn

//   default_action {
//     target_group_arn = aws_elb_target_group.app-elb-tg2.id
//     // target_group_index = 0
//     type             = "forward"
//   }
// }

resource "aws_elb_target_group" "app-elb-tg1" {
  name                 = "app-elb-tg1"
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





