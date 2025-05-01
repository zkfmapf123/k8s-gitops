locals {
    service = jsondecode(file("service.json"))
}

resource "aws_ecr_repository" "image_registry" {
    for_each = local.service
    name = each.key
}