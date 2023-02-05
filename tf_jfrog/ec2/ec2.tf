resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type 
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = false
    tags = merge(
      local.common_tags,
      {
        Name = "jfrog-shs-ue1-vlm-001"
        Backup = "shs"
      }
    )
  }

  tags = merge(
    local.common_tags,
    {
      "Name" = "jfrog-shs-ue1-ec2-001"
    }
  )
}

resource "aws_eip" "eip" {
  instance = aws_instance.ec2.id
  vpc      = true

  tags = merge(
    local.common_tags,
    {
      "Name" = "jfrog-shs-ue1-eip-001"
    }
  )
}