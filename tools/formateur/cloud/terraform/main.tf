terraform {
  required_version = ">= 1.6"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.3.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Instance CloudSQL PostgreSQL
resource "google_sql_database_instance" "main" {
  name             = "sfeir-institute-dbt"
  database_version = "POSTGRES_15"
  region           = var.region
  deletion_protection = false

  settings {
    tier = var.cloudsql_tier
    
    ip_configuration {
      ipv4_enabled = true
      
      # ATTENTION : Ouvert à tous par défaut
      # En production, restreindre aux IPs de la formation
      authorized_networks {
        name  = "Public Access"
        value = "0.0.0.0/0"
      }
    }

    backup_configuration {
      enabled = false  # Désactivé pour réduire les coûts
    }

    insights_config {
      query_insights_enabled = false
    }
  }
}

# Base de données principale (formateur)
resource "google_sql_database" "main" {
  name     = "sfeir_dbt"
  instance = google_sql_database_instance.main.name
}

# Utilisateur principal (formateur)
resource "google_sql_user" "trainer" {
  name     = "dbt"
  instance = google_sql_database_instance.main.name
  password = var.cloudsql_password
}

# Bases de données pour les étudiants
resource "google_sql_database" "students" {
  count    = var.cloudsql_user_count
  name     = "student_${format("%02d", count.index + 1)}"
  instance = google_sql_database_instance.main.name
}
