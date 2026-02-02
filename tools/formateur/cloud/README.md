# ☁️ Setup Cloud Formateur - GCP

Déploiement d'un environnement PostgreSQL sur Google Cloud Platform pour toute la classe.

## 🎯 Ce qui est inclus

- CloudSQL PostgreSQL 15
- Base de données par étudiant (configurable)
- Accès sécurisé via IP whitelisting
- Scripts de déploiement automatisés
- Génération des credentials pour les étudiants

## 🚀 Prérequis

- Compte Google Cloud Platform
- `gcloud` CLI installé et configuré
- Terraform >= 1.6
- Droits suffisants sur le projet GCP

## 📋 Installation

### 1. Configuration initiale

```bash
# Se connecter à GCP
gcloud auth login
gcloud auth application-default login

# Configurer le projet
gcloud config set project YOUR_PROJECT_ID
```

### 2. Configuration Terraform

Copiez le fichier de variables :
```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

Éditez `terraform/terraform.tfvars` :
```hcl
project_id          = "your-gcp-project"
region              = "europe-west1"
cloudsql_password   = "YOUR_SECURE_PASSWORD"
cloudsql_user_count = 20  # Nombre d'étudiants
```

### 3. Déploiement

```bash
make deploy
```

Cette commande va :
1. ✅ Initialiser Terraform
2. ✅ Créer l'instance CloudSQL
3. ✅ Créer les bases de données (1 par étudiant)
4. ✅ Configurer les accès réseau
5. ✅ Générer les fichiers de connexion

## 📋 Commandes Disponibles

```bash
make deploy              # Déployer l'infrastructure
make destroy             # Détruire l'infrastructure
make output              # Afficher les informations de connexion
make share-credentials   # Générer les fichiers pour les étudiants
make plan                # Voir les changements avant déploiement
make clean               # Nettoyer les fichiers temporaires
make help                # Afficher l'aide
```

## 🔧 Configuration

### Variables Terraform

```hcl
# terraform/terraform.tfvars
project_id          = "sfeir-school-dbt"      # Votre projet GCP
region              = "europe-west1"           # Région GCP
cloudsql_password   = "SuperSecurePass123!"   # Mot de passe DB
cloudsql_user_count = 20                      # Nombre d'étudiants
cloudsql_tier       = "db-f1-micro"          # Taille instance (ou db-g1-small)
```

### Coûts estimés

- **db-f1-micro** : ~7€/mois (0.0175€/heure) - Max 20 étudiants
- **db-g1-small** : ~25€/mois (0.025€/heure) - Max 50 étudiants

💡 **Conseil** : Détruisez l'infra après la formation pour éviter les coûts !

## 📊 Informations de Connexion

Après déploiement, récupérez les infos :

```bash
make output
```

Vous obtiendrez :
- IP publique de l'instance
- Nom de l'instance
- Nom des bases de données
- User et password

## 🎒 Distribution aux Étudiants

### Générer les fichiers de connexion

```bash
make share-credentials
```

Cela crée le dossier `credentials/` avec :
- `README.md` : Instructions pour les étudiants
- `profiles.yml` : Configuration dbt
- `connection-info.txt` : Informations de connexion

### Partager avec les étudiants

**Option 1 : ZIP**
```bash
cd credentials
zip -r sfeir-dbt-credentials.zip .
```

**Option 2 : Drive/Email**
Partagez le contenu du dossier `credentials/`

**Option 3 : GitHub private repo**
```bash
# Créer un repo privé et inviter les étudiants
git init credentials
cd credentials
git add .
git commit -m "Credentials DBT"
git push
```

## 🔐 Sécurité

### Bonnes pratiques

1. **Mot de passe fort** : Utilisez un générateur
2. **IP Whitelisting** : Par défaut ouvert à 0.0.0.0/0 (à restreindre)
3. **Rotation** : Changez le mot de passe après la formation
4. **Destruction** : `make destroy` après la formation

### Restreindre l'accès par IP

Éditez `terraform/main.tf` :
```hcl
authorized_networks {
  name  = "Office Network"
  value = "203.0.113.0/24"  # Votre réseau
}
```

## 🧪 Tests

### Tester la connexion depuis votre machine

```bash
# Installer psql si nécessaire
# macOS : brew install postgresql
# Linux : apt-get install postgresql-client

# Se connecter
psql "host=YOUR_IP port=5432 dbname=sfeir user=dbt password=YOUR_PASSWORD sslmode=require"
```

### Tester dbt

```bash
cd ../../shared/dbt-projects/demo
# Éditer profiles.yml avec les infos cloud
dbt debug
dbt run
```

## 🐛 Troubleshooting

### Erreur d'authentification Terraform

```bash
gcloud auth application-default login
```

### L'instance n'est pas accessible

1. Vérifiez que l'IP publique est activée
2. Vérifiez les authorized_networks
3. Attendez 5-10 minutes (démarrage lent)

### Quota dépassé

```bash
# Vérifier les quotas
gcloud compute project-info describe --project=YOUR_PROJECT

# Demander une augmentation dans la console GCP
```

### Coûts inattendus

```bash
# Vérifier les ressources actives
gcloud sql instances list

# Détruire immédiatement
make destroy
```

## 📈 Monitoring

### Voir les connexions actives

```bash
# Via gcloud
gcloud sql operations list --instance=sfeir-institute

# Via psql
psql ... -c "SELECT * FROM pg_stat_activity;"
```

### Logs

```bash
gcloud logging read "resource.type=cloudsql_database" --limit 50
```

## 🔄 Mise à jour

### Ajouter des étudiants

1. Modifier `terraform/terraform.tfvars` : augmenter `cloudsql_user_count`
2. `make plan` pour voir les changements
3. `make deploy` pour appliquer

### Changer la taille de l'instance

1. Modifier `terraform/terraform.tfvars` : changer `cloudsql_tier`
2. `make plan`
3. `make deploy`

## 💡 Conseils

### Avant la formation

1. **Déployez 24h avant** pour tester
2. **Testez la connexion** depuis plusieurs machines
3. **Chargez les seeds** à l'avance
4. **Partagez les credentials** en avance

### Pendant la formation

1. **Gardez `make output` à portée**
2. **Monitorer les connexions** si problèmes
3. **Backup** si manipulations importantes

### Après la formation

1. **Export des données** si besoin
2. **`make destroy`** dans les 24h
3. **Vérifiez la destruction** dans la console GCP

## 🆘 Support

En cas de problème :
1. Consultez la section Troubleshooting
2. Vérifiez les logs : `gcloud logging read ...`
3. Console GCP : https://console.cloud.google.com/sql

## 📚 Ressources

- [CloudSQL PostgreSQL](https://cloud.google.com/sql/docs/postgres)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [gcloud CLI](https://cloud.google.com/sdk/gcloud)
