// ASG (Auto Scaling Group) 시작 템플릿 영역
resource "aws_launch_configuration" "my_ASG_Launch" {
  image_id        = var.asg_ami
  instance_type   = var.instance_type
  security_groups = [var.ssh_sg_id, var.alb_sg_id]

  user_data = <<-EOF
    #!/bin/bash
    yum -y update
    yum -y install httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
  EOF

  lifecycle {
    create_before_destroy = true
  }
}


// ASG (Auto Scaling Group) 영역
resource "aws_autoscaling_group" "my_ASG" {
  launch_configuration = aws_launch_configuration.my_ASG_Launch.name
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = [var.private_subnet1, var.private_subnet2]

  target_group_arns = [var.lb_tg_arn]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "my_ASG_EC2Instance"
    propagate_at_launch = true
  }
}