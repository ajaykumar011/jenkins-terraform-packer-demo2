output "ELB" {
  value = aws_elb.app-alb.dns_name
}

