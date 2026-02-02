# 🎯 Quick Start Guide - SFEIR School DBT

Guide ultra-rapide pour démarrer en 2 minutes.

## 👨‍🏫 Je suis FORMATEUR

### Option 1 : Local (Recommandé pour débuter)

**Linux/macOS :**
```bash
cd tools/formateur/local
make setup
```

**Windows :**
```cmd
cd tools\formateur\local
scripts\setup.bat
```

✅ C'est tout ! PostgreSQL + dbt sont installés et prêts.

**Tester :**
```bash
make psql    # Se connecter à PostgreSQL
make test    # Tester dbt
```

### Option 2 : Cloud (Pour formations avec beaucoup d'étudiants)

```bash
cd tools/formateur/cloud
# Configurer terraform.tfvars (copier depuis .example)
make deploy
make share-credentials
```

✅ Infrastructure GCP déployée, credentials générés pour les étudiants.
**Linux/macOS :**
```bash
cd tools/etudiant/local
make setup
```

**Windows :**
```cmd
cd tools\etudiant\local
scripts\setup.bat
## 🎒 Je suis ÉTUDIANT

### Option 1 : Local (Recommandé)

```bash
cd tools/etudiant/local
make setup
```

✅ C'est tout ! Vous avez votre propre environnement.

**Démarrer un lab :**
```bash
cp -r ../../shared/dbt-projects/starter ./mon-lab
cd mon-lab
dbt debug
dbt seed
dbt run
```

### Option 2 : Cloud (Avec credentials du formateur)

```bash
cd tools/etudiant/cloud
# Copier les credentials fournis par le formateur
cp ~/Downloads/profiles.yml ~/.dbt/
dbt debug
```

✅ Connecté à l'environnement partagé.

---

## 🚨 Problèmes ?

### Docker ne démarre pas
```bash
# Vérifier que Docker Desktop est lancé
docker --version
docker ps
```

### dbt introuvable
```bash
# Installer dbt
pip3 install dbt-postgres==1.7.3
```

### "Permission denied"
```bash
# Rendre les scripts exécutables
cd tools
chmod +x */*/scripts/*.sh
```

### Reset complet
```bash
# Dans le dossier où vous êtes
make clean
make setup
```

---

## 📚 Documentation Complète

- 📖 [README Principal](./README.md)
- 🎓 [Guide Formateur](./formateur/README.md)
- 🎒 [Guide Étudiant](./etudiant/README.md)
- 🔄 [Guide de Migration](./MIGRATION.md)

---

## 🎓 Ressources d'Apprentissage

- [Documentation dbt officielle](https://docs.getdbt.com/)
- [SQL Tutorial](https://www.postgresql.org/docs/current/tutorial.html)
- [Jinja Templates](https://jinja.palletsprojects.com/)

---

## 💡 Commandes Utiles

```bash
# PostgreSQL
make psql          # Se connecter
make logs          # Voir les logs
make restart       # Redémarrer

# dbt
dbt debug          # Tester la connexion
dbt seed           # Charger les données
dbt run            # Exécuter les modèles
dbt test           # Lancer les tests
dbt docs generate  # Générer la documentation
dbt docs serve     # Voir la documentation

# Nettoyage
make stop          # Arrêter les services
make clean         # Tout nettoyer
```

---

## 🎯 Objectif

**L'objectif de cette structure : passer le moins de temps possible sur le setup, et le maximum de temps sur l'apprentissage de dbt !**

🚀 Bonne formation !
