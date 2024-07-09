resource "aws_lb" "alb_ecs" {
  name               = "ecs_alb_django"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg_alb.id]
  subnets            = [module.vpc.public_subnets]
}

resource "aws_lb_listener" "http_application" {
  load_balancer_arn = aws_lb.alb_ecs.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_ip.arn
  }
}

resource "aws_lb_target_group" "target_ip" {
  name        = "ecs_alb_django"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

output "dns-IP" {
  value = aws_alb.alb_ecs.dns_name
}
