module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-ecs"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false

  tags = {
    environment = "prod"
  }
}

# resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
#   depends_on          = [aws_ecr_repository.ecr_repository]
#   service_name        = "com.amazonaws.${var.region}.ecr.dkr"
#   vpc_id              = module.vpc.vpc_id
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   subnet_ids         = module.vpc.private_subnets
#   security_group_ids = [aws_security_group.vpc_endpoint_service.id, aws_security_group.privatenet.id]
# }

# resource "aws_vpc_endpoint" "ecr_api_endpoint" {
#   depends_on          = [aws_ecr_repository.ecr_repository]
#   service_name        = "com.amazonaws.${var.region}.ecr.api"
#   vpc_id              = module.vpc.vpc_id
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = true

#   subnet_ids         = module.vpc.private_subnets
#   security_group_ids = [aws_security_group.vpc_endpoint_service.id, aws_security_group.privatenet.id]
# }

# resource "aws_vpc_endpoint" "s3" {
#   depends_on   = [aws_ecr_repository.ecr_repository]
#   vpc_id       = module.vpc.vpc_id
#   service_name = "com.amazonaws.${var.region}.s3"
# }
