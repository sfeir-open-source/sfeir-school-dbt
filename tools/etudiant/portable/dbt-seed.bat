@echo off
REM Charger les seeds dans DuckDB
echo 🌱 Chargement des seeds...
cd ..\..\shared\dbt-projects\starter
..\..\..\etudiant\portable\venv\Scripts\dbt.exe seed --profile sfeir_student_portable
cd ..\..\..\etudiant\portable
echo ✅ Seeds chargés !
