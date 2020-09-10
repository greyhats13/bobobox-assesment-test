resource "aws_ecr_repository" "registry" {
  count                = length(var.ecr_name)
  name                 = element(var.ecr_name, count.index)
  image_tag_mutability = var.image_tag
}