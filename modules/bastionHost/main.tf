// Bastion Host Resource 영역
resource "aws_instance" "my_BastionHost" {
  ami                         = var.ami
  instance_type               = var.bastionHost_instance_type
  key_name                    = data.aws_key_pair.EC2-Key.key_name
  availability_zone           = var.bastion_availability_zone
  subnet_id                   = var.bastion_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.ssh_sg_id]

  tags = {
    Name = "BastionHost_Instance"
  }
}

// BastionHost에 고정적인 Public IP를 부여하기 위해 EIP 설정을 함께 진행
resource "aws_eip" "BastionHost_eip" {
  instance = aws_instance.my_BastionHost.id
  tags = {
    Name = "BastionHost_EIP"
  }
}