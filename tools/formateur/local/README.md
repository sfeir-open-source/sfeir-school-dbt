# 🖥️ Setup Local Formateur

Environnement local complet avec PostgreSQL et dbt via Docker.

## 🎯 Ce qui est inclus

- PostgreSQL 15 avec données de démo
- dbt-core avec adapter PostgreSQL
- Projets dbt prêts à l'emploi
- Seeds et données de test

## 🚀 Installation

### Prérequis

- Docker et Docker Compose installés
- Make (déjà présent sur macOS/Linux, disponible via Chocolatey sur Windows)

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
2. ✅ Créer le fichier `.env` depuis `.env.example`
3. ✅ Démarrer PostgreSQL via Docker
4. ✅ Initialiser la base de données
5. ✅ Charger les seeds
6. ✅ Installer dbt localement
7. ✅ Tester la connexion

## 📋 Commandes Disponibles

```bash
make setup          # Installation complète (à faire une fois)
make start          # Démarrer les services
make stop           # Arrêter les services
make restart        # Redémarrer les services
make logs           # Voir les logs
make clean          # Nettoyer tout (DB + containers)
make test           # Tester la connexion dbt
make psql           # Se connecter à PostgreSQL
make dbt-run        # Exécuter les modèles dbt
make help           # Afficher l'aide
```

## 🔧 Configuration

Le fichier `.env` contient toutes les variables :

```env
# PostgreSQL
POSTGRES_USER=dbt_trainer
POSTGRES_PASSWORD=dbt_password
POSTGRES_DB=sfeir_dbt
POSTGRES_PORT=5432

# dbt
DBT_PROFILE=sfeir_trainer
DBT_TARGET=dev
```

## 🗂️ Structure des Données

La base de données contient :

- **companies** : Liste des entreprises
- **customers** : Clients
- **orders** : Commandes
- **categories** : Catégories de produits
- **countries** : Pays

## 📊 Projets dbt Disponibles

Trois projets sont disponibles dans `../../shared/dbt-projects/` :

1. **starter/** : Projet vide pour commencer
2. **demo/** : Projet de démonstration complet
3. **solutions/** : Solutions de tous les labs

### Utiliser un projet

```bash
# Copier le projet starter
cp -r ../../shared/dbt-projects/starter ./mon-projet
cd mon-projet

# Configurer profiles.yml (déjà configuré automatiquement)

# Tester
dbt debug
dbt run
```

## 🧪 Tests

### Tester la connexion PostgreSQL

```bash
make psql
```

Ou directement :
```bash
psql -h localhost -U dbt_trainer -d sfeir_dbt
```

### Tester dbt

```bash
make test
```

Ou directement :
```bash
cd ../../shared/dbt-projects/demo
dbt debug
dbt run
```

## 🐛 Troubleshooting

### Port 5432 déjà utilisé

```bash
# Trouver le processus
lsof -i :5432

# Changer le port dans .env
POSTGRES_PORT=5433

# Redémarrer
make restart
```

### Docker ne démarre pas

```bash
# Vérifier Docker
docker --version
docker ps

# Redémarrer Docker Desktop
# puis
make start
```

### dbt ne trouve pas la base

```bash
# Vérifier la connexion
make test

# Voir les logs PostgreSQL
make logs
```

### Reset complet

```bash
make clean
make setup
```

## 💡 Conseils

### Pour les démos live

```bash
# Terminal 1 : Logs en temps réel
make logs

# Terminal 2 : Commandes dbt
cd ../../shared/dbt-projects/demo
dbt run --models mon_modele
```

### Données de test supplémentaires

Les seeds supplémentaires sont dans `../../shared/data/seeds/`

```bash
# Copier dans votre projet
cp ../../shared/data/seeds/*.csv ./mon-projet/seeds/

# Charger
cd mon-projet
dbt seed
```

## 🔐 Sécurité

⚠️ **Important** : Ces credentials sont pour l'environnement local uniquement.
Ne les utilisez jamais en production !

## 📚 Ressources

- [Documentation dbt](https://docs.getdbt.com/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Docker Compose](https://docs.docker.com/compose/)

## 🆘 Support

Si vous rencontrez un problème :
1. Consultez la section Troubleshooting ci-dessus
2. Vérifiez les logs : `make logs`
3. Reset complet : `make clean && make setup`
