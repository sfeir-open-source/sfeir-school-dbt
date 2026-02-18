# 📦 SFEIR School DBT - Version Portable Windows

## 🎯 Vue d'ensemble

Cette version portable permet aux étudiants d'installer et utiliser dbt **sans droits administrateur** et **sans Docker**. Tout est contenu dans un seul exécutable auto-installable.

## ✨ Caractéristiques

- ✅ **Aucun droit admin requis** - Installation utilisateur uniquement
- ✅ **Pas de Docker** - Utilise DuckDB (base de données fichier)
- ✅ **Installation en 1 clic** - Un seul exécutable `.exe`
- ✅ **100% portable** - Peut être copié sur clé USB
- ✅ **Persistance des données** - Le travail est sauvegardé entre les sessions
- ✅ **Désinstallation propre** - Peut tout supprimer facilement
- ✅ **Terminal interactif** - Toutes les commandes dbt disponibles
- ✅ **Explorateur de DB** - Visualisation des données intégrée

## 📁 Structure du projet

```
portable/
├── installer/                  # 🏗️ Construction de l'installateur
│   ├── installer.nsi          # Script NSIS pour créer l'exe
│   ├── build-installer.ps1    # Script de build automatique
│   └── assets/
│       └── icon.ico           # Icône de l'application
├── scripts/                    # 📜 Scripts utilisateur
│   ├── dbt-shell.bat          # Terminal DBT interactif
│   ├── explore-db.py          # Explorateur de base de données
│   ├── explore-db.bat         # Wrapper pour l'explorateur
│   ├── backup-work.bat        # Sauvegarde du travail
│   └── uninstall.bat          # Désinstallation manuelle
├── templates/                  # 📋 Templates de configuration
│   ├── profiles.yml           # Configuration dbt
│   └── dbeaver-template.json  # Template connexions DBeaver
├── docs/                       # 📚 Documentation utilisateur
│   ├── INSTALLATION.md        # Guide d'installation
│   ├── USAGE.md               # Guide d'utilisation
│   └── VISUALIZATION.md       # Guide visualisation des données
├── requirements.txt            # Dépendances Python
└── README.md                   # Ce fichier
```

## 👨‍🎓 Pour les étudiants

### Installation

Vous avez reçu le fichier `sfeir-dbt-installer.exe`. C'est tout ce dont vous avez besoin !

1. **Double-cliquez** sur l'installateur
2. **Suivez** l'assistant (2-3 minutes)
3. **C'est prêt !** Des raccourcis sont créés sur votre bureau

### Utilisation

**Ouvrez "SFEIR DBT Terminal"** (raccourci bureau) puis :

```batch
# Aller dans un lab
dbt-lab1

# Charger les données
dbt seed

# Exécuter les modèles
dbt run

# Explorer la base
dbt-explore
```

### Documentation complète

📖 Lisez la documentation dans `docs/` :
- [INSTALLATION.md](docs/INSTALLATION.md) - Guide d'installation détaillé
- [USAGE.md](docs/USAGE.md) - Comment utiliser dbt au quotidien
- [VISUALIZATION.md](docs/VISUALIZATION.md) - Visualiser vos données

## 👨‍🏫 Pour les formateurs

### Construire l'installateur

#### Prérequis

- **Windows** (pour compiler avec NSIS)
- **NSIS** installé : https://nsis.sourceforge.io/Download
  ```powershell
  # Avec Chocolatey
  choco install nsis
  ```
- **PowerShell** (généralement déjà installé)
- **Connexion internet** (pour télécharger Python et les packages)

#### Build de l'installateur

```powershell
# 1. Aller dans le dossier installer
cd tools/etudiant/portable/installer

# 2. Lancer le script de build
.\build-installer.ps1

# 3. Attendre 5-10 minutes
#    Le script va :
#    - Télécharger Python portable
#    - Télécharger tous les packages Python (dbt, duckdb, etc.)
#    - Préparer les labs avec les données
#    - Compiler l'installateur NSIS

# 4. Résultat
#    Fichier créé : sfeir-dbt-installer.exe (~50-80 MB)
```

#### Options avancées

```powershell
# Skip les téléchargements (si déjà fait)
.\build-installer.ps1 -SkipDownload

# Mode verbose pour debugging
.\build-installer.ps1 -Verbose
```

### Distribuer l'installateur

**L'exécutable `sfeir-dbt-installer.exe` peut être distribué par :**

1. **Email** (si < 25 MB après compression)
2. **Google Drive / OneDrive / Dropbox**
3. **Clé USB** (idéal pour formations en présentiel)
4. **Serveur intranet** entreprise
5. **GitHub Releases** (si le repo est public/privé avec accès)

**Instructions à donner aux étudiants :**
> "Téléchargez le fichier `sfeir-dbt-installer.exe` et double-cliquez dessus. L'installation est automatique et ne nécessite aucun droit administrateur."

### Customisation

#### Changer les labs inclus

Éditez `build-installer.ps1` :

```powershell
$labs = @(
    "lab-01-models",
    "lab-02-sources",
    # Ajoutez ou enlevez des labs ici
)
```

#### Changer la version de Python

Éditez `build-installer.ps1` :

```powershell
$PYTHON_VERSION = "3.12.0"  # Ou autre version
```

#### Ajouter des packages Python

Éditez `build-installer.ps1` :

```powershell
& "$tempVenv\Scripts\pip.exe" download `
    dbt-core dbt-duckdb tabulate `
    votre-package-supplementaire `
    --dest $WHEELS_DIR
```

## 🔍 Architecture technique

### Ce qui est installé

**Sur la machine de l'étudiant :**
```
C:\Users\[Nom]\Documents\sfeir-school-dbt\
├── python_portable\        # Python 3.11 embeddable (~16 MB)
├── venv\                   # Environnement virtuel Python
│   └── Scripts\
│       ├── dbt.exe        # Commande dbt
│       └── python.exe     # Python du venv
├── workspace\              # Zone de travail de l'étudiant
│   ├── labs\              # 5 labs pré-configurés
│   │   ├── lab-01-models\
│   │   │   ├── models\    # Modèles SQL
│   │   │   ├── seeds\     # Données CSV
│   │   │   └── sfeir_dbt.duckdb  # Base DuckDB
│   │   └── ...
│   ├── my-work\           # Espace personnel
│   └── backups\           # Sauvegardes auto
└── scripts\               # Utilitaires
```

**Configuration dbt :**
```
C:\Users\[Nom]\.dbt\profiles.yml
```

### Fonctionnement

1. **Python portable** : Version embeddable qui n'installe rien dans le système
2. **DuckDB** : Base de données fichier (pas de serveur)
3. **Venv** : Environnement Python isolé
4. **Profiles.yml** : Configure dbt pour utiliser DuckDB

### Pas de droits admin nécessaires car :

- ✅ Installation dans `Documents/` (espace utilisateur)
- ✅ Python embeddable (pas d'installation système)
- ✅ Pas de service Windows
- ✅ Pas de modification du registre système (sauf user)
- ✅ Pas de fichiers dans `Program Files/`

## ✅ Validation de la solution

### ✅ Persistance du travail

**Question :** Les étudiants peuvent-ils fermer et reprendre le lendemain ?

**Réponse :** **OUI**
- Les bases DuckDB sont des fichiers (`.duckdb`)
- Les modèles SQL sont des fichiers (`.sql`)
- Tout persiste entre les sessions
- Chaque lab a sa propre base indépendante

### ✅ Purge de l'installation

**Question :** Peut-on facilement tout supprimer ?

**Réponse :** **OUI**
- Désinstallateur intégré (via Panneau de configuration)
- Script `uninstall.bat` manuel
- Ou simple suppression du dossier
- Option de garder ou supprimer les données

### ✅ Utilisation en terminal

**Question :** Les commandes dbt sont-elles disponibles ?

**Réponse :** **OUI**
- Terminal interactif `dbt-shell.bat`
- Toutes les commandes dbt : `run`, `test`, `build`, `seed`, etc.
- Aliases pratiques : `dbt-lab1`, `dbt-backup`, etc.
- Environnement activé automatiquement

### ✅ Visualisation de la base

**Question :** Peut-on connecter un outil de visualisation ?

**Réponse :** **OUI**
- Explorateur intégré (`explore-db.py`)
- DBeaver supporté (config fournie)
- Scripts Python pour analyses
- DuckDB CLI compatible

## 🆘 Support et dépannage

### Pour les étudiants

Consultez la documentation :
- [docs/INSTALLATION.md](docs/INSTALLATION.md)
- [docs/USAGE.md](docs/USAGE.md)
- [docs/VISUALIZATION.md](docs/VISUALIZATION.md)

### Pour les formateurs

**Problèmes de build :**
- Vérifiez que NSIS est installé
- Vérifiez la connexion internet
- Consultez les logs de build

**L'installateur ne fonctionne pas :**
- Testez sur une VM Windows propre
- Vérifiez les chemins dans installer.nsi
- Vérifiez que tous les fichiers sont inclus

## 📞 Contact

**Support SFEIR :**
- Documentation : https://www.sfeir.com
- Formation : contact-formation@sfeir.com

## 📄 Licence

Voir fichier LICENSE à la racine du projet.
