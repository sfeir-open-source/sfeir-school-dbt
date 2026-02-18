# 🔍 Guide de Visualisation des Données - SFEIR School DBT

## 📊 Pourquoi visualiser vos données ?

Pendant votre apprentissage de dbt, vous aurez besoin de :
- ✅ Vérifier que vos modèles génèrent les bonnes données
- ✅ Explorer la structure de vos tables
- ✅ Débugger les problèmes de données
- ✅ Comprendre l'impact de vos transformations

Ce guide présente **4 méthodes** pour visualiser vos bases DuckDB.

## 🎯 Méthode 1 : Explorateur DB Intégré (Recommandé)

### Avantages
- ✅ Déjà installé, aucune configuration
- ✅ Simple et rapide
- ✅ Pas besoin d'outil externe

### Utilisation

**Option A : Raccourci bureau**
- Double-cliquez sur **"SFEIR DB Explorer"**

**Option B : Terminal DBT**
```batch
dbt-explore
```

**Option C : Manuel**
```batch
cd C:\Users\VotreNom\Documents\sfeir-school-dbt
scripts\explore-db.bat
```

### Ce que vous verrez

```
╔═══════════════════════════════════════════════════╗
║     Explorateur de Base de Données DuckDB         ║
╚═══════════════════════════════════════════════════╝

📚 Bases de données disponibles:

   1. labs\lab-01-models\sfeir_dbt.duckdb (145.2 KB)
   2. labs\lab-02-sources\sfeir_dbt.duckdb (203.8 KB)
   3. labs\lab-03-tests\sfeir_dbt.duckdb (156.3 KB)
   ...

Choisissez une base (numéro) ou 'q' pour quitter : 1

🔍 Exploration de : labs\lab-01-models\sfeir_dbt.duckdb

📋 5 table(s) dans le schéma 'main':

===================================================================
📋 Table: customers
===================================================================
   📊 Nombre de lignes: 1,234

   📝 Colonnes:
   ┌─────────────┬─────────┬──────────┐
   │ Nom         │ Type    │ Contrainte│
   ├─────────────┼─────────┼──────────┤
   │ id          │ INTEGER │ NOT NULL │
   │ name        │ VARCHAR │ NULL     │
   │ email       │ VARCHAR │ NULL     │
   │ created_at  │ DATE    │ NULL     │
   └─────────────┴─────────┴──────────┘

   👀 Aperçu (5 premières lignes):
   ┌────┬────────────┬──────────────────┬────────────┐
   │ id │ name       │ email            │ created_at │
   ├────┼────────────┼──────────────────┼────────────┤
   │ 1  │ John Doe   │ john@example.com │ 2023-01-15 │
   ...
```

### Fonctionnalités

- 📊 Liste toutes les tables
- 📝 Affiche le schéma complet
- 👀 Aperçu des données (5 premières lignes)
- 📈 Statistiques sur les colonnes numériques
- 🔢 Compte distinct de valeurs

## 🐍 Méthode 2 : Python avec DuckDB

### Avantages
- ✅ Flexibilité maximale
- ✅ Peut faire des analyses complexes
- ✅ Peut exporter en CSV, Excel, etc.

### Installation

Déjà installé ! DuckDB est inclus dans l'environnement.

### Exemples de scripts

#### Script basique : Lister les tables

Créez `explore.py` dans votre lab :

```python
import duckdb

# Connexion à la base
conn = duckdb.connect('sfeir_dbt.duckdb', read_only=True)

# Lister les tables
print("📋 Tables disponibles:")
tables = conn.execute("SHOW TABLES").fetchall()
for table in tables:
    print(f"  - {table[0]}")

conn.close()
```

Exécutez :
```batch
python explore.py
```

#### Script : Explorer une table

```python
import duckdb
import sys

# Connexion
conn = duckdb.connect('sfeir_dbt.duckdb', read_only=True)

# Nom de la table (argument ou défaut)
table_name = sys.argv[1] if len(sys.argv) > 1 else 'customers'

print(f"\n📋 Exploration de la table : {table_name}\n")

# Schéma
print("📝 Schéma:")
schema = conn.execute(f"DESCRIBE {table_name}").fetchdf()
print(schema.to_string(index=False))

# Nombre de lignes
count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
print(f"\n📊 Nombre de lignes : {count:,}")

# Aperçu
print(f"\n👀 Aperçu (10 premières lignes):")
data = conn.execute(f"SELECT * FROM {table_name} LIMIT 10").fetchdf()
print(data.to_string(index=False))

conn.close()
```

Utilisez :
```batch
python explore.py customers
python explore.py orders
```

#### Script : Requêtes personnalisées

```python
import duckdb

conn = duckdb.connect('sfeir_dbt.duckdb', read_only=True)

# Exemple : Statistiques par pays
query = """
SELECT 
    country,
    COUNT(*) as nb_customers,
    AVG(total_spent) as avg_spent,
    MAX(total_spent) as max_spent
FROM customers
GROUP BY country
ORDER BY nb_customers DESC
LIMIT 10
"""

result = conn.execute(query).fetchdf()
print(result.to_string(index=False))

conn.close()
```

#### Script : Exporter en CSV

```python
import duckdb

conn = duckdb.connect('sfeir_dbt.duckdb', read_only=True)

# Requête
query = "SELECT * FROM customers WHERE country = 'France'"
result = conn.execute(query).fetchdf()

# Export CSV
result.to_csv('customers_france.csv', index=False)
print(f"✅ Exporté {len(result)} lignes vers customers_france.csv")

conn.close()
```

### Dans Jupyter Notebook (si installé)

```python
import duckdb
import pandas as pd

# Connexion
conn = duckdb.connect('sfeir_dbt.duckdb')

# Requête directement en DataFrame pandas
df = conn.execute("SELECT * FROM customers LIMIT 100").df()

# Affichage interactif
df.head()

# Visualisation
import matplotlib.pyplot as plt
df['country'].value_counts().plot(kind='bar')
plt.title('Customers by Country')
plt.show()
```

## 🗄️ Méthode 3 : DBeaver (Outil externe)

### Avantages
- ✅ Interface graphique professionnelle
- ✅ Éditeur SQL puissant
- ✅ Peut gérer plusieurs bases
- ✅ Export de données facile

### Installation

**DBeaver ne nécessite PAS de droits admin !**

1. **Télécharger DBeaver Community** :
   - https://dbeaver.io/download/
   - Choisir "Windows (zip archive)" pour version portable
   - Ou installer normalement si autorisé

2. **Extraire** (si version zip) :
   ```
   C:\Users\VotreNom\dbeaver\
   ```

3. **Lancer** :
   - `dbeaver\dbeaver.exe`

### Configuration DuckDB dans DBeaver

#### Étape 1 : Installer le driver DuckDB

1. Dans DBeaver : **Database** → **Driver Manager**
2. Cliquez **New**
3. Remplissez :
   - **Driver Name :** DuckDB
   - **Class Name :** `org.duckdb.DuckDBDriver`
   - **URL Template :** `jdbc:duckdb:{file}`
   - **Default Port :** (laisser vide)

4. **Onglet Libraries** :
   - Cliquez **Add Artifact**
   - Group Id : `org.duckdb`
   - Artifact Id : `duckdb_jdbc`
   - Version : (dernière, par exemple `0.9.2`)
   - Cliquez **Download/Update**

5. **OK**

#### Étape 2 : Créer une connexion

1. **Fichier** → **Nouvelle** → **Connexion à la base de données**
2. Cherchez "DuckDB" (si driver installé)
3. **Suivant**
4. Configuration :
   - **Path :** `C:\Users\VotreNom\Documents\sfeir-school-dbt\workspace\labs\lab-01-models\sfeir_dbt.duckdb`
   - **Connection type :** URL
   - **JDBC URL :** `jdbc:duckdb:C:/Users/VotreNom/Documents/sfeir-school-dbt/workspace/labs/lab-01-models/sfeir_dbt.duckdb`

5. **Test Connection**
6. **Terminer**

#### Import automatique des connexions

Un fichier template est fourni : `templates\dbeaver-template.json`

**Pour l'utiliser :**

1. Ouvrez `templates\dbeaver-template.json`
2. Remplacez `${INSTALL_DIR}` par votre chemin complet :
   ```
   C:\Users\VotreNom\Documents\sfeir-school-dbt
   ```
3. Sauvegardez le fichier
4. Dans DBeaver :
   - **Fichier** → **Importer**
   - **Connexions**
   - Sélectionnez votre fichier JSON modifié
   - **Terminer**

✅ Toutes les connexions aux labs sont créées automatiquement !

### Utilisation de DBeaver

**Explorer les données :**
1. Dans l'arbre à gauche : `DuckDB` → `sfeir_dbt` → `Tables`
2. Double-clic sur une table → Onglet "Data"
3. Vous voyez toutes les données !

**Exécuter du SQL :**
1. **SQL Editor** → **New SQL Script**
2. Tapez votre requête :
   ```sql
   SELECT * FROM customers WHERE country = 'France';
   ```
3. **Ctrl+Enter** pour exécuter

**Exporter des données :**
1. Clic droit sur résultat → **Export Data**
2. Choisissez format (CSV, Excel, JSON, etc.)

## 🎯 Méthode 4 : DuckDB CLI (Avancé)

### Installation

1. **Télécharger** : https://duckdb.org/docs/installation/
   - Version "Command Line" pour Windows
   - Fichier : `duckdb_cli-windows-amd64.zip`

2. **Extraire** :
   ```
   C:\Users\VotreNom\duckdb\duckdb.exe
   ```

3. **Ajouter au PATH** (optionnel) :
   - Copier vers `C:\Users\VotreNom\Documents\sfeir-school-dbt\`
   - Ou utiliser le chemin complet

### Utilisation

```batch
# Ouvrir une base
duckdb workspace\labs\lab-01-models\sfeir_dbt.duckdb

# Dans le CLI :
D SHOW TABLES;
D SELECT * FROM customers LIMIT 10;
D .quit
```

**Commandes utiles :**

```sql
-- Description
.tables                        -- Liste des tables
.schema customers              -- Schéma d'une table
.mode line                     -- Affichage ligne par ligne
.mode column                   -- Affichage en colonnes

-- Requêtes
SELECT COUNT(*) FROM customers;
DESCRIBE customers;
SHOW TABLES;

-- Export
.output result.csv
.mode csv
SELECT * FROM customers;
.output stdout

-- Quitter
.quit
```

## 📋 Comparaison des méthodes

| Méthode | Installation | Facilité | Puissance | Recommandé pour |
|---------|--------------|----------|-----------|-----------------|
| **Explorateur intégré** | ✅ Inclus | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | Visualisation rapide |
| **Python scripts** | ✅ Inclus | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Analyses complexes |
| **DBeaver** | ⚠️ À installer | ⭐⭐⭐ | ⭐⭐⭐⭐ | Exploration graphique |
| **DuckDB CLI** | ⚠️ À télécharger | ⭐⭐ | ⭐⭐⭐⭐ | Experts SQL |

## 💡 Conseils pratiques

### Pendant un lab

**Workflow recommandé :**

1. **Développez** vos modèles dbt
2. **Exécutez** avec `dbt run`
3. **Explorez rapidement** avec l'explorateur intégré :
   ```batch
   dbt-explore
   ```
4. **Analyses approfondies** avec un script Python si besoin

### Pour débugger

```batch
# 1. Voir le SQL compilé
dbt compile --select my_model
type target\compiled\mon_projet\models\my_model.sql

# 2. Tester le SQL directement en Python
import duckdb
conn = duckdb.connect('sfeir_dbt.duckdb')
result = conn.execute("""
    -- Coller votre SQL compilé ici
""").fetchdf()
print(result)
```

### Connexions multiples

**⚠️ Attention :** DuckDB ne supporte qu'**une écriture à la fois**

Si vous avez :
- Le terminal DBT ouvert (`dbt run` en cours)
- DBeaver connecté en écriture

Vous aurez une erreur de verrouillage.

**Solution :**
- Utilisez le mode **read-only** dans vos scripts :
  ```python
  conn = duckdb.connect('sfeir_dbt.duckdb', read_only=True)
  ```
- Ou fermez tous les outils avant d'exécuter dbt

## 🔗 Informations de connexion

### Pour DBeaver ou autres outils

**Type de base :** DuckDB

**Chemin des bases :**
```
Lab 01 : C:\Users\VotreNom\Documents\sfeir-school-dbt\workspace\labs\lab-01-models\sfeir_dbt.duckdb
Lab 02 : C:\Users\VotreNom\Documents\sfeir-school-dbt\workspace\labs\lab-02-sources\sfeir_dbt.duckdb
Lab 03 : C:\Users\VotreNom\Documents\sfeir-school-dbt\workspace\labs\lab-03-tests\sfeir_dbt.duckdb
Lab 04 : C:\Users\VotreNom\Documents\sfeir-school-dbt\workspace\labs\lab-04-documentation\sfeir_dbt.duckdb
Lab 05 : C:\Users\VotreNom\Documents\sfeir-school-dbt\workspace\labs\lab-05-advanced\sfeir_dbt.duckdb
My Work : C:\Users\VotreNom\Documents\sfeir-school-dbt\workspace\my-work\*.duckdb
```

**JDBC URL template :**
```
jdbc:duckdb:C:/Users/VotreNom/Documents/sfeir-school-dbt/workspace/labs/lab-01-models/sfeir_dbt.duckdb
```

**Driver JDBC :**
- Class : `org.duckdb.DuckDBDriver`
- Maven : `org.duckdb:duckdb_jdbc:0.9.2`

**Pas de serveur** : DuckDB est une base fichier, pas besoin de :
- ❌ Host / Port
- ❌ Username / Password
- ❌ Serveur en arrière-plan

## 🆘 Problèmes courants

### "Database is locked"

**Cause :** Plusieurs processus accèdent à la base en écriture

**Solution :**
```batch
# Fermer tous les terminaux DBT
# Fermer DBeaver
# Supprimer le fichier WAL
del workspace\labs\lab-01-models\sfeir_dbt.duckdb.wal
```

### "Could not find database file"

**Cause :** Base pas encore créée

**Solution :**
```batch
# Aller dans le lab
dbt-lab1

# Initialiser la base
dbt seed
dbt run
```

### DBeaver ne trouve pas le driver DuckDB

**Solution :**
1. Vérifiez votre connexion internet
2. Database → Driver Manager → DuckDB
3. Onglet Libraries → Download/Update
4. Ou téléchargez manuellement le JAR depuis Maven Central

### L'explorateur intégré ne montre rien

**Cause :** Aucune base créée

**Solution :**
```batch
# Dans chaque lab, lancez au moins une fois :
dbt-lab1
dbt seed
```

## 📚 Ressources

**Documentation :**
- DuckDB : https://duckdb.org/docs/
- DBeaver : https://dbeaver.com/docs/
- Python DuckDB : https://duckdb.org/docs/api/python

**Tutoriels :**
- DuckDB SQL : https://duckdb.org/docs/sql/introduction
- dbt docs : https://docs.getdbt.com/

---

**Vous savez maintenant visualiser vos données ! 🎉**

Pour toute question, consultez [USAGE.md](USAGE.md) ou contactez votre formateur.
