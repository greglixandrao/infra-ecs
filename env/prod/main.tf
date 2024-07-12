module "production" {
  source          = "../../infra"
  repository_name = "production"
  iamRole         = "production"
  environment     = "production"
  aws_region      = "us-west-2"
}

output "ip-alb" {
  value = module.production.dns-IP
}
