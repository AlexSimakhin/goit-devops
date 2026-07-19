variable "namespace" {
  description = "Namespace for Jenkins installation"
  type        = string
  default     = "jenkins"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Base64 encoded cluster certificate authority data"
  type        = string
}

variable "admin_password" {
  description = "Admin password for Jenkins"
  type        = string
}

variable "service_account_role_arn" {
  description = "IAM role ARN to annotate the Jenkins Kubernetes service account with"
  type        = string
}