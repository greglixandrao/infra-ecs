resource "aws_ecr_repository" "container_ecs_repository" {
  name = var.repository_name
}
