variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "lesson-8-9-ecr"
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}