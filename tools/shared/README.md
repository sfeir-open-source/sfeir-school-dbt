shared/

Guide Ressources Partagées

Ce guide présente les ressources communes à disposition des formateurs et des étudiants :

- Projets dbt templates pour démarrer rapidement un nouveau projet ou un exercice.
- Données CSV pour réaliser des tests et des démonstrations.
- Solutions des exercices pour vérifier vos travaux.

Pour utiliser un projet ou des données, copiez simplement le dossier correspondant dans votre espace de travail.

En cas de question, demandez conseil au formateur.
- Seeds de base

### demo/

Projet de démonstration complet pour le formateur.

Guide Ressources Partagées

Ce dossier contient toutes les ressources communes pour la formation DBT :

- **Projets DBT** :
  - `starter/` : projet vide pour démarrer un exercice ou un lab
  - `solutions/` : solutions complètes de tous les labs, organisées par module
  - `demo/` : projet de démonstration complet pour le formateur

- **Données** :
  - Seeds CSV et exemples pour les exercices

**Utilisation** :
Pour démarrer un lab, copiez le dossier `starter/` dans votre espace de travail. Pour vérifier vos travaux, consultez les dossiers `solutions/`. Les données sont prêtes à l’emploi dans le dossier `data/`.

En cas de question, demandez conseil au formateur.
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
