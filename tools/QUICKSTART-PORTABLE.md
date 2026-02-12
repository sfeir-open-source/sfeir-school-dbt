# SFEIR School DBT - Guide de Démarrage Rapide

## 🚀 Installation en 2 minutes (Mode Portable - Recommandé)

### Pour les étudiants

```bash
# 1. Cloner le repository
git clone [REPO_URL]
cd sfeir-school-dbt/tools/etudiant/portable

# 2. Installer (une seule commande)
make setup

# 3. C'est tout ! Vous êtes prêt
make test
```

### Pour les formateurs

```bash
cd tools/formateur/portable
make setup
make test
```

## 📋 Pourquoi le mode portable ?

- ✅ **Pas de Docker** - Fonctionne partout
- ✅ **Pas de droits admin** - Installation utilisateur simple
- ✅ **2 minutes chrono** - vs 30 minutes avec Docker
- ✅ **100% portable** - Copiable sur clé USB
- ✅ **Hors ligne** - Pas besoin d'internet après installation

## 🔄 Autres options disponibles

### Option locale (Docker + PostgreSQL)

Si vous avez Docker et voulez un environnement complet :

```bash
# Étudiant
cd tools/etudiant/local && make setup

# Formateur
cd tools/formateur/local && make setup
```

### Option cloud (GCP)

Si votre formateur a déployé une infrastructure cloud :

```bash
# Étudiant uniquement
cd tools/etudiant/cloud
# Suivre les instructions du formateur
```

## 📚 Guides complets

- **Étudiants** : [GUIDE-ETUDIANT.md](GUIDE-ETUDIANT.md)
- **Formateurs** : [GUIDE-FORMATEUR.md](GUIDE-FORMATEUR.md)
- **Détails mode portable** : 
  - Étudiant : [etudiant/portable/README.md](etudiant/portable/README.md)
  - Formateur : [formateur/portable/README.md](formateur/portable/README.md)

## 🆘 Problème ?

### Python n'est pas installé

**macOS :**
```bash
brew install python3
```

**Windows :**
Télécharger sur https://www.python.org/

### Commande 'make' non trouvée (Windows)

Utilisez les scripts alternatifs :
```batch
scripts\setup.bat
```

## ⚡ Commandes essentielles

```bash
make help          # Voir toutes les commandes
make test          # Tester dbt
make dbt-seed      # Charger les données
make dbt-run       # Exécuter les modèles
make dbt-shell     # Mode interactif
make clean         # Tout nettoyer
```

## 🎯 Premier lab

```bash
# 1. Charger les données
make dbt-seed

# 2. Exécuter les modèles
make dbt-run

# 3. Vérifier les résultats
cd ../../shared/dbt-projects/starter
python3 -c "import duckdb; conn = duckdb.connect('sfeir_dbt.duckdb'); print(conn.execute('SHOW TABLES').fetchall())"
```

Vous êtes prêt ! 🚀
