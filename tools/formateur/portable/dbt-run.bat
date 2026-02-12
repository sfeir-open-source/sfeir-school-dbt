@echo off
REM Exécuter les modèles dbt
echo 🔄 Exécution des modèles dbt...
cd ..\..\shared\dbt-projects\starter
..\..\..\formateur\portable\venv\Scripts\dbt.exe run --profile sfeir_trainer_portable
cd ..\..\..\formateur\portable
