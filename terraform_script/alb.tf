resource "aws_lb_target_group" "targetgroup" {
  name        = "wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id
  health_check {
      healthy_threshold   = var.health_check["healthy_threshold"]
      interval            = var.health_check["interval"]
      unhealthy_threshold = var.health_check["unhealthy_threshold"]
      timeout             = var.health_check["timeout"]
      path                = var.health_check["path"]
      port                = var.health_check["port"]
  }
}

resource "aws_lb_target_group_attachment" "tg-attach-1" {
  target_group_arn = aws_lb_target_group.targetgroup.arn
  target_id        = aws_instance.webserver[0].id 
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg-attach-2" {
  target_group_arn = aws_lb_target_group.targetgroup.arn
  target_id        = aws_instance.webserver[1].id 
  port             = 80
}

resource "aws_lb" "loadbalancer" {
  name               = "wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public[0].id, aws_subnet.public[1].id]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgroup.arn
  }
}