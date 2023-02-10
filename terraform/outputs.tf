output "kaniko_ecr_repository_url" {
  value = module.ecr.builder_ecr_repository_url
}

output "app_ecr_repository_url" {
  value = module.ecr.app_ecr_repository_url
}
