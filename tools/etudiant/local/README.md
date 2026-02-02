# 🖥️ Setup Local Étudiant

Environnement local avec PostgreSQL et dbt via Docker - **Pas de droits admin requis**.

## 🎯 Ce qui est inclus

- PostgreSQL 15 via Docker
- dbt-core avec adapter PostgreSQL
- Données de démo pré-chargées
- Configuration simplifiée

## 🚀 Installation

### Prérequis

- **Docker Desktop** (pas de droits admin requis pour l'utilisation)
- **Make** (déjà présent sur macOS/Linux)
- **Python 3.8+**

### Installer Docker Desktop (si nécessaire)

**Windows :**
- Téléchargez depuis : https://www.docker.com/products/docker-desktop
- Installez en mode utilisateur (pas besoin d'admin)

**macOS :**
```bash
brew install --cask docker
```

**Linux :**
```bash
# Ubuntu/Debian
sudo apt-get install docker.io docker-compose

# Ajouter votre user au groupe docker (pas besoin de sudo après)
sudo usermod -aG docker $USER
```

### Setup en une commande

**Linux/macOS :**
```bash
make setup
```

**Windows (Option 1 - Recommandé) :**
```cmd
scripts\setup.bat
```

**Windows (Option 2) :**
```powershell
.\scripts\setup.ps1
```

Cette commande va :
1. ✅ Vérifier les prérequis
2. ✅ Installer dbt
3. ✅ Démarrer PostgreSQL
4. ✅ Charger les données
5. ✅ Tester la connexion

## 📋 Commandes Disponibles

```bash
make setup       # Installation complète
make start       # Démarrer PostgreSQL
make stop        # Arrêter PostgreSQL
make restart     # Redémarrer
make test        # Tester dbt
make psql        # Se connecter à PostgreSQL
make clean       # Tout nettoyer
make help        # Afficher l'aide
```

## 🔧 Configuration

Les paramètres par défaut :

```env
Host:     localhost
Port:     5432
User:     student
Password: student123
Database: sfeir_dbt
```

## 🗂️ Travailler sur les Labs

### Démarrer un nouveau lab

```bash
# 1. Démarrer PostgreSQL
make start

# 2. Copier le projet starter
cp -r ../../shared/dbt-projects/starter ./lab-01

# 3. Aller dans le projet
cd lab-01

# 4. Tester la connexion
dbt debug

# 5. Charger les données
dbt seed

# 6. Exécuter les modèles
dbt run
```

### Structure d'un projet

```
lab-01/
├── dbt_project.yml       # Configuration du projet
├── models/               # Vos modèles SQL
│   └── ...
├── seeds/                # Données CSV
│   └── ...
└── tests/                # Tests
    └── ...
```

## 🧪 Tests

### Tester la connexion PostgreSQL

```bash
make psql
# ou
psql -h localhost -U student -d sfeir_dbt
```

### Tester dbt

```bash
make test
# ou
cd votre-projet
dbt debug
```

## 🐛 Troubleshooting

### Port 5432 déjà utilisé

Une autre instance PostgreSQL tourne peut-être.

```bash
# macOS/Linux : Trouver le processus
lsof -i :5432

# Windows : Trouver le processus
netstat -ano | findstr :5432

# Solution : Arrêter l'autre PostgreSQL ou changer le port
# Éditez .env et changez POSTGRES_PORT=5433
make restart
```

### Docker ne démarre pas

```bash
# Vérifier que Docker Desktop est lancé
docker --version
docker ps

# Sur Windows : Ouvrir Docker Desktop manuellement
# Sur macOS : Ouvrir Docker.app
```

### "Permission denied" sur Docker (Linux)

```bash
# Ajouter votre user au groupe docker
sudo usermod -aG docker $USER

# Se déconnecter/reconnecter
# ou
newgrp docker
```

### dbt ne trouve pas la base

```bash
# Vérifier que PostgreSQL est démarré
make start
docker ps

# Attendre quelques secondes et réessayer
make test
```

### Reset complet

Si rien ne fonctionne :

```bash
make clean
make setup
```

## 💡 Conseils Pratiques

### Garder PostgreSQL allumé pendant les labs

```bash
# En début de journée
make start

# Travailler toute la journée...

# En fin de journée
make stop
```

### Voir les logs PostgreSQL

```bash
docker logs -f sfeir-dbt-postgres-student
```

### Sauvegarder votre travail

Vos projets sont dans le dossier `local/`, ils ne sont pas affectés par `make clean`.

```bash
# Sauvegarder
cp -r ./mon-lab ./mon-lab-backup

# ou utiliser Git
cd ./mon-lab
git init
git add .
git commit -m "Travail du jour"
```

## 📊 Données Disponibles

Les seeds pré-chargées :

- **companies** : Liste d'entreprises
- **customers** : Clients
- **orders** : Commandes
- **categories** : Catégories de produits
- **countries** : Pays

### Ajouter plus de données

```bash
# Copier des seeds supplémentaires
cp ../../shared/data/seeds/*.csv ./mon-lab/seeds/

# Charger
cd mon-lab
dbt seed
```

## 🔐 Sécurité

⚠️ Ces credentials sont pour votre environnement local uniquement. Ils ne donnent accès qu'à votre machine.

## 🎓 Ressources d'Apprentissage

- [Documentation dbt](https://docs.getdbt.com/)
- [Jinja Templates](https://jinja.palletsprojects.com/)
- [SQL PostgreSQL](https://www.postgresql.org/docs/current/sql.html)

## 🆘 Support

Si vous bloquez :
1. Consultez la section Troubleshooting
2. Essayez `make clean && make setup`
3. Demandez au formateur
4. Vérifiez les logs : `docker logs sfeir-dbt-postgres-student`
