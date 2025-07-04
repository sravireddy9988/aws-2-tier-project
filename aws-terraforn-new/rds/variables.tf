variable "db_identifier" {
  description = "Unique identifier for the RDS DB instance"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "storage_type" {
  description = "Storage type (e.g., gp2, gp3)"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g., postgres, mysql)"
  type        = string
}

variable "engine_version" {
  description = "Version of the selected database engine"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class (e.g., db.t3.micro)"
  type        = string
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "security_group_id" {
  description = "Security Group ID to associate with the RDS instance"
  type        = string
}

variable "db_subnet_ids" {
  description = "List of private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}

variable "backup_retention_period" {
  description = "Number of days to retain backups (0 to disable)"
  type        = number
}
