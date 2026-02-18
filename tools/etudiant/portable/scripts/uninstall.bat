@echo off
REM SFEIR School DBT - Désinstallation Manuelle
REM À utiliser si la désinstallation normale ne fonctionne pas

setlocal enabledelayedexpansion

echo ╔═══════════════════════════════════════════════════╗
echo ║         Désinstallation SFEIR School DBT          ║
echo ╚═══════════════════════════════════════════════════╝
echo.
echo ⚠️  ATTENTION : Cette action va supprimer :
echo    • L'environnement Python
echo    • Les scripts et outils
echo.
echo 💾 Vos projets et bases de données seront conservés
echo    (dossier workspace\)
echo.
echo 💡 Pour une désinstallation par le panneau de configuration,
echo    utilisez "Ajout/Suppression de programmes"
echo.

set /p CONFIRM="Êtes-vous sûr de vouloir désinstaller ? (tapez OUI) : "
if not "%CONFIRM%"=="OUI" (
    echo.
    echo ❌ Désinstallation annulée.
    pause
    exit /b 0
)

echo.
echo 🗑️  Désinstallation en cours...
echo.

REM Détecter le chemin d'installation
set "INSTALL_DIR=%~dp0.."

REM Sauvegarder le workspace avant suppression
set /p BACKUP="Voulez-vous sauvegarder votre workspace avant ? (O/N) : "
if /i "%BACKUP%"=="O" (
    echo.
    echo 💾 Création d'une sauvegarde...
    call "%~dp0backup-work.bat"
)

echo.
echo 🗑️  Suppression des composants...

REM 1. Supprimer Python portable
if exist "%INSTALL_DIR%\python_portable" (
    echo    Suppression de Python portable...
    rmdir /s /q "%INSTALL_DIR%\python_portable" 2>nul
    if !ERRORLEVEL! == 0 (
        echo    ✓ Python portable supprimé
    ) else (
        echo    ⚠️  Erreur lors de la suppression de Python portable
    )
)

REM 2. Supprimer l'environnement virtuel
if exist "%INSTALL_DIR%\venv" (
    echo    Suppression de l'environnement virtuel...
    rmdir /s /q "%INSTALL_DIR%\venv" 2>nul
    if !ERRORLEVEL! == 0 (
        echo    ✓ Environnement virtuel supprimé
    ) else (
        echo    ⚠️  Erreur lors de la suppression du venv
    )
)

REM 3. Supprimer les wheels
if exist "%INSTALL_DIR%\wheels" (
    echo    Suppression des packages...
    rmdir /s /q "%INSTALL_DIR%\wheels" 2>nul
    if !ERRORLEVEL! == 0 (
        echo    ✓ Packages supprimés
    ) else (
        echo    ⚠️  Erreur lors de la suppression des wheels
    )
)

REM 4. Supprimer les raccourcis
echo    Suppression des raccourcis...
if exist "%USERPROFILE%\Desktop\SFEIR DBT Terminal.lnk" (
    del "%USERPROFILE%\Desktop\SFEIR DBT Terminal.lnk" 2>nul
    echo    ✓ Raccourci Terminal supprimé
)
if exist "%USERPROFILE%\Desktop\SFEIR DBT Workspace.lnk" (
    del "%USERPROFILE%\Desktop\SFEIR DBT Workspace.lnk" 2>nul
    echo    ✓ Raccourci Workspace supprimé
)
if exist "%USERPROFILE%\Desktop\SFEIR DB Explorer.lnk" (
    del "%USERPROFILE%\Desktop\SFEIR DB Explorer.lnk" 2>nul
    echo    ✓ Raccourci Explorer supprimé
)

REM 5. Demander pour la configuration dbt
echo.
set /p DELETE_CONFIG="Supprimer la configuration dbt (~\.dbt\profiles.yml) ? (O/N) : "
if /i "%DELETE_CONFIG%"=="O" (
    if exist "%USERPROFILE%\.dbt\profiles.yml" (
        REM Sauvegarder d'abord
        copy "%USERPROFILE%\.dbt\profiles.yml" "%USERPROFILE%\.dbt\profiles.yml.backup" >nul 2>&1
        del "%USERPROFILE%\.dbt\profiles.yml" 2>nul
        echo    ✓ Configuration dbt supprimée (backup créé)
    )
)

REM 6. Demander pour le workspace
echo.
set /p DELETE_WORKSPACE="⚠️  Supprimer également le workspace (projets + données) ? (O/N) : "
if /i "%DELETE_WORKSPACE%"=="O" (
    set /p CONFIRM_WORKSPACE="Êtes-vous VRAIMENT sûr ? Tous vos travaux seront perdus ! (tapez OUI) : "
    if "!CONFIRM_WORKSPACE!"=="OUI" (
        if exist "%INSTALL_DIR%\workspace" (
            echo    Suppression du workspace...
            rmdir /s /q "%INSTALL_DIR%\workspace" 2>nul
            if !ERRORLEVEL! == 0 (
                echo    ✓ Workspace supprimé
            ) else (
                echo    ⚠️  Erreur lors de la suppression du workspace
            )
        )
    ) else (
        echo    ✓ Workspace conservé
    )
) else (
    echo    ✓ Workspace conservé
)

echo.
echo ╔═══════════════════════════════════════════════════╗
echo ║          ✅ Désinstallation terminée !             ║
echo ╚═══════════════════════════════════════════════════╝
echo.

if /i not "%DELETE_WORKSPACE%"=="O" (
    echo 📁 Votre workspace est toujours disponible dans :
    echo    %INSTALL_DIR%\workspace
    echo.
    echo 💡 Pour supprimer complètement le dossier d'installation :
    echo    %INSTALL_DIR%
    echo.
)

echo 💡 Pour réinstaller, lancez à nouveau l'installateur.
echo.
pause
