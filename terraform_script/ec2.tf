locals {
  subs = concat([aws_subnet.private[0].id], [aws_subnet.private[1].id])
}

resource "aws_instance" "webserver"{
 tags = merge (
      {
          Name = "${var.name}-webserver-${count.index}"
      },
      var.tags
  )
 count                          = 2
 ami                            = var.ami
 instance_type                  = var.insttype
 key_name                       = aws_key_pair.tf-key.key_name
 subnet_id                      = element(local.subs, count.index)
 associate_public_ip_address    = false
 security_groups                = [aws_security_group.webserver_sg.id]
 /*
 user_data = <<-EOF
                     #!/bin/bash

                     sudo yum update -y
                     sudo yum install -y httpd httpd-tools mod_ssl
                     sudo systemctl enable httpd 
                     sudo systemctl start httpd

                     sudo amazon-linux-extras enable php7.4
                     sudo yum clean metadata
                     sudo yum install php php-common php-pear -y
                     sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y
   
                     sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
                     sudo yum install mysql-community-server -y
                     sudo systemctl enable mysqld
                     sudo systemctl start mysqld
                     
                     #Replace This with the mount-point
                     echo "fs-aed8ad5b.efs.us-east-1.amazonaws.com:/ /var/www/html nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab 
                     mount -a 
     
                    service httpd restart      
                 EOF
*/
}

resource "aws_instance" "bastion"{
  tags = merge (
      {
          Name = "${var.name}-bastion"
      },
      var.tags
  )
 ami                            = var.ami
 instance_type                  = var.insttype
 key_name                       = aws_key_pair.tf-key.key_name
 subnet_id                      = aws_subnet.public[0].id
 associate_public_ip_address    = true
 security_groups                = [aws_security_group.bastion_sg.id, aws_security_group.efs_sg.id, aws_security_group.alb_sg.id]
}