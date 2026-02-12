# Profils dbt supportés - SFEIR School DBT

Ce document liste tous les profils dbt disponibles pour le projet SFEIR School DBT.

## Configuration des profils

Les profils se configurent dans `~/.dbt/profiles.yml` (ou `%USERPROFILE%\.dbt\profiles.yml` sur Windows).

## Profils Formateur

### sfeir_trainer (Docker + PostgreSQL)

Environnement local complet avec Docker.

```yaml
sfeir_trainer:
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: dbt_trainer
      password: dbt_password
      dbname: sfeir_dbt
      schema: dbt_trainer
      threads: 4
  target: dev
```

**Usage :**
```bash
cd tools/formateur/local
make setup
```

### sfeir_trainer_portable (DuckDB) 🆕

Environnement portable sans Docker.

```yaml
sfeir_trainer_portable:
  outputs:
    dev:
      type: duckdb
      path: ./sfeir_dbt.duckdb
      threads: 4
      extensions:
        - httpfs
        - parquet
  target: dev
```

**Usage :**
```bash
cd tools/formateur/portable
make setup
```

## Profils Étudiant

### sfeir_student (Docker + PostgreSQL)

Environnement local avec Docker.

```yaml
sfeir_student:
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: student
      password: student123
      dbname: sfeir_dbt
      schema: student_dev
      threads: 4
  target: dev
```

**Usage :**
```bash
cd tools/etudiant/local
make setup
```

### sfeir_student_portable (DuckDB) 🆕

Environnement portable sans Docker.

```yaml
sfeir_student_portable:
  outputs:
    dev:
      type: duckdb
      path: ./sfeir_dbt.duckdb
      threads: 4
      extensions:
        - httpfs
        - parquet
  target: dev
```

**Usage :**
```bash
cd tools/etudiant/portable
make setup
```

### sfeir_student_cloud (PostgreSQL Cloud)

Connexion à l'environnement cloud déployé par le formateur.

```yaml
sfeir_student_cloud:
  outputs:
    dev:
      type: postgres
      host: <IP_FOURNIE_PAR_FORMATEUR>
      port: 5432
      user: dbt
      pass: <MOT_DE_PASSE_FOURNI>
      dbname: <NOM_BASE_FOURNIE>
      schema: public
      threads: 4
  target: dev
```

**Usage :**
Suivre les instructions du formateur dans le dossier `tools/etudiant/cloud/`.

## Changer de profil

### Méthode 1 : Modifier dbt_project.yml (recommandé)

Éditez `tools/shared/dbt-projects/starter/dbt_project.yml` :

```yaml
# Ligne 13
profile: 'sfeir_student_portable'  # Changez selon votre besoin
```

### Méthode 2 : Option en ligne de commande

```bash
dbt run --profile sfeir_student_portable
dbt seed --profile sfeir_trainer_portable
```

### Méthode 3 : Variable d'environnement

```bash
export DBT_PROFILE=sfeir_student_portable
dbt run
```

## Compatibilité des profils

| Profil | Base de données | Docker requis | Droits admin | Installation | Recommandé pour |
|--------|----------------|---------------|--------------|--------------|-----------------|
| sfeir_trainer | PostgreSQL | Oui | Oui | 10 min | Formateurs avec Docker |
| sfeir_trainer_portable | DuckDB | Non | Non | 2 min | Formateurs sans Docker |
| sfeir_student | PostgreSQL | Oui | Oui | 10 min | Étudiants avec Docker |
| sfeir_student_portable | DuckDB | Non | Non | 2 min | **Étudiants (défaut)** ✅ |
| sfeir_student_cloud | PostgreSQL | Non | Non | 2 min | Backup / Entreprise |

## Différences DuckDB vs PostgreSQL

Pour 95% des exercices de formation, **aucune différence**.

### Fonctionnalités identiques
- Types de données standard
- Window functions
- CTEs (WITH)
- JOINs complexes
- Macros dbt
- Tests et documentation

### Petites différences (rares)
- DuckDB : Un seul schema par défaut
- DuckDB : Une seule écriture à la fois (OK pour usage solo)
- Quelques fonctions spécifiques PostgreSQL différentes

**Tous les exercices de la formation sont testés avec les deux bases.**

## Support

- DuckDB : https://duckdb.org/docs/
- dbt-duckdb : https://github.com/duckdb/dbt-duckdb
- PostgreSQL : https://www.postgresql.org/docs/
- dbt-postgres : https://docs.getdbt.com/reference/warehouse-setups/postgres-setup
