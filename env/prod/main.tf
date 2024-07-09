module "production" {
  source          = "../../infra"
  repository_name = "production"
  iamRole = "production"
}

output "ip-alb" {
  value = module.production.dns-IP
}
