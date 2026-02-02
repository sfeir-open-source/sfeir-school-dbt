# 🛠️ SFEIR School DBT - Setup Tools

Ce dossier contient tous les outils nécessaires pour mettre en place l'environnement de formation DBT en **une commande**.

## 📋 Structure

```
tools/
├── formateur/     # 🎓 Setup pour le formateur
├── etudiant/      # 🎒 Setup pour les étudiants
└── shared/        # 🔧 Ressources partagées (projets dbt, données)
```

## 🚀 Quick Start

### Pour le formateur

**Option 1 : Environnement local (Docker)**
```bash
cd formateur/local
make setup
```

**Option 2 : Environnement cloud (GCP)**
```bash
cd formateur/cloud
make deploy
```

### Pour les étudiants

**Option 1 : Environnement local (Docker)**
```bash
cd etudiant/local
make setup
```

**Option 2 : Connexion au cloud du formateur**
```bash
cd etudiant/cloud
make connect
```

## 🎯 Philosophie KISS (Keep It Simple, Stupid)

- **Une commande** pour démarrer
- **Un dossier** par rôle (formateur/étudiant)
- **Un sous-dossier** par environnement (local/cloud)
- **Un README** à chaque niveau qui explique tout
- **Support multi-plateforme** (Linux, macOS, Windows)

## 📚 Documentation

- [Guide Formateur](./formateur/README.md)
- [Guide Étudiant](./etudiant/README.md)

## ⚙️ Prérequis

### Formateur - Local
- Docker et Docker Compose
- Make

### Formateur - Cloud
- gcloud CLI
- Terraform
- Compte GCP avec permissions

### Étudiant - Local
- Docker et Docker Compose (pas de droits admin requis)
- Make
- Python 3.8+

### Étudiant - Cloud
- Python 3.8+
- Accès fourni par le formateur

## 🆘 Support

En cas de problème, consultez les README spécifiques à votre rôle et environnement.
