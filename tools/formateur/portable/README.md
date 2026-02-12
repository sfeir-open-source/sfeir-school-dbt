# Setup Formateur Portable - SFEIR School DBT

## 🎯 Pourquoi le mode portable ?

Cette version utilise **DuckDB**, une base de données embarquée qui ne nécessite :
- ✅ **Aucun Docker** - Installation en 2 minutes
- ✅ **Aucun droit administrateur** - Fonctionne partout
- ✅ **100% portable** - Tout tient dans un dossier
- ✅ **Compatible** - Syntaxe SQL proche de PostgreSQL

## 🚀 Installation rapide

### Option A : Vous avez Python installé (≥3.8)

#### Sur macOS / Linux
```bash
cd tools/formateur/portable
make setup
```

#### Sur Windows
```batch
cd tools\formateur\portable
scripts\setup.bat
```

Ou avec PowerShell :
```powershell
cd tools\formateur\portable
.\scripts\setup.ps1
```

### Option B : Vous n'avez RIEN installé (installation bootstrap)

**Télécharge automatiquement Python portable + tout le nécessaire sans droits admin !**

#### Sur macOS / Linux
```bash
cd tools/formateur/portable/scripts
./bootstrap.sh
```

#### Sur Windows
```batch
cd tools\formateur\portable\scripts
bootstrap.bat
```

Ou avec PowerShell :
```powershell
cd tools\formateur\portable\scripts
.\bootstrap.ps1
```

Le script bootstrap installe automatiquement :
- Python portable (dans le dossier projet)
- dbt + adaptateur DuckDB
- Configuration complète
- Données de test

**Tout reste local, aucune modification système !**

## 📋 Commandes disponibles

```bash
make help          # Afficher l'aide
make setup         # Installation complète (une seule fois)
make test          # Tester la connexion dbt
make dbt-seed      # Charger les données CSV
make dbt-run       # Exécuter les modèles dbt
make dbt-test      # Exécuter les tests
make dbt-build     # Tout faire : seed + run + test
make dbt-shell     # Mode interactif dbt
make clean         # Tout nettoyer et repartir de zéro
```

## 🎓 Utilisation pendant la formation

### 1. Préparer votre démonstration

```bash
cd tools/formateur/portable
make dbt-seed      # Charger les données
make dbt-run       # Exécuter les modèles
```

### 2. Mode interactif pour les démos live

```bash
make dbt-shell
# Vous êtes maintenant dans le projet avec dbt activé
dbt run --select my_model
dbt test
exit  # Pour quitter
```

### 3. Réinitialiser entre deux sessions

```bash
make clean
make setup
```

## 📊 Accéder aux données

La base de données est un fichier : `../../shared/dbt-projects/starter/sfeir_dbt.duckdb`

### Option 1 : Via Python

```python
import duckdb
conn = duckdb.connect('sfeir_dbt.duckdb')
conn.execute("SHOW TABLES").fetchall()
conn.execute("SELECT * FROM companies LIMIT 5").fetchdf()
```

### Option 2 : DuckDB CLI

Si vous avez installé DuckDB CLI séparément :
```bash
duckdb sfeir_dbt.duckdb
```

### Option 3 : DBeaver / DataGrip

Configurez une connexion DuckDB avec le chemin du fichier.

## 🔄 Différences avec PostgreSQL

DuckDB est **très compatible** avec PostgreSQL, mais quelques différences :

| Fonctionnalité | PostgreSQL | DuckDB |
|----------------|------------|---------|
| Types de données | ✅ | ✅ Quasi identiques |
| Window functions | ✅ | ✅ |
| CTEs | ✅ | ✅ |
| Schemas | ✅ Main schema | ✅ Un seul schema par défaut |
| Concurrent writes | ✅ | ⚠️ Un seul writer |

Pour 95% des exercices dbt, **aucune différence** n'est visible.

## 🆘 Dépannage

### Python n'est pas trouvé
```bash
# macOS avec Homebrew
brew install python3

# Windows
# Télécharger depuis python.org
```

### "Module duckdb not found"
```bash
source venv/bin/activate  # Activer le venv d'abord
pip install -r requirements.txt
```

### Réinitialiser complètement
```bash
make clean
rm -rf venv
make setup
```

## 📦 Partager votre environnement

Vous pouvez copier tout le dossier sur une clé USB :
```bash
# Copier votre environnement prêt à l'emploi
cp -r tools/formateur/portable /path/to/usb/
```

Le fichier `.duckdb` contient toutes les données, c'est totalement portable !

## 🎯 Avantages pour la formation

- 🚀 **Démarrage instantané** - Pas d'attente de containers
- 💻 **Fonctionne hors ligne** - Idéal en mobilité
- 🔒 **Isolation totale** - Chaque formateur a son propre fichier
- 🧹 **Nettoyage facile** - Supprimer le fichier .duckdb suffit
- 📦 **Sauvegarde simple** - Copier le fichier = backup complet
