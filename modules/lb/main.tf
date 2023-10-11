resource "aws_lb" "my_lb" {
  name               = "my-lb"
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet1, var.public_subnet2]
}


resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 : Page Not Found"
      status_code  = "404"
    }
  }
}


resource "aws_lb_listener_rule" "my_lb_listener_rule" {
  listener_arn = aws_lb_listener.my_lb_listener.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_lb_tg.arn
  }
}


resource "aws_lb_target_group" "my_lb_tg" {
  name     = "my-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {                 # Target Group과 연결 된 ASG EC2 Instance 상태 체크 
    path                = "/"    # 상태 검사를 진행 할 URI 정의
    protocol            = "HTTP" # 상태 검사를 수행 할 Protocol (HTTP)
    matcher             = "200"  # HTTP 상태코드 값이 "200"인 경우 정상으로 판단
    interval            = 15     # 상태검사 주기 (15초)
    timeout             = 3      # 상태검사 응답대기 시간 (3초)
    healthy_threshold   = 3      # 연속 3번 정상 응답 -> 정상으로 판단
    unhealthy_threshold = 3      # 연속 3번 비정상 응답 -> 비정상으로 판단
  }
}