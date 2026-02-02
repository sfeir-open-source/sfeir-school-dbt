# 🚀 SFEIR School DBT - Projet Starter

Projet dbt vide prêt à l'emploi pour commencer les labs.

## 📋 Contenu

Ce projet contient :
- ✅ Structure de base dbt
- ✅ Configuration minimale
- ✅ Seeds d'exemple
- ✅ Modèles d'exemple commentés

## 🎯 Utilisation

### 1. Copier le projet

```bash
# Depuis le dossier formateur/local ou etudiant/local
cp -r ../../shared/dbt-projects/starter ./mon-lab
cd mon-lab
```

### 2. Tester la connexion

```bash
dbt debug
```

### 3. Charger les seeds

```bash
dbt seed
```

### 4. Exécuter les modèles

```bash
dbt run
```

### 5. Lancer les tests

```bash
dbt test
```

## 📂 Structure

```
starter/
├── dbt_project.yml       # Configuration du projet
├── models/
│   ├── example/          # Modèles d'exemple
│   │   ├── schema.yml    # Documentation et tests
│   │   └── my_first_model.sql
│   └── staging/          # Dossier pour vos modèles staging
├── seeds/
│   └── (vide - à remplir avec vos CSV)
├── tests/
│   └── (vide - à remplir avec vos tests custom)
├── macros/
│   └── (vide - à remplir avec vos macros)
└── analyses/
    └── (vide - à remplir avec vos analyses)
```

## 💡 Prochaines Étapes

1. **Supprimer les exemples** (optionnel)
   ```bash
   rm -rf models/example
   ```

2. **Créer vos premiers modèles**
   ```bash
   mkdir -p models/staging
   # Créer models/staging/stg_customers.sql
   ```

3. **Ajouter des seeds**
   ```bash
   cp ../../shared/data/seeds/*.csv ./seeds/
   dbt seed
   ```

4. **Documenter vos modèles**
   ```bash
   # Créer models/schema.yml
   dbt docs generate
   dbt docs serve
   ```

## 🧪 Workflow Typique

```bash
# 1. Développer un modèle
vim models/staging/stg_customers.sql

# 2. Exécuter
dbt run --select stg_customers

# 3. Tester
dbt test --select stg_customers

# 4. Documenter
# Ajouter dans schema.yml

# 5. Générer la doc
dbt docs generate
```

## 📚 Ressources

- [dbt Documentation](https://docs.getdbt.com/)
- [SQL Jinja](https://docs.getdbt.com/docs/build/jinja-macros)
- [Best Practices](https://docs.getdbt.com/guides/best-practices)
