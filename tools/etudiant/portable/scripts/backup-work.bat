@echo off
REM SFEIR School DBT - Sauvegarde du travail
REM Crée une copie de sauvegarde du workspace

setlocal enabledelayedexpansion

echo ╔═══════════════════════════════════════════════════╗
echo ║         Sauvegarde de votre travail               ║
echo ╚═══════════════════════════════════════════════════╝
echo.

REM Détecter le chemin d'installation
set "INSTALL_DIR=%~dp0.."
cd /d "%INSTALL_DIR%"

REM Créer un nom de sauvegarde avec timestamp
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)
set "BACKUP_NAME=backup_%mydate%_%mytime%"
set "BACKUP_NAME=%BACKUP_NAME: =0%"

set "BACKUP_DIR=workspace\backups\%BACKUP_NAME%"

echo 📅 Création de la sauvegarde : %BACKUP_NAME%
echo.

REM Créer le dossier de sauvegarde
if not exist "workspace\backups" mkdir "workspace\backups"
mkdir "%BACKUP_DIR%"

REM Sauvegarder les labs
echo 📁 Sauvegarde des labs...
if exist "workspace\labs" (
    xcopy /E /I /Q "workspace\labs" "%BACKUP_DIR%\labs" > nul
    echo    ✓ Labs sauvegardés
) else (
    echo    ⚠️  Dossier labs non trouvé
)

REM Sauvegarder my-work
echo 📁 Sauvegarde de my-work...
if exist "workspace\my-work" (
    xcopy /E /I /Q "workspace\my-work" "%BACKUP_DIR%\my-work" > nul
    echo    ✓ My-work sauvegardé
) else (
    echo    ⚠️  Dossier my-work non trouvé
)

REM Créer un fichier d'info sur la sauvegarde
echo 💾 Création du fichier d'information...
(
    echo Sauvegarde SFEIR School DBT
    echo ==========================
    echo.
    echo Date: %date% %time%
    echo Nom: %BACKUP_NAME%
    echo.
    echo Contenu:
    dir /s /b "%BACKUP_DIR%"
) > "%BACKUP_DIR%\backup-info.txt"

echo    ✓ Fichier d'info créé

echo.
echo ╔═══════════════════════════════════════════════════╗
echo ║           ✅ Sauvegarde terminée !                 ║
echo ╚═══════════════════════════════════════════════════╝
echo.
echo 📁 Emplacement : %BACKUP_DIR%
echo.

REM Afficher la taille de la sauvegarde
for /f "tokens=3" %%a in ('dir "%BACKUP_DIR%" /s /-c ^| find "bytes"') do set BACKUP_SIZE=%%a
if defined BACKUP_SIZE (
    echo 📊 Taille : %BACKUP_SIZE% octets
)

echo.
echo 💡 Pour restaurer cette sauvegarde :
echo    1. Ouvrez le dossier : %BACKUP_DIR%
echo    2. Copiez les dossiers vers workspace\
echo.
echo 💡 Pour nettoyer les anciennes sauvegardes :
echo    Supprimez les dossiers dans workspace\backups\
echo.
pause
