output "tg_arn" {
  value = aws_lb_target_group.my_lb_tg.arn
  description = "LB Target Group ARN"
}

output "ALB_DNS" {
  value = aws_lb.my_lb.dns_name
  description = "Load Balancer Domain Name"
}