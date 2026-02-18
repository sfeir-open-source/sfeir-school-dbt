# 🎓 Guide d'Utilisation - SFEIR School DBT

## 🚀 Démarrage rapide

### 1. Ouvrir le terminal DBT

**Méthode 1 : Raccourci bureau**
- Double-cliquez sur **"SFEIR DBT Terminal"**

**Méthode 2 : Menu Démarrer**
- Menu Démarrer → "SFEIR School DBT" → "DBT Terminal"

**Méthode 3 : Manuel**
- Naviguez vers `C:\Users\VotreNom\Documents\sfeir-school-dbt\`
- Double-cliquez sur `scripts\dbt-shell.bat`

✅ Un terminal s'ouvre avec l'environnement dbt activé !

### 2. Naviguer vers un lab

```batch
# Aller dans le lab 01
dbt-lab1

# Aller dans le lab 02
dbt-lab2

# Aller dans votre espace perso
dbt-work
```

### 3. Exécuter les commandes dbt

```batch
# Charger les données CSV dans la base
dbt seed

# Exécuter les modèles (transformations)
dbt run

# Lancer les tests
dbt test

# Tout faire en une fois
dbt build
```

## 📁 Structure du workspace

```
workspace/
├── labs/                       # Labs de formation
│   ├── lab-01-models/         # Introduction aux modèles
│   │   ├── dbt_project.yml    # Configuration du projet
│   │   ├── models/            # Vos modèles SQL
│   │   ├── seeds/             # Données CSV
│   │   ├── tests/             # Tests personnalisés
│   │   └── sfeir_dbt.duckdb   # Base de données DuckDB
│   ├── lab-02-sources/
│   ├── lab-03-tests/
│   ├── lab-04-documentation/
│   └── lab-05-advanced/
├── my-work/                    # Votre espace personnel
└── backups/                    # Sauvegardes automatiques
```

## 🛠️ Commandes essentielles

### Commandes rapides (aliases)

Dans le terminal DBT, vous avez accès à des raccourcis :

| Commande | Description | Équivalent |
|----------|-------------|------------|
| `dbt-lab1` | Aller dans lab-01 | `cd workspace\labs\lab-01-models` |
| `dbt-lab2` | Aller dans lab-02 | `cd workspace\labs\lab-02-sources` |
| `dbt-lab3` | Aller dans lab-03 | `cd workspace\labs\lab-03-tests` |
| `dbt-lab4` | Aller dans lab-04 | `cd workspace\labs\lab-04-documentation` |
| `dbt-lab5` | Aller dans lab-05 | `cd workspace\labs\lab-05-advanced` |
| `dbt-work` | Aller dans my-work | `cd workspace\my-work` |
| `dbt-fresh` | Réinitialiser tout | `dbt clean && dbt deps && dbt seed && dbt run` |
| `dbt-backup` | Sauvegarder travail | Lance backup-work.bat |
| `dbt-explore` | Explorer la DB | Lance explore-db.bat |
| `ls` | Lister fichiers | `dir /b` |

### Commandes dbt standard

```batch
# Gestion des dépendances
dbt deps                       # Installer les packages

# Chargement de données
dbt seed                       # Charger tous les seeds
dbt seed --select customers    # Charger un seed spécifique
dbt seed --full-refresh        # Recharger en écrasant

# Exécution des modèles
dbt run                        # Exécuter tous les modèles
dbt run --select my_model      # Exécuter un modèle spécifique
dbt run --select +my_model     # Modèle + ses dépendances amont
dbt run --select my_model+     # Modèle + ses dépendances aval
dbt run --models staging.*     # Tous les modèles d'un dossier

# Tests
dbt test                       # Lancer tous les tests
dbt test --select my_model     # Tester un modèle
dbt test --select test_type:unique  # Type de test spécifique

# Build complet
dbt build                      # seed + run + test en une fois
dbt build --select my_model    # Build un modèle spécifique

# Documentation
dbt docs generate              # Générer la documentation
dbt docs serve                 # Servir la doc (http://localhost:8080)

# Debugging
dbt debug                      # Vérifier la configuration
dbt compile                    # Compiler sans exécuter
dbt show --select my_model     # Aperçu d'un modèle (affiche résultat)

# Nettoyage
dbt clean                      # Supprimer target/ et dbt_packages/
```

## 📝 Workflow typique d'un lab

### Exemple : Lab 01 - Modèles

```batch
# 1. Ouvrir le terminal DBT
#    (double-clic sur raccourci bureau)

# 2. Aller dans le lab
dbt-lab1

# 3. Charger les données initiales
dbt seed

# 4. Voir ce qui existe déjà
ls models

# 5. Éditer un modèle avec votre éditeur préféré
#    Par exemple : notepad models\staging\stg_customers.sql

# 6. Exécuter pour voir le résultat
dbt run --select stg_customers

# 7. Explorer la base pour voir les résultats
dbt-explore

# 8. Si OK, exécuter tout
dbt build

# 9. Voir la documentation
dbt docs generate
dbt docs serve
#    Ouvrir http://localhost:8080 dans votre navigateur

# 10. Sauvegarder votre travail
dbt-backup
```

## 💾 Persistance et sauvegarde

### Où sont mes données ?

**Bases de données DuckDB :**
Chaque lab a sa propre base de données :
```
lab-01-models\sfeir_dbt.duckdb
lab-02-sources\sfeir_dbt.duckdb
...
```

**Ces fichiers persistent entre les sessions !**
- Vous pouvez fermer le terminal
- Éteindre votre PC
- Vos données seront toujours là demain

### Sauvegarder mon travail

**Méthode 1 : Commande rapide**
```batch
dbt-backup
```

Crée une sauvegarde dans `workspace\backups\backup_YYYY-MM-DD_HHMM\`

**Méthode 2 : Script dédié**
```batch
# Depuis n'importe où
scripts\backup-work.bat
```

**Méthode 3 : Manuelle**
```batch
# Copier un lab spécifique
xcopy /E /I workspace\labs\lab-01-models backup\lab-01

# Copier tout le workspace
xcopy /E /I workspace backup\workspace
```

### Restaurer une sauvegarde

```batch
# 1. Aller dans les sauvegardes
cd workspace\backups

# 2. Lister les sauvegardes
dir

# 3. Copier la sauvegarde souhaitée
xcopy /E /I backup_2024-01-15_1430\labs\lab-01-models ..\labs\lab-01-models
```

## 🔄 Réinitialiser un lab

Si vous voulez recommencer un lab à zéro :

### Méthode 1 : Réinitialisation simple

```batch
# Aller dans le lab
dbt-lab1

# Nettoyer les artefacts
dbt clean

# Recharger les seeds
dbt seed --full-refresh

# C'est reparti !
dbt run
```

### Méthode 2 : Réinitialisation complète

```batch
# Aller dans le lab
cd workspace\labs\lab-01-models

# Supprimer la base de données
del sfeir_dbt.duckdb
del sfeir_dbt.duckdb.wal

# Supprimer les artefacts
rmdir /s /q target
rmdir /s /q dbt_packages

# Recharger
dbt seed
dbt run
```

### Méthode 3 : Copier depuis le template

```batch
# Sauvegarder votre travail d'abord
dbt-backup

# Supprimer le lab
rmdir /s /q workspace\labs\lab-01-models

# Réinstaller ? Contactez le formateur pour le template
```

## 🎨 Créer votre propre projet

### Dans my-work

```batch
# 1. Aller dans votre espace
dbt-work

# 2. Copier un lab comme template
xcopy /E /I ..\labs\lab-01-models mon-projet

# 3. Aller dans votre projet
cd mon-projet

# 4. Modifier le dbt_project.yml
notepad dbt_project.yml
#    Changer name: 'mon_projet'

# 5. Développer vos modèles
#    Créer ou modifier des fichiers dans models/

# 6. Tester
dbt run

# 7. Sauvegarder
dbt-backup
```

### Créer depuis zéro

```batch
# 1. Créer la structure
dbt-work
mkdir nouveau-projet
cd nouveau-projet

# 2. Initialiser un projet dbt
dbt init mon_projet --profiles-dir %USERPROFILE%\.dbt

# 3. Le projet est créé dans mon_projet/
cd mon_projet

# 4. Développer !
```

## 🔍 Explorer vos données

### Option 1 : Explorateur intégré

```batch
dbt-explore
```

Ou :
- Double-clic sur ***SFEIR DB Explorer** sur le bureau

**Fonctionnalités :**
- Liste toutes vos bases DuckDB
- Affiche les tables et schémas
- Aperçu des données
- Statistiques basiques

### Option 2 : SQL dans Python

Créez un fichier `query.py` :

```python
import duckdb

# Connexion à la base
conn = duckdb.connect('sfeir_dbt.duckdb', read_only=True)

# Requête simple
result = conn.execute("SELECT * FROM customers LIMIT 10").fetchdf()
print(result)

# Requête plus complexe
result = conn.execute("""
    SELECT 
        country,
        COUNT(*) as nb_customers,
        AVG(total_spent) as avg_spent
    FROM customers
    GROUP BY country
    ORDER BY nb_customers DESC
""").fetchdf()

print(result)

conn.close()
```

Puis :
```batch
python query.py
```

### Option 3 : DuckDB CLI

Si vous avez installé DuckDB CLI :

```batch
duckdb sfeir_dbt.duckdb
```

```sql
-- Dans le CLI
SHOW TABLES;
SELECT * FROM customers LIMIT 10;
.quit
```

### Option 4 : DBeaver

Voir [VISUALIZATION.md](VISUALIZATION.md)

## 🐛 Debugging

### Voir les logs

Les logs dbt sont dans :
```
target/dbt.log
logs/dbt.log
```

Pour voir les dernières erreurs :
```batch
type target\dbt.log | findstr /i "error"
```

### Compiler sans exécuter

```batch
dbt compile --select my_model
```

Le SQL compilé est dans `target/compiled/`

### Mode debug

```batch
dbt --debug run --select my_model
```

Affiche beaucoup plus d'informations !

### Tester la config

```batch
dbt debug
```

Vérifie :
- Connexion à la base
- Profil dbt
- Configuration du projet
- Versions des packages

## 📚 Cheat Sheet

### Sélecteurs dbt

```batch
# Modèle spécifique
--select my_model

# Dossier
--select staging.*
--select marts.finance.*

# Tag
--select tag:daily

# Graphe de dépendances
--select +my_model      # Modèle + upstream
--select my_model+      # Modèle + downstream
--select +my_model+     # Toute la chaîne

# Combinaisons
--select staging.* --exclude staging.excluded_model
```

### Matérialisations

Dans vos modèles SQL :

```sql
-- Vue (défaut)
{{ config(materialized='view') }}

-- Table
{{ config(materialized='table') }}

-- Incremental
{{ config(materialized='incremental') }}

-- Ephemeral (CTE réutilisable)
{{ config(materialized='ephemeral') }}
```

## 🆘 Problèmes courants

### "Relation does not exist"

**Cause :** Vous référencez une table qui n'existe pas

**Solution :**
```batch
# Charger les seeds d'abord
dbt seed

# Puis exécuter dans le bon ordre
dbt run
```

### "Compilation error"

**Cause :** Erreur de syntaxe SQL ou Jinja

**Solution :**
```batch
# Compiler pour voir l'erreur détaillée
dbt compile --select my_model

# Vérifier le SQL généré
type target\compiled\mon_projet\models\my_model.sql
```

### "Could not find profile"

**Cause :** profil dbt mal configuré

**Solution :**
```batch
# Vérifier le fichier profiles.yml
notepad %USERPROFILE%\.dbt\profiles.yml

# Vérifier le dbt_project.yml
notepad dbt_project.yml
```

Le `profile:` dans dbt_project.yml doit correspondre à un profil dans profiles.yml

### La base est verrouillée

**Cause :** Plusieurs processus accèdent à la même base

**Solution :**
- Fermez tous les terminaux DBT ouverts
- Fermez DBeaver/autres outils connectés à la base
- Supprimez le fichier `.wal` :
  ```batch
  del sfeir_dbt.duckdb.wal
  ```

## 📞 Support

**Ressources :**
- Documentation dbt : https://docs.getdbt.com
- DuckDB docs : https://duckdb.org/docs
- Guide visualisation : [VISUALIZATION.md](VISUALIZATION.md)

**Contact :**
- Votre formateur SFEIR
- Support technique SFEIR

---

**Bon apprentissage avec dbt ! 🚀**
