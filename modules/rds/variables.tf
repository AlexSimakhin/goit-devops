variable "name" {
  description = "Instance or cluster name"
  type        = string
}

variable "engine" {
  description = "Database engine for standard RDS"
  type        = string
  default     = "postgres"
}

variable "engine_cluster" {
  description = "Database engine for Aurora cluster"
  type        = string
  default     = "aurora-postgresql"
}

variable "aurora_replica_count" {
  description = "Number of read-only replicas for Aurora"
  type        = number
  default     = 1
}

variable "aurora_instance_count" {
  description = "Total number of instances for Aurora"
  type        = number
  default     = 2
}

variable "engine_version" {
  description = "Engine version for standard RDS"
  type        = string
  default     = "17.2"
}

variable "engine_version_cluster" {
  description = "Engine version for Aurora cluster"
  type        = string
  default     = "15.3"
}

variable "parameter_group_family_rds" {
  description = "Parameter group family for standard RDS"
  type        = string
  default     = "postgres17"
}

variable "parameter_group_family_aurora" {
  description = "Parameter group family for Aurora"
  type        = string
  default     = "aurora-postgresql15"
}

variable "instance_class" {
  description = "Instance class for the database"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage in GB for standard RDS"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_private_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the database is publicly accessible"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Enable Multi-AZ for standard RDS"
  type        = bool
  default     = false
}

variable "parameters" {
  description = "Custom parameters for the database"
  type        = map(string)
  default     = {}
}

variable "use_aurora" {
  description = "Set to true to deploy Aurora, false for standard RDS"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for database access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}