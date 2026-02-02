@echo off
REM Setup Étudiant Local - Windows Batch
REM Ce script appelle le PowerShell correspondant

echo.
echo ╔═══════════════════════════════════════════════════╗
echo ║  SFEIR School DBT - Setup Étudiant Local         ║
echo ╚═══════════════════════════════════════════════════╝
echo.

REM Vérifier PowerShell
where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    pwsh -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
) else (
    powershell -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
)
