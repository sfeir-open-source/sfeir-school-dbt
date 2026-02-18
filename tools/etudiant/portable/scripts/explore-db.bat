@echo off
REM Wrapper pour lancer l'explorateur de base de données

setlocal enabledelayedexpansion

REM Détecter le chemin d'installation
set "INSTALL_DIR=%~dp0.."
cd /d "%INSTALL_DIR%"

REM Activer l'environnement virtuel
if not exist "venv\Scripts\activate.bat" (
    echo ❌ Environnement virtuel non trouvé !
    pause
    exit /b 1
)

call venv\Scripts\activate.bat

REM Lancer l'explorateur
python scripts\explore-db.py %*

REM Garder la fenêtre ouverte
echo.
pause
