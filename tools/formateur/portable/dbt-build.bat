@echo off
REM Builder le projet dbt (seed + run + test)
echo 🏗️  Build du projet dbt...
cd ..\..\shared\dbt-projects\starter
..\..\..\formateur\portable\venv\Scripts\dbt.exe build --profile sfeir_trainer_portable
cd ..\..\..\formateur\portable
echo ✅ Build terminé !
