#!/bin/bash
sudo yum update -y

sudo yum install php -y
sudo yum install php-mysqli -y
sudo yum install mariadb105 -y

sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

#Then we will create some permits to access the Apache public folder
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www/html
sudo chown -R apache:apache /var/www/html

#To get wordpress
wget https://wordpress.org/latest.zip
unzip latest.zip
