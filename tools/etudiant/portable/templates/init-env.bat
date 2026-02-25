@echo off
REM Script d'initialisation de l'environnement dbt pour le terminal VSCode
REM Ce script configure le PATH et place l'utilisateur dans le bon dossier

cd /d "%~dp0"

REM Vérifier si les packages sont installés
if not exist ".installed" (
    echo ================================================================
    echo   SFEIR School DBT - Premier lancement
    echo ================================================================
    echo.
    echo Installation des packages dbt en cours...
    "%~dp0python\python.exe" -m pip install --no-index --find-links="%~dp0wheels" dbt-core dbt-duckdb tabulate
    if errorlevel 1 (
        echo [ERREUR] Echec de l'installation des packages
        exit /b 1
    )
    if not exist "%USERPROFILE%\.dbt" mkdir "%USERPROFILE%\.dbt"
    copy /Y "%~dp0profiles.yml" "%USERPROFILE%\.dbt\profiles.yml" >nul
    echo. > "%~dp0.installed"
    echo [OK] Installation terminee !
    echo.
)

REM Configurer le PATH
set PATH=%~dp0python;%~dp0python\Scripts;%PATH%

REM Configurer les alias Linux
doskey ls=dir /b $*
doskey ll=dir $*
doskey pwd=cd
doskey cat=type $*
doskey clear=cls

echo.
echo ================================================================
echo   SFEIR School DBT - Terminal pret !
echo ================================================================
echo.
echo Commandes dbt: dbt run, dbt test, dbt build, dbt seed
echo Raccourcis:    Ctrl+Shift+B pour les taches VSCode
echo.
