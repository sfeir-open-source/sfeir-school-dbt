@echo off
setlocal enabledelayedexpansion

echo ╔═══════════════════════════════════════════════════╗
echo ║  SFEIR School DBT - Setup Formateur Portable     ║
echo ╚═══════════════════════════════════════════════════╝
echo.
echo 🚀 Mode portable : Installation sans Docker
echo.

REM 1. Vérifier Python
echo [1/5] Vérification de Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python n'est pas installé
    echo Installez Python 3.8+ depuis https://www.python.org/
    exit /b 1
)
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✓ Python %PYTHON_VERSION% trouvé

REM 2. Créer l'environnement virtuel
echo [2/5] Création de l'environnement virtuel...
if not exist "venv" (
    python -m venv venv
    echo ✓ Environnement virtuel créé
) else (
    echo ✓ Environnement virtuel déjà existant
)

REM 3. Installer les dépendances
echo [3/5] Installation de dbt et DuckDB...
call venv\Scripts\activate.bat
python -m pip install --upgrade pip >nul 2>&1
pip install -r requirements.txt
echo ✓ dbt-duckdb installé

REM 4. Configurer le profil dbt
echo [4/5] Configuration du profil dbt...
if not exist "%USERPROFILE%\.dbt" mkdir "%USERPROFILE%\.dbt"
if not exist "%USERPROFILE%\.dbt\profiles.yml" (
    copy profiles.yml.example "%USERPROFILE%\.dbt\profiles.yml" >nul
    echo ✓ Profil dbt créé dans %USERPROFILE%\.dbt\profiles.yml
) else (
    findstr /C:"sfeir_trainer_portable" "%USERPROFILE%\.dbt\profiles.yml" >nul
    if errorlevel 1 (
        type profiles.yml.example >> "%USERPROFILE%\.dbt\profiles.yml"
        echo ✓ Profil sfeir_trainer_portable ajouté
    ) else (
        echo ✓ Profil sfeir_trainer_portable déjà présent
    )
)

REM 5. Initialiser la base de données
echo [5/5] Initialisation de la base de données DuckDB...
if not exist "..\..\shared\dbt-projects\starter\seeds" mkdir "..\..\shared\dbt-projects\starter\seeds"

if exist "..\..\shared\data\seeds\*.csv" (
    echo 📋 Copie des seeds...
    copy "..\..\shared\data\seeds\*.csv" "..\..\shared\dbt-projects\starter\seeds\" >nul 2>&1
)

echo 🌱 Chargement des seeds avec dbt...
cd ..\..\shared\dbt-projects\starter
..\..\..\formateur\portable\venv\Scripts\dbt.exe seed --profiles-dir %USERPROFILE%\.dbt --profile sfeir_trainer_portable
cd ..\..\..\formateur\portable

echo.
echo ╔═══════════════════════════════════════════════════╗
echo ║              ✅ Installation terminée !            ║
echo ╚═══════════════════════════════════════════════════╝
echo.
echo 📊 Base de données : ..\..\shared\dbt-projects\starter\sfeir_dbt.duckdb
echo.
echo Prochaines étapes :
echo   • Tester dbt        : make test (ou voir README)
echo   • Charger les seeds : make dbt-seed
echo   • Lancer les modèles: make dbt-run
echo.
echo ✓ Aucun Docker requis, tout est portable !
pause
