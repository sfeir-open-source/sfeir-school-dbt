variable "location" {
  type        = string
  default     = "europe-west1"
}

variable "project_id" {
  type = string
}

variable "cloudsql_size" {
  type    = string
  default = "db-f1-micro"
}

variable "cloudsql_password" {
  type    = string
  default = "SFEIR_INSTITUTE_FTW"
}

variable "cloudsql_user_count" {
  type = number
  default = 3
}