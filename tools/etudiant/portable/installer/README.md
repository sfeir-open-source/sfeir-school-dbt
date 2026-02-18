# 🏗️ Build de l'Installateur SFEIR School DBT

Ce dossier contient les scripts et fichiers nécessaires pour construire l'installateur Windows portable.

## 📋 Prérequis

### Logiciels

1. **NSIS (Nullsoft Scriptable Install System)**
   - Site : https://nsis.sourceforge.io/Download
   - Installation via Chocolatey : `choco install nsis`
   - Ou télécharger l'installateur depuis le site officiel

2. **PowerShell** (inclus dans Windows)
   - Version 5.1 ou supérieure

3. **Connexion internet**
   - Pour télécharger Python portable
   - Pour télécharger les packages pip (dbt, duckdb, etc.)

### Structure requise

Assurez-vous que la structure du projet est complète :
```
sfeir-school-dbt/
└── tools/
    ├── shared/
    │   ├── dbt-projects/
    │   │   └── starter/        # Projet template pour les labs
    │   └── data/
    │       └── seeds/          # Seeds CSV
    └── etudiant/
        └── portable/           # Ce dossier
            ├── installer/      # Scripts de build
            ├── scripts/        # Scripts utilisateur
            ├── templates/      # Configs
            └── docs/           # Documentation
```

## 🚀 Build rapide

### Commande simple

```powershell
cd sfeir-school-dbt/tools/etudiant/portable/installer
.\build-installer.ps1
```

**Durée :** 5-10 minutes (selon votre connexion internet)

**Résultat :** `sfeir-dbt-installer.exe` (~50-80 MB)

### Options

```powershell
# Skip les téléchargements (si déjà effectués)
.\build-installer.ps1 -SkipDownload

# Mode verbose pour debugging
.\build-installer.ps1 -Verbose

# Combinaison
.\build-installer.ps1 -SkipDownload -Verbose
```

## 📦 Qu'est-ce qui est inclus dans l'installateur ?

### 1. Python Portable
- Version 3.11.9 embeddable
- ~16 MB
- Ne nécessite pas d'installation système
- Téléchargé depuis python.org

### 2. Packages Python
Tous les packages sont téléchargés en tant que "wheels" (.whl) et inclus :
- dbt-core (≥1.10.0)
- dbt-duckdb (≥1.10.0)
- Toutes les dépendances transitive
- tabulate (pour l'explorateur DB)

Total : ~30-40 MB

### 3. Workspace pré-configuré
- 5 labs avec le projet starter dbt
- Seeds CSV dans chaque lab
- README pour chaque lab
- Structure `my-work/` pour travail personnel
- Dossier `backups/` pour sauvegardes

### 4. Scripts utilisateur
- dbt-shell.bat (terminal interactif)
- explore-db.py (explorateur de base)
- backup-work.bat (sauvegarde)
- uninstall.bat (désinstallation)

### 5. Documentation
- INSTALLATION.md
- USAGE.md
- VISUALIZATION.md

## 🔍 Processus de build détaillé

### Étape 1 : Création de la structure
```
build/
├── python_portable/    # Python embeddable
├── wheels/            # Packages Python (.whl)
└── workspace/         # Labs pré-configurés
```

### Étape 2 : Téléchargement de Python
- URL : https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip
- Extraction dans `build/python_portable/`
- Configuration de `python311._pth` pour permettre pip

### Étape 3 : Installation de pip
- Téléchargement de get-pip.py
- Installation dans Python portable

### Étape 4 : Téléchargement des packages
- Création d'un venv temporaire
- `pip download` de tous les packages + dépendances
- Stockage dans `build/wheels/`

### Étape 5 : Préparation du workspace
- Copie du projet starter vers chaque lab
- Copie des seeds CSV
- Modification du `dbt_project.yml` (profil portable)
- Création des README

### Étape 6 : Compilation NSIS
- Exécution de `makensis installer.nsi`
- Inclusion de tous les fichiers de build/
- Création de l'installateur auto-extractible
- Génération du désinstallateur

## 🛠️ Personnalisation

### Changer la version de Python

Dans `build-installer.ps1` :
```powershell
$PYTHON_VERSION = "3.11.9"  # Changer ici
$PYTHON_URL = "https://www.python.org/ftp/python/$PYTHON_VERSION/python-$PYTHON_VERSION-embed-amd64.zip"
```

### Ajouter/Retirer des labs

Dans `build-installer.ps1` :
```powershell
$labs = @(
    "lab-01-models",
    "lab-02-sources",
    "lab-03-tests",
    "lab-04-documentation",
    "lab-05-advanced"
    # Ajouter ou retirer des labs ici
)
```

### Ajouter des packages Python

Dans `build-installer.ps1`, section téléchargement des wheels :
```powershell
& "$tempVenv\Scripts\pip.exe" download `
    dbt-core dbt-duckdb tabulate `
    nouvelle-dependance `
    --dest $WHEELS_DIR
```

### Personnaliser l'icône

Placez un fichier `icon.ico` dans `assets/` :
- Format : ICO Windows
- Résolution : 256x256 pixels recommandée
- Utilisé pour l'exe et les raccourcis

### Modifier l'installateur NSIS

Éditez `installer.nsi` :
- Nom du produit : `!define PRODUCT_NAME`
- Version : `!define PRODUCT_VERSION`
- Dossier d'installation : `InstallDir`
- Textes et messages : sections `MUI_WELCOMEPAGE_TEXT`, etc.

## 🐛 Dépannage

### "makensis n'est pas reconnu"

**Problème :** NSIS n'est pas dans le PATH

**Solution :**
```powershell
# Vérifier l'installation
Test-Path "C:\Program Files (x86)\NSIS\makensis.exe"

# Ou installer via Chocolatey
choco install nsis

# Ou ajouter au PATH temporairement
$env:Path += ";C:\Program Files (x86)\NSIS"
```

### Erreur de téléchargement Python

**Problème :** Connexion internet ou URL invalide

**Solution :**
- Vérifier votre connexion
- Vérifier que l'URL Python est valide
- Essayer de télécharger manuellement et placer dans `build/`

### Erreur de téléchargement des wheels

**Problème :** PyPI indisponible ou package introuvable

**Solution :**
```powershell
# Télécharger manuellement les wheels
pip download dbt-core dbt-duckdb -d wheels/

# Puis skip le téléchargement
.\build-installer.ps1 -SkipDownload
```

### L'installateur est trop gros (>100 MB)

**Causes possibles :**
- Trop de dépendances téléchargées
- Seeds CSV trop volumineux

**Solutions :**
- Nettoyer les wheels inutiles dans `build/wheels/`
- Réduire la taille des seeds CSV
- Utiliser `--no-deps` lors du téléchargement des wheels (puis ajouter manuellement les dépendances critiques)

### Erreur pendant la compilation NSIS

**Problème :** Fichiers manquants ou chemins incorrects

**Solution :**
- Vérifier que tous les fichiers existent dans `build/`
- Vérifier les chemins dans `installer.nsi`
- Compiler en mode verbose : `makensis /V4 installer.nsi`

## 📝 Checklist avant distribution

Avant de distribuer l'installateur aux étudiants :

- [ ] Tester l'installation sur une VM Windows propre
- [ ] Vérifier que l'installation fonctionne sans droits admin
- [ ] Tester tous les labs (seed + run)
- [ ] Vérifier le terminal DBT
- [ ] Tester l'explorateur de DB
- [ ] Vérifier la documentation (INSTALLATION.md, USAGE.md)
- [ ] Tester la désinstallation
- [ ] Vérifier la taille du fichier (<100 MB idéalement)
- [ ] Scanner avec l'antivirus
- [ ] Signer l'exécutable si possible (optionnel mais recommandé)

## 📤 Distribution

### Méthodes recommandées

1. **Google Drive / OneDrive**
   - Créer un lien de partage
   - Donner le lien aux étudiants
   - Avantage : Traçabilité des téléchargements

2. **Email**
   - Si < 25 MB (rare)
   - Compresser en ZIP si nécessaire

3. **Clé USB**
   - Idéal pour formations en présentiel
   - Copier l'exe sur chaque clé

4. **Serveur intranet**
   - Héberger sur l'intranet entreprise
   - Accessible depuis le réseau interne

5. **GitHub Releases**
   - Si le repo est public ou partagé
   - `gh release create v1.0.0 sfeir-dbt-installer.exe`

### Message type aux étudiants

```
Bonjour,

Pour préparer la formation DBT, veuillez installer l'environnement :

1. Téléchargez : [sfeir-dbt-installer.exe]
2. Double-cliquez sur le fichier téléchargé
3. Suivez l'assistant d'installation (2-3 minutes)

✅ Aucun droit administrateur requis
✅ Installation automatique

Des raccourcis seront créés sur votre bureau.

Pour toute question : [email du formateur]

À bientôt !
```

## 📊 Suivi des versions

### Historique

- **v1.0.0** (2024-02-18)
  - Version initiale
  - Python 3.11.9
  - dbt-core 1.10.0
  - 5 labs inclus

### Prochaines versions

Pour créer une nouvelle version :

1. Modifier `PRODUCT_VERSION` dans `installer.nsi`
2. Mettre à jour ce README avec les changements
3. Rebuild l'installateur
4. Tester sur VM propre
5. Distribuer avec un nouveau nom : `sfeir-dbt-installer-v1.1.0.exe`

## 📞 Support

**Questions sur le build :**
- Ouvrir une issue sur GitHub
- Ou contacter l'équipe SFEIR

**Documentation NSIS :**
- https://nsis.sourceforge.io/Docs/

**Documentation Python embeddable :**
- https://docs.python.org/3/using/windows.html#embedded-distribution
