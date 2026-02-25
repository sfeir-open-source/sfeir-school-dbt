@echo off
setlocal enabledelayedexpansion

REM ================================================================
REM   SFEIR School DBT - Lancement avec VSCode
REM ================================================================
REM Ce script detecte VSCode et le telecharge si necessaire
REM puis ouvre le workspace

cd /d "%~dp0"

echo ================================================================
echo   SFEIR School DBT - Demarrage
echo ================================================================
echo.

REM Verifier si VSCode portable local existe
if exist "%~dp0vscode\Code.exe" (
    echo [OK] VSCode portable detecte
    set VSCODE_CMD="%~dp0vscode\Code.exe"
    goto :launch
)

REM Verifier si VSCode est installe globalement
where code.exe >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] VSCode systeme detecte
    set VSCODE_CMD=code
    goto :launch
)

REM Verifier les chemins classiques d'installation
if exist "%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe" (
    echo [OK] VSCode detecte dans AppData
    set VSCODE_CMD="%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe"
    goto :launch
)

if exist "%ProgramFiles%\Microsoft VS Code\Code.exe" (
    echo [OK] VSCode detecte dans Program Files
    set VSCODE_CMD="%ProgramFiles%\Microsoft VS Code\Code.exe"
    goto :launch
)

REM VSCode non trouve - proposer le telechargement
echo [INFO] VSCode n'est pas installe sur ce systeme.
echo.
echo Options:
echo   1. Telecharger VSCode portable automatiquement (~150 MB)
echo   2. Ouvrir le terminal dbt uniquement (sans editeur)
echo   3. Quitter
echo.
choice /c 123 /n /m "Votre choix [1/2/3]: "

if %ERRORLEVEL% EQU 1 goto :download_vscode
if %ERRORLEVEL% EQU 2 goto :terminal_only
if %ERRORLEVEL% EQU 3 goto :end

:download_vscode
echo.
echo ================================================================
echo   Telechargement de VSCode Portable
echo ================================================================
echo.
echo [1/3] Telechargement en cours... (cela peut prendre quelques minutes)

REM Creer le dossier vscode
if not exist "%~dp0vscode" mkdir "%~dp0vscode"

REM Telecharger VSCode portable (zip)
set VSCODE_URL=https://code.visualstudio.com/sha/download?build=stable^&os=win32-x64-archive
set VSCODE_ZIP=%~dp0vscode\vscode.zip

powershell -Command "& {$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%VSCODE_URL%' -OutFile '%VSCODE_ZIP%'}"

if not exist "%VSCODE_ZIP%" (
    echo [ERREUR] Echec du telechargement.
    echo Verifiez votre connexion internet.
    echo.
    echo Alternative: Telechargez VSCode manuellement depuis:
    echo https://code.visualstudio.com/download
    echo.
    pause
    goto :terminal_only
)

echo [2/3] Extraction de VSCode...
powershell -Command "& {Expand-Archive -Path '%VSCODE_ZIP%' -DestinationPath '%~dp0vscode' -Force}"
del "%VSCODE_ZIP%" >nul 2>&1

REM Creer le fichier data pour mode portable
if not exist "%~dp0vscode\data" mkdir "%~dp0vscode\data"

echo [3/3] Configuration du mode portable...
echo [OK] VSCode portable installe avec succes !
echo.

set VSCODE_CMD="%~dp0vscode\Code.exe"
goto :launch

:launch
REM S'assurer que l'environnement est initialise
if not exist "%~dp0.installed" (
    echo [INFO] Initialisation de l'environnement dbt...
    call "%~dp0setup-env.bat"
)

echo.
echo Ouverture de VSCode avec le workspace SFEIR DBT...
echo.
echo ----------------------------------------------------------------
echo   Conseil: Utilisez le terminal integre de VSCode
echo   (Ctrl+`) pour executer les commandes dbt
echo ----------------------------------------------------------------
echo.

REM Ouvrir le workspace
start "" %VSCODE_CMD% "%~dp0sfeir-dbt.code-workspace"
goto :end

:terminal_only
echo.
echo Ouverture du terminal dbt...
start "" "%~dp0dbt-shell.bat"
goto :end

:end
endlocal
