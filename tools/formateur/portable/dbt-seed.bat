@echo off
REM Charger les seeds dans DuckDB
echo 🌱 Chargement des seeds...
cd ..\..\shared\dbt-projects\starter
..\..\..\formateur\portable\venv\Scripts\dbt.exe seed --profile sfeir_trainer_portable
cd ..\..\..\formateur\portable
echo ✅ Seeds chargés !
