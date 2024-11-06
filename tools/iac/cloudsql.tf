resource "google_sql_database_instance" "cloudsql" {
  name                = "sfeir-institute"
  database_version    = "POSTGRES_15"
  region              = var.location
  deletion_protection = false


  settings {
    tier = var.cloudsql_size
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "Public Access"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_database" "database" {
  name     = "sfeir"
  instance = google_sql_database_instance.cloudsql.name
}

resource "google_sql_user" "speaker" {
  instance = google_sql_database_instance.cloudsql.name
  name     = "dbt"
  password = var.cloudsql_password
}

resource "google_sql_database" "user_database" {
  count    = var.cloudsql_user_count
  name     = "dbt_${format("%02d", count.index + 1)}"
  instance = google_sql_database_instance.cloudsql.name
}
