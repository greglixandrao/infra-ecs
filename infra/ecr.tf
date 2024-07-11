resource "aws_ecr_repository" "container_ecs_repository" {
  name = var.repository_name
  force_delete = true
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
	scan_on_push = true
  }
}
