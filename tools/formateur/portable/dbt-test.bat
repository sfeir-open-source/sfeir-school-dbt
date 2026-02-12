@echo off
REM Exécuter les tests dbt
echo 🧪 Exécution des tests dbt...
cd ..\..\shared\dbt-projects\starter
..\..\..\formateur\portable\venv\Scripts\dbt.exe test --profile sfeir_trainer_portable
cd ..\..\..\formateur\portable
echo ✅ Tests terminés !
