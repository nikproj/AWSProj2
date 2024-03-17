#SubnetGroup for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private[2].id, aws_subnet.private[3].id]
}

#RDS- MySQL
resource "aws_db_instance" "sqldatabase" {
  engine               = "mysql"
  engine_version       = "5.7.37"
  identifier           = "proj2-db"
  username             = "dbadmin"
  password             = "admin1234567"
  instance_class       = "db.t2.micro"
  storage_type         = "gp2"
  allocated_storage    = 20
  publicly_accessible  = false
  skip_final_snapshot  = true
  db_name              = "wordpressdb"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  multi_az               = "false"
}