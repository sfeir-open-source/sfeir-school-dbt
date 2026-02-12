@echo off
REM Exécuter les modèles dbt
echo 🔄 Exécution des modèles dbt...
cd ..\..\shared\dbt-projects\starter
..\..\..\etudiant\portable\venv\Scripts\dbt.exe run --profile sfeir_student_portable
cd ..\..\..\etudiant\portable
