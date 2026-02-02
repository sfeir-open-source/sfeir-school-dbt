output "instance_connection_name" {
  description = "Nom de connexion de l'instance"
  value       = google_sql_database_instance.main.connection_name
}

output "instance_ip_address" {
  description = "Adresse IP publique de l'instance"
  value       = google_sql_database_instance.main.public_ip_address
}

output "database_name" {
  description = "Nom de la base de données principale"
  value       = google_sql_database.main.name
}

output "database_user" {
  description = "Utilisateur de la base de données"
  value       = google_sql_user.trainer.name
}

output "student_databases" {
  description = "Liste des bases de données étudiants"
  value       = google_sql_database.students[*].name
}

output "connection_string" {
  description = "Chaîne de connexion PostgreSQL"
  value       = "psql 'host=${google_sql_database_instance.main.public_ip_address} port=5432 dbname=${google_sql_database.main.name} user=${google_sql_user.trainer.name} sslmode=require'"
  sensitive   = false
}
