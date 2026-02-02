variable "project_id" {
  description = "ID du projet GCP"
  type        = string
}

variable "region" {
  description = "Région GCP"
  type        = string
  default     = "europe-west1"
}

variable "cloudsql_password" {
  description = "Mot de passe pour l'utilisateur dbt"
  type        = string
  sensitive   = true
}

variable "cloudsql_user_count" {
  description = "Nombre d'étudiants (nombre de bases de données)"
  type        = number
  default     = 20
}

variable "cloudsql_tier" {
  description = "Taille de l'instance CloudSQL"
  type        = string
  default     = "db-f1-micro"
  # Options: db-f1-micro, db-g1-small, db-n1-standard-1, etc.
}
