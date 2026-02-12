@echo off
REM Bootstrap Windows sans prérequis - Télécharge Python portable puis dbt
setlocal enabledelayedexpansion

echo ╔═══════════════════════════════════════════════════╗
echo ║  Installation COMPLETE sans prérequis (Windows)   ║
echo ╚═══════════════════════════════════════════════════╝
echo.
echo Cette installation fonctionne SANS droits admin
echo.

REM Détecter l'architecture
set "ARCH=x86_64"
if "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "ARCH=arm64"

echo [1/6] Détection du système...
echo Architecture : %ARCH%

REM Télécharger Python embeddable si pas présent
set "PYTHON_DIR=python_portable"
set "PYTHON_ZIP=python-embed.zip"
set "PYTHON_URL=https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip"

if not exist "%PYTHON_DIR%" (
    echo [2/6] Téléchargement de Python portable...
    powershell -Command "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_ZIP%'"
    
    echo [3/6] Extraction de Python portable...
    powershell -Command "Expand-Archive -Path '%PYTHON_ZIP%' -DestinationPath '%PYTHON_DIR%' -Force"
    del "%PYTHON_ZIP%"
    
    REM Installer pip
    echo Installation de pip...
    cd %PYTHON_DIR%
    powershell -Command "Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'get-pip.py'"
    
    REM Décommenter les imports dans python311._pth
    powershell -Command "(Get-Content python311._pth) -replace '#import site', 'import site' | Set-Content python311._pth"
    
    python.exe get-pip.py
    cd ..
    
    echo ✓ Python portable installé dans %PYTHON_DIR%
) else (
    echo [2/6] Python portable déjà installé
)

REM Vérifier Python
echo [3/6] Vérification de Python portable...
"%PYTHON_DIR%\python.exe" --version
if errorlevel 1 (
    echo ❌ Erreur : Python portable ne fonctionne pas
    exit /b 1
)

REM Créer environnement virtuel
echo [4/6] Création de l'environnement virtuel...
if not exist "venv" (
    "%PYTHON_DIR%\python.exe" -m venv venv
    echo ✓ Environnement virtuel créé
) else (
    echo ✓ Environnement virtuel déjà existant
)

REM Installer dbt
echo [5/6] Installation de dbt et DuckDB...
call venv\Scripts\activate.bat
python -m pip install --upgrade pip >nul 2>&1
pip install -r requirements.txt
echo ✓ dbt-duckdb installé

REM Configurer profil
echo [6/6] Configuration du profil dbt...
if not exist "%USERPROFILE%\.dbt" mkdir "%USERPROFILE%\.dbt"
if not exist "%USERPROFILE%\.dbt\profiles.yml" (
    copy profiles.yml.example "%USERPROFILE%\.dbt\profiles.yml" >nul
    echo ✓ Profil dbt créé
) else (
    findstr /C:"sfeir_student_portable" "%USERPROFILE%\.dbt\profiles.yml" >nul
    if errorlevel 1 (
        type profiles.yml.example >> "%USERPROFILE%\.dbt\profiles.yml"
        echo ✓ Profil sfeir_student_portable ajouté
    ) else (
        echo ✓ Profil déjà configuré
    )
)

REM Charger les seeds
if exist "..\..\shared\data\seeds\*.csv" (
    echo.
    echo 📋 Chargement des données initiales...
    if not exist "..\..\shared\dbt-projects\starter\seeds" mkdir "..\..\shared\dbt-projects\starter\seeds"
    copy "..\..\shared\data\seeds\*.csv" "..\..\shared\dbt-projects\starter\seeds\" >nul 2>&1
    cd ..\..\shared\dbt-projects\starter
    ..\..\..\etudiant\portable\venv\Scripts\dbt.exe seed --profile sfeir_student_portable
    cd ..\..\..\etudiant\portable
)

echo.
echo ╔═══════════════════════════════════════════════════╗
echo ║       ✅ Installation complète terminée !          ║
echo ╚═══════════════════════════════════════════════════╝
echo.
echo Python portable installé dans : %PYTHON_DIR%
echo Base de données : ..\..\shared\dbt-projects\starter\sfeir_dbt.duckdb
echo.
echo Pour utiliser :
echo   venv\Scripts\activate
echo   (puis utiliser les commandes dbt)
echo.
echo ✓ Aucun droit administrateur requis !
pause
