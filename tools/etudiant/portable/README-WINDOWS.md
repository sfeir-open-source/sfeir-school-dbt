# 🪟 Guide Windows - SFEIR School DBT (Mode Portable)

Guide simplifié pour les utilisateurs **Windows sans droits administrateur**.

---

## 🚀 Installation (une seule fois)

### Étape 1 : Ouvrir l'invite de commandes

- Appuyez sur **Win + R**
- Tapez `cmd`
- Appuyez sur **Entrée**

### Étape 2 : Naviguer vers le projet

```batch
cd C:\chemin\vers\sfeir-school-dbt\tools\etudiant\portable\scripts
```

💡 **Astuce :** Faites glisser le dossier `scripts` dans la fenêtre cmd pour avoir le chemin automatiquement.

### Étape 3 : Lancer l'installation automatique

```batch
bootstrap.bat
```

⏱️ **Patience :** L'installation prend 5-7 minutes.

✅ **C'est terminé !** Vous devriez voir :
```
╔═══════════════════════════════════════════════════╗
║       ✅ Installation complète terminée !          ║
╚═══════════════════════════════════════════════════╝
```

---

## 📋 Commandes de base

Toutes les commandes se lancent depuis le dossier `tools\etudiant\portable` :

```batch
cd C:\chemin\vers\sfeir-school-dbt\tools\etudiant\portable
```

### 🧪 Tester que tout fonctionne

```batch
dbt-debug.bat
```

**Résultat attendu :** `All checks passed!`

---

### 🌱 Charger les données initiales

```batch
dbt-seed.bat
```

**Résultat attendu :** `Completed successfully` avec `PASS=5`

---

### 🔄 Exécuter vos modèles dbt

```batch
dbt-run.bat
```

**Résultat attendu :** `Completed successfully` avec vos modèles exécutés

---

### ✅ Lancer les tests

```batch
dbt-test.bat
```

**Résultat attendu :** Tests passés ou échoués selon votre code

---

### 🏗️ Tout faire en une commande (seed + run + test)

```batch
dbt-build.bat
```

**Résultat attendu :** Tout s'exécute dans l'ordre

---

## 🐚 Activer la console interactive dbt

Si vous voulez utiliser dbt directement dans le terminal (pour passer des options avancées) :

### Méthode 1 : Activation manuelle

```batch
cd C:\chemin\vers\sfeir-school-dbt\tools\etudiant\portable

REM Activer l'environnement virtuel
venv\Scripts\activate.bat

REM Aller dans le projet dbt
cd ..\..\shared\dbt-projects\starter

REM Maintenant vous pouvez utiliser dbt directement
dbt run --profile sfeir_student_portable
dbt test --profile sfeir_student_portable
dbt run --select my_model --profile sfeir_student_portable
```

💡 **Votre invite change :** Vous verrez `(venv)` devant votre ligne de commande.

### Méthode 2 : Commandes dbt sans activer (plus rapide)

```batch
cd C:\chemin\vers\sfeir-school-dbt\tools\etudiant\portable

REM Appeler dbt directement via le chemin complet
venv\Scripts\dbt.exe run --profile sfeir_student_portable
venv\Scripts\dbt.exe test --profile sfeir_student_portable
```

💡 **Astuce :** Créez un alias dans PowerShell pour simplifier (voir section bonus ci-dessous).

---

## 🧹 Nettoyer et repartir de zéro

Si vous voulez supprimer la base de données et l'environnement virtuel :

```batch
cd C:\chemin\vers\sfeir-school-dbt\tools\etudiant\portable
clean.bat
```

⚠️ **Attention :** Cette commande supprime TOUT (base de données + environnement virtuel).

Pour réinstaller après un clean :
```batch
cd scripts
bootstrap.bat
```

---

## 🎯 Résumé des commandes essentielles

| Commande | Description | Quand l'utiliser |
|----------|-------------|------------------|
| `bootstrap.bat` | Installation initiale | Une seule fois au début |
| `dbt-debug.bat` | Tester la connexion | Pour vérifier que tout marche |
| `dbt-seed.bat` | Charger les données CSV | Au début, ou après un `clean.bat` |
| `dbt-run.bat` | Exécuter les modèles | À chaque modification de modèle |
| `dbt-test.bat` | Lancer les tests | Pour valider votre code |
| `dbt-build.bat` | Tout faire d'un coup | Quand vous voulez tout relancer |
| `clean.bat` | Nettoyer complètement | En cas de problème, pour repartir de zéro |

---

## 🆘 Problèmes courants

### Erreur : "Le terme 'dbt-run.bat' n'est pas reconnu"

**Solution :** Vous n'êtes pas dans le bon dossier.
```batch
cd C:\chemin\vers\sfeir-school-dbt\tools\etudiant\portable
```

### Erreur : "Python n'est pas installé"

**Solution :** Utilisez `bootstrap.bat` au lieu de `setup.bat`. Bootstrap télécharge Python automatiquement.

### Erreur : "Access denied" ou "Accès refusé"

**Solution :** Vérifiez que vous n'essayez pas de lancer ces commandes en tant qu'administrateur. Tout doit fonctionner en mode utilisateur normal.

### Mon antivirus bloque l'installation

**Solution :** Ajoutez une exception pour le dossier `sfeir-school-dbt` dans votre antivirus. Cette action ne nécessite généralement pas de droits admin.

---

## 💡 BONUS : Simplifier avec PowerShell

Si vous préférez PowerShell, créez un profil avec des alias :

### Étape 1 : Ouvrir votre profil PowerShell

```powershell
notepad $PROFILE
```

Si le fichier n'existe pas :
```powershell
New-Item -Path $PROFILE -Type File -Force
notepad $PROFILE
```

### Étape 2 : Ajouter des alias

```powershell
# Alias pour dbt (adaptez le chemin à votre projet)
function dbt-portable {
    & "C:\chemin\vers\sfeir-school-dbt\tools\etudiant\portable\venv\Scripts\dbt.exe" @args --profile sfeir_student_portable
}

Set-Alias dbt dbt-portable
```

### Étape 3 : Recharger le profil

```powershell
. $PROFILE
```

**Maintenant vous pouvez utiliser :**
```powershell
dbt run
dbt test
dbt seed
```

Directement depuis n'importe quel dossier ! 🎉

---

## 📞 Besoin d'aide ?

Demandez à votre formateur ou consultez :
- [Documentation dbt](https://docs.getdbt.com/)
- [Documentation DuckDB](https://duckdb.org/docs/)

✅ **Tout fonctionne sans droits administrateur !**
