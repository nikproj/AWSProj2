resource "aws_efs_file_system" "efs" {
  creation_token         = "wordpress-efs"
  encrypted              = "false"
}

resource "aws_efs_mount_target" "efs-mount-1" {
   file_system_id        = aws_efs_file_system.efs.id
   subnet_id             = aws_subnet.private[2].id  
   security_groups       = [aws_security_group.efs_sg.id]
 }

resource "aws_efs_mount_target" "efs-mount-2" {
   file_system_id        = aws_efs_file_system.efs.id
   subnet_id             = aws_subnet.private[3].id  
   security_groups       = [aws_security_group.efs_sg.id]
 }