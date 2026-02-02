# 🎓 Guide Formateur - SFEIR School DBT

Bienvenue ! Ce guide vous permet de setup l'environnement de formation en quelques minutes.

## 🎯 Objectifs

En tant que formateur, vous pouvez :
- **Démarrer un environnement local** avec PostgreSQL et dbt via Docker
- **Déployer un environnement cloud** sur GCP pour tous les étudiants
- **Accéder aux projets de démonstration et solutions** complètes

## 📂 Structure

```
formateur/
├── local/     # Environnement local (PostgreSQL + dbt)
└── cloud/     # Environnement cloud (GCP CloudSQL)
```

## 🚀 Setup Rapide

### Option 1 : Environnement Local (Recommandé pour débuter)

Parfait pour les démos et tests en local.

```bash
cd local
make setup
```

➡️ Voir le [Guide Local](./local/README.md) pour plus de détails

**Avantages :**
- ✅ Pas de coût
- ✅ Fonctionne hors ligne
- ✅ Contrôle total
- ✅ Parfait pour la préparation

### Option 2 : Environnement Cloud (Pour formations avec beaucoup d'étudiants)

Déploie une base PostgreSQL sur GCP accessible par tous les étudiants.

```bash
cd cloud
make deploy
```

➡️ Voir le [Guide Cloud](./cloud/README.md) pour plus de détails

**Avantages :**
- ✅ Un seul environnement pour tous
- ✅ Pas de setup pour les étudiants
- ✅ Facile à gérer
- ⚠️ Nécessite un compte GCP

## 🗂️ Ressources Disponibles

Tous les projets et données se trouvent dans `../shared/` :

- **Projets DBT** :
  - `starter/` : Projet vide pour commencer
  - `solutions/` : Solutions de tous les labs
  - `demo/` : Projet de démonstration complet

- **Données** :
  - Seeds CSV pour les exercices
  - Samples de données

## 📝 Workflows Typiques

### Préparation de la formation

1. **Local** : Tester les labs
   ```bash
   cd local
   make setup
   make test
   ```

2. **Cloud** : Déployer pour les étudiants (J-1)
   ```bash
   cd cloud
   make deploy
   make share-credentials  # Génère les infos de connexion
   ```

### Pendant la formation

- **Local** : Pour les démos live
- **Cloud** : Les étudiants se connectent

### Après la formation

```bash
cd cloud
make destroy  # Détruit l'infra pour éviter les coûts
```

## 🆘 Problèmes Courants

### Docker ne démarre pas (Local)
```bash
# Vérifier Docker
docker --version
docker-compose --version

# Relancer
make restart
```

### Erreur Terraform (Cloud)
```bash
# Réinitialiser
cd cloud
make clean
make deploy
```

## 💡 Conseils

1. **Testez toujours en local avant** la formation
2. **Déployez le cloud la veille** pour vérifier
3. **Gardez les credentials** dans un endroit sûr
4. **N'oubliez pas de détruire** l'infra après

## 📞 Support

Pour toute question, consultez les README spécifiques :
- [Local](./local/README.md)
- [Cloud](./cloud/README.md)
