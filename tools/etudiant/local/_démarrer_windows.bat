@echo off
echo Lancement de l'installation Etudiant...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0scripts\setup.ps1'"
pause