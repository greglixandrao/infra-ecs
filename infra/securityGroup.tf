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

resource "aws_security_group" "vpc_endpoint_service" {
  name        = "private_VPC_endpoint"
  description = "To access the Private subnet"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ingress_ECR" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  # self = true
  security_group_id        = aws_security_group.vpc_endpoint_service.id
#   source_security_group_id = aws_security_group.public_sg_alb.id
  # cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  cidr_blocks = ["0.0.0.0/0"]
  # # prefix_list_ids = [data.aws_prefix_list.ecr_api_endpoint.id, data.aws_prefix_list.ecr_dkr_endpoint.id]
  # security_group_id = aws_security_group.vpc_endpoint_service.id
}

resource "aws_security_group_rule" "egress_ECR" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  # self = true # not necessary if cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_endpoint_service.id
  #   prefix_list_ids   = [data.aws_prefix_list.ecr_dkr.id, data.aws_prefix_list.s3.id]
  cidr_blocks = ["0.0.0.0/0"]
  #   security_group_id = aws_security_group.vpc_endpoint_service.id
}
