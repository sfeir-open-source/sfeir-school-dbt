@echo off
REM Exécuter les tests dbt
echo 🧪 Exécution des tests dbt...
cd ..\..\shared\dbt-projects\starter
..\..\..\etudiant\portable\venv\Scripts\dbt.exe test --profile sfeir_student_portable
cd ..\..\..\etudiant\portable
echo ✅ Tests terminés !
