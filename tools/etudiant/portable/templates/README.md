# SFEIR School DBT - Guide de démarrage

## 🚀 Démarrage rapide

### Option 1 : Avec VSCode (recommandé)
1. Double-cliquez sur **"SFEIR DBT - VSCode"** sur le bureau
2. Le terminal s'ouvre automatiquement avec l'environnement configuré
3. Naviguez vers un lab :
   ```cmd
   cd workspace\labs\lab-01-models
   dbt seed
   dbt run
   ```

### Option 2 : Terminal seul
1. Double-cliquez sur **"SFEIR DBT Shell"** sur le bureau
2. Suivez les mêmes commandes ci-dessus

---

## � Reprendre le travail (jour suivant)

C'est très simple ! Double-cliquez sur l'un des raccourcis bureau :
- **"SFEIR DBT - VSCode"** → Ouvre VSCode avec tout configuré
- **"SFEIR DBT Shell"** → Ouvre le terminal seul

Votre travail est automatiquement sauvegardé :
- Les fichiers SQL que vous avez modifiés
- La base de données DuckDB avec vos données
- Vos fichiers dans `workspace/my-work/`

---

## 👀 Visualiser la base de données DuckDB

### Option 1 : Dans VSCode avec SQLTools (le plus simple)

1. **Installer les extensions recommandées** (proposé automatiquement à l'ouverture)
   - SQLTools
   - SQLTools DuckDB Driver

2. **Se connecter à la base** :
   - Cliquez sur l'icône SQLTools dans la barre latérale gauche (icône base de données)
   - Les connexions "Lab 01", "Lab 02", etc. sont déjà configurées
   - Cliquez sur une connexion pour vous connecter

3. **Explorer les données** :
   - Dépliez la connexion pour voir les tables
   - Clic droit sur une table → "Show Table Records"
   - Ou écrivez vos requêtes SQL dans un fichier `.sql`

> ⚠️ **Note** : La base doit exister (après `dbt seed` ou `dbt run`)

### Option 2 : Avec DBeaver (application externe)

1. **Téléchargez DBeaver** : https://dbeaver.io/download/
2. **Créez une nouvelle connexion** :
   - Type : **DuckDB**
   - Path : `C:\Users\[VOUS]\Documents\sfeir-school-dbt\workspace\labs\lab-01-models\sfeir_dbt.duckdb`

> ⚠️ **Important** : Fermez le terminal dbt avant d'ouvrir la base dans DBeaver

---

## � Structure des dossiers

```
sfeir-school-dbt/
├── workspace/
│   ├── labs/                    # Exercices de formation
│   │   ├── lab-01-models/       # Lab 1 : Introduction aux modèles
│   │   ├── lab-02-sources/      # Lab 2 : Sources et références  
│   │   ├── lab-03-tests/        # Lab 3 : Tests dbt
│   │   ├── lab-04-documentation/# Lab 4 : Documentation
│   │   └── lab-05-advanced/     # Lab 5 : Fonctionnalités avancées
│   └── my-work/                 # Votre espace personnel
└── README.md                    # Ce fichier
```

---

## 🔧 Commandes dbt

| Commande | Description |
|----------|-------------|
| `dbt seed` | Charge les données CSV dans la base |
| `dbt run` | Exécute tous les modèles SQL |
| `dbt test` | Lance les tests de données |
| `dbt build` | seed + run + test en une commande |
| `dbt compile` | Compile le SQL sans l'exécuter |
| `dbt docs generate` | Génère la documentation |
| `dbt docs serve` | Affiche la documentation dans le navigateur |

### Commandes avancées

```cmd
# Exécuter un seul modèle
dbt run --select mon_modele

# Exécuter un modèle et ses dépendances
dbt run --select +mon_modele

# Exécuter les tests d'un modèle
dbt test --select mon_modele
```

---

## �🐧 Alias Linux disponibles

Pour les utilisateurs habitués à Linux/Mac :

| Alias | Commande Windows |
|-------|------------------|
| `ls` | `dir /b` |
| `ll` | `dir` |
| `pwd` | `cd` |
| `cat` | `type` |
| `clear` | `cls` |

---

## ❓ Dépannage

### "dbt n'est pas reconnu"
→ Utilisez le raccourci **SFEIR DBT Shell** ou ouvrez un nouveau terminal dans VSCode

### "Database is locked"
→ Fermez DBeaver ou tout autre programme accédant au fichier `.duckdb`

### Réinitialiser un lab
```cmd
cd workspace\labs\lab-01-models
del sfeir_dbt.duckdb
dbt seed
dbt run
```

---

## 📚 Ressources

- [Documentation dbt](https://docs.getdbt.com/)
- [Documentation DuckDB](https://duckdb.org/docs/)
- [SFEIR School](https://www.sfeir.com/formation/)
