@echo off
REM Builder le projet dbt (seed + run + test)
echo 🏗️  Build du projet dbt...
cd ..\..\shared\dbt-projects\starter
..\..\..\etudiant\portable\venv\Scripts\dbt.exe build --profile sfeir_student_portable
cd ..\..\..\etudiant\portable
echo ✅ Build terminé !
