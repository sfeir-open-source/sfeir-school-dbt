tools/

# SFEIR School DBT - Outils de Setup

Bienvenue dans le projet SFEIR School DBT. Ce dossier contient tous les outils nécessaires pour mettre en place votre environnement de formation DBT, que vous soyez formateur ou étudiant.

## Où aller maintenant ?

### Vous êtes formateur ?

Consultez le **[Guide Formateur](GUIDE-FORMATEUR.md)** pour découvrir comment préparer votre environnement de formation, déployer l'infrastructure cloud si nécessaire, et distribuer les accès à vos étudiants.

**Quick Start - Environnement local :**
```bash
cd formateur/local && make setup
```

### Vous êtes étudiant ?

Consultez le **[Guide Étudiant](GUIDE-ETUDIANT.md)** pour installer votre environnement de travail DBT et commencer les exercices de la formation.

**Quick Start - Installation locale :**
```bash
cd etudiant/local && make setup
```

## Structure du projet

```
tools/
├── GUIDE-FORMATEUR.md    → Guide complet pour les formateurs
├── GUIDE-ETUDIANT.md     → Guide complet pour les étudiants
├── formateur/            → Scripts et configuration formateur
├── etudiant/             → Scripts et configuration étudiant
└── shared/               → Projets DBT et données partagées
```

## Support

En cas de problème, consultez d'abord le guide correspondant à votre profil. Chaque guide contient une section dédiée à la résolution des problèmes courants.

Pour toute question supplémentaire, contactez l'équipe pédagogique SFEIR.
