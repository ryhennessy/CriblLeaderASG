resource "aws_security_group" "allow_nfs" {
  name        = "Cribl_Leader_EFS"
  description = "Allow NFS inbound traffic"
  vpc_id      = var.AWS_VPC

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.leader_instance_sg.id]
  }
}

resource "aws_efs_file_system" "criblfailover" {
  creation_token = "cribl-leader-failover"
  encrypted      = true

  tags = {
    Name = "CriblLeaderFailover"
  }
}


resource "aws_efs_access_point" "criblfailover" {
  file_system_id = aws_efs_file_system.criblfailover.id
}


resource "aws_efs_mount_target" "criblfailover" {
  file_system_id  = aws_efs_file_system.criblfailover.id
  subnet_id       = each.key
  security_groups = [aws_security_group.allow_nfs.id]
  for_each        = toset(data.aws_subnets.instance_subnets.ids)
}

