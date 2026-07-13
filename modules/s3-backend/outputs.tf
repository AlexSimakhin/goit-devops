output "bucket_url" {
  description = "URL of the Terraform state bucket"
  value       = "https://${aws_s3_bucket.terraform_state.bucket_regional_domain_name}"
}

output "s3_bucket_id" {
  description = "ID of the Terraform state bucket"
  value       = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB lock table"
  value       = aws_dynamodb_table.terraform_locks.name
}