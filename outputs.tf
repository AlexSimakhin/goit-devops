output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "s3_state_bucket_url" {
  description = "The URL of the S3 state bucket"
  value       = module.s3_backend.bucket_url
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB lock table"
  value       = module.s3_backend.dynamodb_table_name
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "jenkins_namespace" {
  value = module.jenkins.jenkins_namespace
}

output "argocd_namespace" {
  value = module.argo_cd.argocd_namespace
}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = module.jenkins.jenkins_url
}

output "argocd_url" {
  description = "ArgoCD URL"
  value       = module.argo_cd.argocd_url
}