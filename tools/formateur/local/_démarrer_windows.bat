@echo off
echo Lancement de l'installation Formateur...
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0scripts\setup.ps1'"
pause