resource "aws_instance" "app_ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type 
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  root_block_device {
    volume_size           = "50"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
    tags = merge(
      local.common_tags,
      {
        Name = "app-dev-ue1-vlm-001"
        Backup = "dev"
      }
    )
  }
  
  tags = merge(
    local.common_tags,
    {
      Name = "app-dev-ue1-ec2-001"
      Backup = "dev"
    }
  )
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "app_profile"
  role = aws_iam_role.app_role.name

  tags = merge(
    local.common_tags,
    {
      "Name" = "app-profile"
    }
  )
}

resource "aws_eip" "eip" {
  instance = aws_instance.app_ec2.id
  vpc      = true

  tags = merge(
    local.common_tags,
    {
      "Name" = "app-dev-ue1-eip-001"
    }
  )
}