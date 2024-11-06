provider "google" {
  region      = var.location
  project     = var.project_id
  credentials = "auth/auth.json"
}

terraform {
  required_version = "~> 1.6.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.3.0"
    }
  }
}