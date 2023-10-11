output "EC2_Pub_IP" {
  value       = aws_eip.BastionHost_eip.public_ip
  description = "EC2 Instance Public IP Address"
}