tools/

# SFEIR School DBT - Outils de Setup

Bienvenue dans le projet SFEIR School DBT. Ce dossier contient tous les outils nécessaires pour mettre en place votre environnement de formation DBT, que vous soyez formateur ou étudiant.

## Où aller maintenant ?

### Vous êtes formateur ?

Consultez le **[Guide Formateur](GUIDE-FORMATEUR.md)** pour découvrir comment préparer votre environnement de formation, déployer l'infrastructure cloud si nécessaire, et distribuer les accès à vos étudiants.

**Quick Start - Environnement local (Docker) :**
```bash
cd formateur/local && make setup
```

**Quick Start - Environnement portable (sans Docker) 🆕 :**
```bash
cd formateur/portable && make setup
```

### Vous êtes étudiant ?

Consultez le **[Guide Étudiant](GUIDE-ETUDIANT.md)** pour installer votre environnement de travail DBT et commencer les exercices de la formation.

**Quick Start - Installation locale (Docker) :**
```bash
cd etudiant/local && make setup
```

**Quick Start - Installation portable (sans Docker) 🆕 :**
```bash
cd etudiant/portable && make setup
```

## Quelle option choisir ?

| Option | Avantages | Prérequis | Temps d'installation |
|--------|-----------|-----------|---------------------|
| **Portable** 🆕 | Pas de droits admin, installation rapide, 100% portable | Python 3.8+ | 2 minutes |
| **Local** | Environnement complet PostgreSQL, proche de la production | Docker + droits admin | 5-10 minutes |
| **Cloud** | Aucune installation locale, accès depuis n'importe où | Internet stable | 2 minutes |

**Recommandation :**
- ✅ **Portable** si vous n'avez pas Docker ou droits admin
- ✅ **Local** si vous avez Docker et voulez un environnement complet
- ✅ **Cloud** comme backup ou pour formations en entreprise

## Structure du projet

```
tools/
├── GUIDE-FORMATEUR.md    → Guide complet pour les formateurs
├── GUIDE-ETUDIANT.md     → Guide complet pour les étudiants
├── formateur/            → Scripts et configuration formateur
│   ├── local/            → Setup avec Docker + PostgreSQL
│   ├── portable/         → Setup portable avec DuckDB 🆕
│   └── cloud/            → Déploiement infrastructure GCP
├── etudiant/             → Scripts et configuration étudiant
│   ├── local/            → Setup avec Docker + PostgreSQL
│   ├── portable/         → Setup portable avec DuckDB 🆕
│   └── cloud/            → Configuration connexion GCP
└── shared/               → Projets DBT et données partagées
```

## Support

En cas de problème, consultez d'abord le guide correspondant à votre profil. Chaque guide contient une section dédiée à la résolution des problèmes courants.

Pour toute question supplémentaire, contactez l'équipe pédagogique SFEIR.
