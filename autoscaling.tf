resource "aws_launch_template" "app-launchtp" {
  name = "app-launchtp"

  // block_device_mappings {
  //   device_name = "/dev/sda1"

  //   ebs {
  //     volume_size = 20
  //   }
  // }

  disable_api_termination = false
  ebs_optimized = true

  iam_instance_profile {
    name = aws_iam_instance_profile.app-ec2-role.name
  }

  image_id = var.APP_AMI
  //instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mykey.key_name

  // monitoring {
  //   enabled = true
  // }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
   }
  // placement {
  //   availability_zone = "us-east-1a"
  // }

  vpc_security_group_ids = [aws_security_group.myinstance.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app-launch"
    }
  }
  //user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools" // not working here
  //user_data = filebase64("${path.module}/userdata.sh")
}
resource "aws_autoscaling_group" "app-launchtp-asg" {
  name                      = "app-launchtp-asg"
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  //health_check_grace_period = 300
  //health_check_type         = "EC2"  #this is important 
  target_group_arns         = [aws_lb_target_group.app-alb-tg1.arn]
  force_delete              = true
  launch_template {
    id      = aws_launch_template.app-launchtp.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }

    depends_on = [
        "${aws_lb_target_group.app-alb-tg1.arn}"
    ]
 
}

