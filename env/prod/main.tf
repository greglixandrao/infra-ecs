module "production" {
  source          = "../../infra"
  repository_name = "production"
  iamRole         = "production"
  environment     = "production"
}

output "ip-alb" {
  value = module.production.dns-IP
}
