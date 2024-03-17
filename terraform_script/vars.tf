variable "region" {
    description = "Region Of VPC"
    type = string 
    default = "us-east-1"  
}

variable "name" {
    description = "Name of the VPC"
    type = string    
    default = "Proj2-VPC"
}

variable "tags" {
    description = "Region Of VPC"
    type = map
    default = null
}

variable "vpc_cidr_block" {
    description = "CIDR Range Of VPC"
    type = string  
    default = "11.0.0.0/16"
}

variable "availability_zones" {
    description = "Region Of VPC"
    type = list(string)
    default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidr_blocks" {
    description = "Region Of VPC"
    type = list(string)  
    default = ["11.0.1.0/24", "11.0.2.0/24"]  
}

variable "availability_zones_2" {
    description = "Region Of VPC"
    type = list(string)
    default = ["us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidr_blocks" {
    description = "Region Of VPC"
    type = list(string) 
    default = ["11.0.3.0/24", "11.0.4.0/24", "11.0.5.0/24", "11.0.6.0/24"]  
}

variable "insttype" {
    description   = "Instance Type"
    type          = string
    default       = "t2.micro"  
}

variable "ami" {
    description   = "AMI ID of Amazon-Linux in us-east-1"
    type          = string
    default       = "ami-0440d3b780d96b29d"  
}

variable "health_check" {
   type = map(string)
   default = {
      "timeout"  = "10"
      "interval" = "20"
      "path"     = "/"
      "port"     = "80"
      "unhealthy_threshold" = "2"
      "healthy_threshold" = "3"
    }
}