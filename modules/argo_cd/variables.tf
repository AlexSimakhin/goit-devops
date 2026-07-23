variable "namespace" {
  description = "Namespace for Argo CD installation"
  type        = string
  default     = "argocd"
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

variable "db_endpoint" {
  description = "Database connection endpoint"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}