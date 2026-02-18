# 📦 Guide d'Installation - SFEIR School DBT

## 🎯 Qu'est-ce que c'est ?

SFEIR School DBT est un environnement portable complet pour apprendre dbt (data build tool) sans avoir besoin de droits administrateur ou de Docker.

**Contenu de l'installation :**
- ✅ Python portable (ne touche pas votre système)
- ✅ dbt-core et dbt-duckdb pré-installés
- ✅ DuckDB (base de données fichier, pas de serveur)
- ✅ 5 labs pré-configurés avec données
- ✅ Scripts et outils pour faciliter le travail
- ✅ Documentation complète

## 💻 Configuration requise

**Système d'exploitation :**
- Windows 10 ou supérieur
- 64 bits (x86_64)

**Espace disque :**
- Installation : ~150 MB
- Avec travail : ~300-500 MB

**Droits :**
- ✅ **AUCUN droit administrateur requis**
- Installation dans Documents/

## 🚀 Installation

### Étape 1 : Télécharger l'installateur

Vous avez reçu le fichier `sfeir-dbt-installer.exe` par :
- Email
- Google Drive / OneDrive
- Clé USB
- Serveur intranet

**Taille du fichier :** ~50-80 MB

### Étape 2 : Lancer l'installateur

1. **Double-cliquez** sur `sfeir-dbt-installer.exe`

2. Si Windows SmartScreen apparaît :
   ```
   "Windows a protégé votre PC"
   ```
   - Cliquez sur **"Informations complémentaires"**
   - Puis **"Exécuter quand même"**
   
   ⚠️ C'est normal pour les fichiers téléchargés depuis internet

3. **Suivez l'assistant d'installation :**
   - Bienvenue → Cliquez **Suivant**
   - Dossier d'installation : `C:\Users\VotreNom\Documents\sfeir-school-dbt`
     (Vous pouvez le changer si besoin)
   - Cliquez **Installer**

4. **Patientez pendant l'installation** (2-3 minutes)
   - Extraction de Python
   - Installation de dbt
   - Configuration des labs
   - Création des bases de données
   - Création des raccourcis

5. **Terminé !**
   - Cochez "Ouvrir le terminal DBT maintenant" si vous voulez
   - Cliquez **Terminer**

### Étape 3 : Vérifier l'installation

Sur votre bureau, vous devriez voir **3 nouveaux raccourcis :**

1. **SFEIR DBT Terminal** 🖥️
   - Terminal interactif avec toutes les commandes dbt

2. **SFEIR DBT Workspace** 📁
   - Accès direct à vos projets

3. **SFEIR DB Explorer** 🔍
   - Explorateur de base de données

**Dans le menu Démarrer :**
- Ouvrez "SFEIR School DBT"
- Vous y trouverez tous les raccourcis + documentation

## ✅ Test de l'installation

### Test rapide (1 minute)

1. **Double-cliquez** sur **"SFEIR DBT Terminal"**

2. Un terminal s'ouvre avec :
   ```
   ╔═══════════════════════════════════════════════════╗
   ║       SFEIR School DBT - Terminal Interactif      ║
   ╚═══════════════════════════════════════════════════╝
   
   ✅ Environnement dbt activé !
   ```

3. **Tapez** :
   ```batch
   dbt-lab1
   ```
   Cela vous amène dans le premier lab

4. **Tapez** :
   ```batch
   dbt --version
   ```
   
   **Résultat attendu :**
   ```
   Core:
     - installed: 1.10.0
     - latest:    1.10.0
   
   Plugins:
     - duckdb: 1.10.0
   ```

5. **Testez l'exécution** :
   ```batch
   dbt run
   ```
   
   **Si c'est la première fois :**
   ```batch
   dbt seed
   dbt run
   ```

✅ **Si vous voyez "Completed successfully", c'est parfait !**

### Test de l'explorateur DB

1. **Double-cliquez** sur **"SFEIR DB Explorer"**

2. Choisissez une base (par exemple : 1 pour lab-01)

3. Vous devriez voir :
   - La liste des tables
   - Le schéma de chaque table
   - Un aperçu des données

## 🔧 Que fait l'installateur ?

### Dans votre système

**Dossier d'installation :** `C:\Users\VotreNom\Documents\sfeir-school-dbt\`

```
sfeir-school-dbt/
├── python_portable/          # Python autonome (ne touche pas le système)
├── venv/                     # Environnement virtuel Python
├── workspace/                # VOS PROJETS
│   ├── labs/                 # Labs de formation
│   │   ├── lab-01-models/
│   │   ├── lab-02-sources/
│   │   ├── lab-03-tests/
│   │   ├── lab-04-documentation/
│   │   └── lab-05-advanced/
│   ├── my-work/              # Votre espace perso
│   └── backups/              # Sauvegardes auto
├── scripts/                  # Scripts utilitaires
├── templates/                # Templates de config
├── docs/                     # Documentation
└── uninstall.exe             # Désinstallateur
```

**Configuration dbt :** `C:\Users\VotreNom\.dbt\profiles.yml`
- Fichier de configuration pour dbt
- Conservé même après désinstallation (sauf si vous le supprimez)

**Aucune autre modification** du système !

## 📍 Prochaines étapes

1. **Lisez le guide d'utilisation** : [USAGE.md](USAGE.md)
2. **Testez le premier lab** : `workspace\labs\lab-01-models`
3. **Explorez la documentation dbt** : https://docs.getdbt.com

## 🆘 Problèmes courants

### L'installateur ne se lance pas

**Cause :** Antivirus bloque l'exécution

**Solution :**
1. Ajoutez une exception dans votre antivirus pour `sfeir-dbt-installer.exe`
2. Ou temporairement, désactivez votre antivirus pendant l'installation

### "Impossible d'installer dans ce dossier"

**Cause :** Permissions insuffisantes sur le dossier choisi

**Solution :**
1. Utilisez le dossier par défaut (Documents)
2. Ou choisissez un dossier dans votre espace utilisateur

### L'installation est très lente

**Cause :** Antivirus analyse chaque fichier

**Solution :**
- C'est normal, patientez
- L'installation prend 2-5 minutes selon votre machine

### "Python n'est pas reconnu" après installation

**Cause :** Vous essayez d'utiliser Python depuis un terminal normal

**Solution :**
- Utilisez **"SFEIR DBT Terminal"** (raccourci bureau)
- Ne pas utiliser cmd.exe ou PowerShell directement

### Les raccourcis bureau ne fonctionnent pas

**Solution :**
1. Allez dans le menu Démarrer → "SFEIR School DBT"
2. Ou naviguez manuellement vers `C:\Users\VotreNom\Documents\sfeir-school-dbt`
3. Lancez `scripts\dbt-shell.bat`

## 🔄 Mise à jour

Pour mettre à jour vers une nouvelle version :

1. **Sauvegardez votre travail** (voir [USAGE.md](USAGE.md))
2. **Désinstallez** l'ancienne version (Panneau de configuration)
3. **Installez** la nouvelle version
4. **Restaurez** votre workspace si nécessaire

## 🗑️ Désinstallation

### Option 1 : Panneau de configuration (recommandé)

1. **Windows 10/11 :**
   - Paramètres → Applications → SFEIR School DBT → Désinstaller

2. **Sélectionnez** ce que vous voulez garder :
   - Projets et données (workspace)
   - Configuration dbt

### Option 2 : Désinstallation manuelle

1. Lancez `scripts\uninstall.bat`
2. Suivez les instructions

**Désinstallation complète :**
```batch
# Supprimer tout le dossier
rmdir /s "C:\Users\VotreNom\Documents\sfeir-school-dbt"

# Supprimer la config dbt (optionnel)
del "%USERPROFILE%\.dbt\profiles.yml"
```

## 📞 Support

**En cas de problème :**

1. Consultez [USAGE.md](USAGE.md) pour l'utilisation
2. Consultez [VISUALIZATION.md](VISUALIZATION.md) pour la visualisation DB
3. Contactez votre formateur SFEIR

**Logs d'installation :**
- Fichier : `C:\Users\VotreNom\Documents\sfeir-school-dbt\install.log`
- Envoyer ce fichier au support en cas de problème

## ℹ️ Informations techniques

**Composants installés :**
- Python 3.11.9 (embeddable)
- dbt-core ≥1.10.0
- dbt-duckdb ≥1.10.0
- DuckDB (inclus dans dbt-duckdb)
- tabulate (pour l'explorateur DB)

**Sécurité :**
- Installation utilisateur uniquement (pas de droits admin)
- Aucune modification du registre système
- Aucun service Windows installé
- Aucune connexion réseau après installation

**Compatibilité :**
- Windows 10/11 64-bit
- Compatible avec les environnements d'entreprise restrictifs
- Pas de conflit avec d'autres installations Python

---

**Prêt à commencer ?** 🚀

👉 Lisez maintenant [USAGE.md](USAGE.md) pour apprendre à utiliser dbt !
