output "builder_ecr_repository_url" {
  value = aws_ecr_repository.builder.repository_url
}

output "app_ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}
