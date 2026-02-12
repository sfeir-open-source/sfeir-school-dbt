# Setup Étudiant Portable - SFEIR School DBT

## 🎯 C'est quoi le mode portable ?

Le mode portable utilise **DuckDB**, une base de données fichier ultra-légère :
- ✅ **Installation en 2 minutes** - Juste Python, pas de Docker
- ✅ **Aucun droit admin requis** - Fonctionne partout  
- ✅ **100% portable** - Tout tient dans un dossier, copiable sur clé USB
- ✅ **Compatible** - Même syntaxe SQL que PostgreSQL

Parfait si vous n'avez **pas de droits admin** ou **pas Docker** sur votre machine !

## 🚀 Installation ultra-rapide

### Option A : Vous avez Python installé (≥3.8)

#### Sur macOS / Linux
```bash
cd tools/etudiant/portable
make setup
```

#### Sur Windows (sans Make)
```batch
cd tools\etudiant\portable
scripts\setup.bat
```

Ou avec PowerShell :
```powershell
cd tools\etudiant\portable
.\scripts\setup.ps1
```

### Option B : Vous n'avez RIEN installé (zéro prérequis)

**Cette option télécharge automatiquement Python portable + dbt sans aucun droit admin !**

#### Sur macOS / Linux
```bash
cd tools/etudiant/portable/scripts
./bootstrap.sh
```

#### Sur Windows
```batch
cd tools\etudiant\portable\scripts
bootstrap.bat
```

Ou avec PowerShell :
```powershell
cd tools\etudiant\portable\scripts
.\bootstrap.ps1
```

Le script bootstrap :
1. Télécharge Python portable (aucune installation système)
2. Installe dbt et DuckDB localement
3. Configure automatiquement tout
4. Charge les données initiales
5. **Tout dans le dossier projet, rien dans le système !**

## 📋 Commandes pour travailler

```bash
make help          # Afficher l'aide complète
make test          # Tester que dbt fonctionne
make dbt-seed      # Charger les données CSV dans DuckDB
make dbt-run       # Exécuter vos modèles dbt
make dbt-test      # Lancer les tests
make dbt-build     # Tout faire d'un coup : seed + run + test
make dbt-shell     # Mode interactif pour utiliser dbt directement
make clean         # Tout supprimer et repartir de zéro
```

## 🎓 Utiliser pendant la formation

### 1. Premier démarrage

```bash
cd tools/etudiant/portable
make setup         # Installation (une seule fois)
make dbt-seed      # Charger les données
make dbt-run       # Exécuter les premiers modèles
```

### 2. Pendant les exercices

```bash
# Ouvrir le projet starter dans votre éditeur
cd ../../shared/dbt-projects/starter

# Modifier vos modèles SQL dans le dossier models/

# Tester vos changements
cd ../../../etudiant/portable
make dbt-run

# Ou en mode interactif
make dbt-shell
dbt run --select mon_modele
dbt test
exit
```

### 3. Voir vos données

Votre base de données est un fichier : `tools/shared/dbt-projects/starter/sfeir_dbt.duckdb`

**Avec Python (recommandé) :**
```python
import duckdb
conn = duckdb.connect('../../shared/dbt-projects/starter/sfeir_dbt.duckdb')

# Voir les tables
conn.execute("SHOW TABLES").fetchall()

# Requêter
conn.execute("SELECT * FROM companies LIMIT 5").fetchdf()
```

**Avec DuckDB CLI (si installé) :**
```bash
duckdb ../../shared/dbt-projects/starter/sfeir_dbt.duckdb
# Puis : SELECT * FROM companies;
```

## 🔄 Différences avec PostgreSQL

**Bonne nouvelle :** Pour 95% des exercices, **aucune différence** !

DuckDB supporte :
- ✅ Les mêmes types de données
- ✅ Les window functions
- ✅ Les CTEs (WITH)
- ✅ Les JOINs complexes
- ✅ Les macros dbt

Petites différences (rares) :
- ⚠️ Un seul schema par défaut (vs plusieurs dans Postgres)
- ⚠️ Une seule écriture à la fois (mais OK pour usage solo)

## 🆘 Problèmes courants

### "Python n'est pas trouvé"

**Sur macOS :**
```bash
brew install python3
# Ou télécharger sur python.org
```

**Sur Windows :**
Téléchargez sur https://www.python.org/ et cochez "Add to PATH"

### "Command not found: make" (Windows)

Utilisez plutôt les scripts :
```batch
scripts\setup.bat
```

Ou installez Make via Chocolatey :
```powershell
choco install make
```

### Réinitialiser complètement

```bash
make clean        # Tout supprimer
rm -rf venv       # Supprimer l'environnement Python
make setup        # Réinstaller
```

### "Module duckdb not found"

Activez d'abord l'environnement virtuel :
```bash
source venv/bin/activate  # macOS/Linux
# ou
venv\Scripts\activate.bat # Windows

pip install -r requirements.txt
```

## 💡 Astuces

### Travailler sur plusieurs labs

```bash
# Copier le projet starter pour chaque lab
cp -r tools/shared/dbt-projects/starter mon-lab-01
cd mon-lab-01

# Utiliser dbt directement
source ../../../etudiant/portable/venv/bin/activate
dbt run
```

### Sauvegarder votre travail

Votre base de données complète tient dans un fichier :
```bash
# Backup
cp sfeir_dbt.duckdb sfeir_dbt.duckdb.backup

# Ou copier sur clé USB
cp sfeir_dbt.duckdb /path/to/usb/
```

### Partager avec un collègue

Zipper et envoyer :
```bash
zip -r mon-projet.zip . -x "venv/*" "*.pyc"
```

Votre collègue dézippe et lance `make setup` !

## 🎯 Pourquoi DuckDB pour apprendre dbt ?

1. **Zéro friction** - Installation en 2 min vs 30 min avec Docker
2. **Fonctionne partout** - Même sur machines verrouillées
3. **Vraie base de données** - Pas un simulateur, c'est la vraie chose
4. **Utilisé en prod** - MotherDuck, Evidence, etc. utilisent DuckDB
5. **Portable** - Emmenez votre environnement partout

## 📚 Aller plus loin

- [Documentation DuckDB](https://duckdb.org/docs/)
- [Documentation dbt-duckdb](https://github.com/duckdb/dbt-duckdb)
- [Fonctions SQL DuckDB](https://duckdb.org/docs/sql/functions/overview)

## ✅ Checklist avant chaque session

- [ ] `make test` → Dbt fonctionne
- [ ] Base existe : `ls ../../shared/dbt-projects/starter/sfeir_dbt.duckdb`
- [ ] `make dbt-seed` si base vide
- [ ] Projet ouvert dans votre éditeur

Vous êtes prêt ! 🚀
