variable "multi-docker-sg-name" {
  description = "The security group name that RDS, ElastiCache and EBS will use"
  type = string
  default = "multi-docker-sg"
}

variable "multi-docker-sg-port-from" {
  description = "the initial port rage to open, Redis"
  type = number
  default = 5432
}

variable "multi-docker-sg-port-to" {
  description = "the final port rage to open, RDS"
  type = number
  default = 6379
}

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
#
# Note that this variable does not have a default. This is intentional. You should not store
# your database password or any sensitive information in plain text. Instead, you’ll set
# this variable using an environment variable.
#
#  $  export TF_VAR_db_password="(YOUR_DB_PASSWORD)"
#
# Note that there is intentionally a space before the export command to prevent the secret from
# being stored on disk in your Bash history.
#
# A better way is to store this in AW Secret Manager (aws_secretmanager_secret_version) or
# AWS System Manager Parameter Store (aws_ssm_parameter data source)
# ---------------------------------------------------------------------------------------------------------------------

variable "db_instance_identifier" {
  description = "the db instance identifier"
  type        = string
  default     = "multi-docker-postgres"
}

variable "master_user_name" {
  description = "The user name for the database"
  type        = string
  default     = "postgres" //this is just for learning purposes, not for a prod deploy.
}

variable "master_password" {
  description = "The password for the database"
  type        = string
  default     = "postgrespassword" //this is just for learning purposes, not for a prod deploy.
}

variable "initial_db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "fibvalues"
}