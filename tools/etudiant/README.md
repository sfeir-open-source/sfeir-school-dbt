# 🎒 Guide Étudiant - SFEIR School DBT

Bienvenue ! Ce guide vous permet de setup votre environnement DBT en quelques minutes.

## 🎯 Objectifs

En tant qu'étudiant, vous avez deux options :
- **Setup local** : Votre propre environnement PostgreSQL + dbt (recommandé)
- **Connection cloud** : Se connecter à la base de données du formateur

## 📂 Structure

```
etudiant/
├── local/     # Environnement local (PostgreSQL + dbt)
└── cloud/     # Connexion à l'environnement cloud du formateur
```

## 🚀 Setup Rapide

### Option 1 : Environnement Local (Recommandé)

Installez tout en local pour être autonome.

```bash
cd local
make setup
```

➡️ Voir le [Guide Local](./local/README.md) pour plus de détails

**Avantages :**
- ✅ Autonome (fonctionne hors ligne)
- ✅ Pas de dépendance au réseau
- ✅ Vous contrôlez tout
- ✅ Gratuit

**Prérequis :**
- Docker (pas de droits admin requis)
- Make
- Python 3.8+

### Option 2 : Connection Cloud

Connectez-vous à l'environnement partagé du formateur.

```bash
cd cloud
make connect
```

➡️ Voir le [Guide Cloud](./cloud/README.md) pour plus de détails

**Avantages :**
- ✅ Aucun setup local
- ✅ Même environnement pour tous
- ✅ Fourni par le formateur

**Prérequis :**
- Python 3.8+ et dbt
- Credentials fournis par le formateur

## 🗂️ Projets Disponibles

Tous les projets et exercices se trouvent dans `../shared/` :

- **Projets DBT** :
  - `starter/` : Projet vide pour commencer
  - `solutions/` : Solutions de tous les labs

- **Données** :
  - Seeds CSV pour les exercices

## 📝 Workflows Typiques

### Démarrer un lab

```bash
# 1. Setup local
cd local
make start

# 2. Copier le projet starter
cp -r ../shared/dbt-projects/starter ./mon-lab

# 3. Travailler
cd mon-lab
dbt run
dbt test
```

### Vérifier une solution

```bash
# Comparer avec la solution
cd ../shared/dbt-projects/solutions/module-XX
dbt run
```

## 🐛 Troubleshooting

### Docker ne démarre pas (Local)

```bash
# Vérifier Docker
docker --version
docker ps

# Redémarrer
cd local
make restart
```

### Connexion impossible (Cloud)

```bash
# Vérifier les credentials
cd cloud
cat profiles.yml

# Tester
dbt debug
```

### Python/dbt introuvable

```bash
# Installer dbt
pip install dbt-postgres==1.7.3

# Vérifier
dbt --version
```

## 💡 Conseils

1. **Préférez le setup local** si vous avez Docker
2. **Testez votre environnement** avant le début du cours
3. **Gardez les credentials cloud** en sécurité
4. **N'hésitez pas à demander de l'aide** au formateur

## 📚 Ressources

- [Documentation dbt](https://docs.getdbt.com/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

## 🆘 Support

En cas de problème :
1. Consultez les README spécifiques (local/cloud)
2. Vérifiez la section Troubleshooting
3. Demandez au formateur
