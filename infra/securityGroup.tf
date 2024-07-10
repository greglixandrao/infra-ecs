resource "aws_security_group" "public_sg_alb" {
  name   = "ECS_alb"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg_alb.id
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg_alb.id
}

resource "aws_security_group" "private_sg" {
  name   = "private_sg_ecs"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ecs_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.public_sg_alb.id
  security_group_id        = aws_security_group.private_sg.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.public_sg_alb.id
  security_group_id        = aws_security_group.private_sg.id
}
resource "aws_security_group_rule" "ecs_ecr_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.private_sg.id
}
