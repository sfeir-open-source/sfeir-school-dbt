@echo off
REM Tester la connexion dbt
echo 🧪 Test de la connexion dbt...
cd ..\..\shared\dbt-projects\starter
..\..\..\etudiant\portable\venv\Scripts\dbt.exe debug --profile sfeir_student_portable
cd ..\..\..\etudiant\portable
