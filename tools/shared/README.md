# 🔧 Ressources Partagées - SFEIR School DBT

Projets dbt templates et données utilisés par formateurs et étudiants.

## 📂 Structure

```
shared/
├── dbt-projects/          # Projets dbt templates
│   ├── starter/           # Projet vide pour commencer
│   ├── demo/              # Projet de démonstration formateur
│   └── solutions/         # Solutions des labs par module
│       ├── module-03/
│       ├── module-04/
│       └── ...
│
└── data/                  # Données CSV
    ├── seeds/             # Seeds pour dbt
    └── samples/           # Données d'exemple supplémentaires
```

## 🎯 Projets DBT

### starter/

Projet vide prêt à l'emploi pour commencer un lab.

**Utilisation :**
```bash
# Formateur
cp -r shared/dbt-projects/starter ./formateur/local/mon-projet

# Étudiant
cp -r shared/dbt-projects/starter ./etudiant/local/mon-lab
```

**Contenu :**
- Structure de base dbt
- Configuration minimale
- Exemples commentés
- Seeds de base

### demo/

Projet de démonstration complet pour le formateur.

**Contenu :**
- Modèles de tous types (views, tables, incremental)
- Tests complets
- Documentation
- Macros utiles
- Seeds complets

**Utilisation :**
```bash
cd shared/dbt-projects/demo
dbt seed
dbt run
dbt test
dbt docs generate
```

### solutions/

Solutions complètes de tous les labs, organisées par module.

**Structure :**
```
solutions/
├── module-03/        # Models basiques
├── module-04/        # Materializations
├── module-05/        # Seeds
├── module-06/        # Sources et Refs
├── module-07/        # Historical data
├── module-08/        # Advanced features
├── module-09/        # Tests
├── module-10/        # Contracts
├── module-11/        # Documentation
└── module-12/        # Packages
```

**Utilisation :**
```bash
cd shared/dbt-projects/solutions/module-03
dbt run
```

## 📊 Données

### seeds/

Fichiers CSV utilisés comme données de base.

**Fichiers disponibles :**
- `companies.csv` : Liste des entreprises
- `customers.csv` : Clients
- `orders.csv` : Commandes
- `categories.csv` : Catégories de produits
- `countries.csv` : Pays

**Utilisation :**
```bash
# Dans un projet dbt
cp ../../shared/data/seeds/*.csv ./seeds/
dbt seed
```

### samples/

Données d'exemple supplémentaires pour tests avancés.

## 🚀 Démarrage Rapide

### Pour le formateur

```bash
# 1. Utiliser le projet demo
cd tools/formateur/local
make start

cd ../../shared/dbt-projects/demo
dbt seed
dbt run
dbt docs generate
dbt docs serve
```

### Pour l'étudiant

```bash
# 1. Setup local
cd tools/etudiant/local
make setup

# 2. Copier le starter
cp -r ../../shared/dbt-projects/starter ./mon-lab

# 3. Travailler
cd mon-lab
dbt seed
dbt run
```

## 📝 Ajouter une Nouvelle Solution

### Pour un nouveau module

```bash
# 1. Créer le dossier
mkdir shared/dbt-projects/solutions/module-XX

# 2. Copier le starter
cp -r shared/dbt-projects/starter/* shared/dbt-projects/solutions/module-XX/

# 3. Développer la solution
cd shared/dbt-projects/solutions/module-XX
# ... développer ...

# 4. Tester
dbt run
dbt test

# 5. Documenter
# Ajouter un README.md expliquant la solution
```

## 🔄 Mise à Jour des Projets

### Mettre à jour les seeds

```bash
# 1. Éditer les CSV dans shared/data/seeds/
vim shared/data/seeds/customers.csv

# 2. Recharger dans tous les projets
cd shared/dbt-projects/demo
dbt seed --full-refresh
```

### Mettre à jour le starter

```bash
# Modifier le projet starter
cd shared/dbt-projects/starter

# Les nouveaux projets utiliseront automatiquement la nouvelle version
```

## 💡 Bonnes Pratiques

### Nommage des fichiers

```
# Modèles
models/
  staging/
    stg_customers.sql
    stg_orders.sql
  mart/
    fct_sales.sql
    dim_customers.sql

# Tests
tests/
  test_revenue_positive.sql

# Seeds
seeds/
  seed_categories.csv
  seed_countries.csv
```

### Structure de projet recommandée

```
mon-projet/
├── dbt_project.yml
├── models/
│   ├── staging/       # Modèles de staging (sources nettoyées)
│   ├── intermediate/  # Modèles intermédiaires
│   └── mart/         # Modèles finaux (faits et dimensions)
├── tests/
├── macros/
├── seeds/
└── analyses/
```

## 🆘 Support

### Problèmes courants

**"Relation does not exist"**
```bash
# Charger les seeds d'abord
dbt seed
```

**"Compilation error"**
```bash
# Vérifier la syntaxe SQL et Jinja
dbt compile
```

## 📚 Ressources

- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
- [Style Guide](https://github.com/dbt-labs/corp/blob/main/dbt_style_guide.md)
- [Project Structure](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview)
