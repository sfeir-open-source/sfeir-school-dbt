@echo off
REM SFEIR School DBT - Terminal Interactif
REM Activer l'environnement dbt avec toutes les commandes disponibles

title SFEIR School DBT - Terminal
setlocal enabledelayedexpansion

REM Détecter le chemin d'installation
set "INSTALL_DIR=%~dp0.."
cd /d "%INSTALL_DIR%"

REM Activer l'environnement virtuel
if not exist "venv\Scripts\activate.bat" (
    echo ❌ Environnement virtuel non trouvé !
    echo Vérifiez que l'installation est complète.
    pause
    exit /b 1
)

call venv\Scripts\activate.bat

REM Créer des alias pratiques avec doskey
doskey dbt-lab1=cd /d "%INSTALL_DIR%\workspace\labs\lab-01-models" $T dbt $*
doskey dbt-lab2=cd /d "%INSTALL_DIR%\workspace\labs\lab-02-sources" $T dbt $*
doskey dbt-lab3=cd /d "%INSTALL_DIR%\workspace\labs\lab-03-tests" $T dbt $*
doskey dbt-lab4=cd /d "%INSTALL_DIR%\workspace\labs\lab-04-documentation" $T dbt $*
doskey dbt-lab5=cd /d "%INSTALL_DIR%\workspace\labs\lab-05-advanced" $T dbt $*
doskey dbt-work=cd /d "%INSTALL_DIR%\workspace\my-work"
doskey dbt-clean=dbt clean $T dbt deps
doskey dbt-fresh=dbt clean $T dbt deps $T dbt seed $T dbt run
doskey dbt-backup=call "%INSTALL_DIR%\scripts\backup-work.bat"
doskey dbt-explore=call "%INSTALL_DIR%\scripts\explore-db.bat"
doskey ls=dir /b
doskey ll=dir

REM Message de bienvenue avec couleurs
echo.
echo ╔═══════════════════════════════════════════════════╗
echo ║       SFEIR School DBT - Terminal Interactif      ║
echo ╚═══════════════════════════════════════════════════╝
echo.
echo ✅ Environnement dbt activé !
echo.
echo 📁 Projets disponibles :
dir /b workspace\labs
echo.
echo 💡 Commandes rapides :
echo    • dbt-lab1, dbt-lab2, ... : Aller dans un lab
echo    • dbt-work                : Aller dans my-work
echo    • dbt-backup              : Sauvegarder votre travail
echo    • dbt-explore             : Explorer une base de données
echo    • dbt-fresh               : Réinitialiser un projet
echo.
echo 🔨 Commandes dbt standard :
echo    • dbt seed                : Charger les données CSV
echo    • dbt run                 : Exécuter les modèles
echo    • dbt test                : Lancer les tests
echo    • dbt build               : Tout faire (seed + run + test)
echo    • dbt docs generate       : Générer la documentation
echo    • dbt docs serve          : Servir la documentation
echo.
echo 📍 Pour commencer : cd workspace\labs\lab-01-models
echo    puis : dbt seed ^&^& dbt run
echo.
echo 💾 Vos bases de données sont dans les dossiers de chaque lab
echo    (fichiers *.duckdb)
echo.
echo ℹ️  Tapez 'exit' pour quitter ce terminal
echo.

REM Aller dans le workspace par défaut
cd /d "%INSTALL_DIR%\workspace"

REM Prompt personnalisé
prompt (dbt-portable) $P$G

REM Ouvrir un shell interactif
cmd /k
