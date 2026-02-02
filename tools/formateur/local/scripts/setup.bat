@echo off
REM Setup Formateur Local - Windows Batch

echo.
echo ╔═══════════════════════════════════════════════════╗
echo ║  SFEIR School DBT - Setup Formateur Local        ║
echo ╚═══════════════════════════════════════════════════╝
echo.

where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    pwsh -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
) else (
    powershell -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
)
