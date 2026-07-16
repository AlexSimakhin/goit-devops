variable "use_aurora" {
  description = "Set to true to use Aurora Cluster, false for standard RDS"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB Subnet Group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the database"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "db_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "mydatabase"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "myuser"
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "engine" {
  description = "Database engine (e.g., postgres, aurora-postgresql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Version of the database engine"
  type        = string
  default     = "17.2"
}

variable "instance_class" {
  description = "Instance type for the database"
  type        = string
  default     = "db.t3.medium"
}

variable "multi_az" {
  description = "Enable Multi-AZ for standard RDS"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Allocated storage in GB for standard RDS"
  type        = number
  default     = 20
}

variable "parameter_group_family" {
  description = "Family of the parameter group (e.g., postgres15, aurora-postgresql15)"
  type        = string
  default     = "postgres15"
}

variable "db_parameters" {
  description = "List of instance-level DB parameters"
  type        = list(map(string))
  default = [
    { name = "max_connections", value = "100" },
    { name = "work_mem", value = "4096" }
  ]
}

variable "cluster_parameters" {
  description = "List of cluster-level DB parameters (for Aurora)"
  type        = list(map(string))
  default = [
    { name = "log_statement", value = "all" }
  ]
}