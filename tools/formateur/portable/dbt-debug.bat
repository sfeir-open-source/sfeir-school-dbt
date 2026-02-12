@echo off
REM Tester la connexion dbt
echo 🧪 Test de la connexion dbt...
cd ..\..\shared\dbt-projects\starter
..\..\..\formateur\portable\venv\Scripts\dbt.exe debug --profile sfeir_trainer_portable
cd ..\..\..\formateur\portable
