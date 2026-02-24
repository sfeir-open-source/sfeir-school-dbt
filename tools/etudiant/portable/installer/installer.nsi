; NSIS Installer Script for SFEIR School DBT
; Installation SANS droits admin dans le dossier Documents

!include "MUI2.nsh"
!include "FileFunc.nsh"

; --- Project Information ---
Name "SFEIR School DBT Portable"
OutFile "sfeir-dbt-installer.exe"
InstallDir "$DOCUMENTS\sfeir-school-dbt"
RequestExecutionLevel user

; --- MUI Settings (no icon file needed) ---
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "French"

; --- Install Section ---
Section "Install"
    SetOutPath "$INSTDIR"
    
    ; Create base directories
    CreateDirectory "$INSTDIR\python"
    CreateDirectory "$INSTDIR\wheels"
    CreateDirectory "$INSTDIR\scripts"
    CreateDirectory "$INSTDIR\workspace"
    CreateDirectory "$INSTDIR\workspace\labs"
    CreateDirectory "$INSTDIR\workspace\my-work"
    CreateDirectory "$INSTDIR\workspace\backups"
    
    ; Copy Python portable
    SetOutPath "$INSTDIR\python"
    File /r "build\python_portable\*.*"
    
    ; Copy wheels
    SetOutPath "$INSTDIR\wheels"
    File /r "build\wheels\*.*"
    
    ; Copy workspace (labs, templates, etc.)
    SetOutPath "$INSTDIR\workspace"
    File /r "build\workspace\*.*"
    
    ; Copy scripts
    SetOutPath "$INSTDIR\scripts"
    File "build\scripts\dbt-shell.bat"
    File "build\scripts\explore-db.bat"
    File "build\scripts\explore-db.py"
    File "build\scripts\backup-work.bat"
    File "build\scripts\uninstall.bat"
    
    ; Copy profiles.yml template
    SetOutPath "$INSTDIR"
    File "build\templates\profiles.yml"
    
    ; Create setup script that will run on first launch
    SetOutPath "$INSTDIR"
    FileOpen $0 "$INSTDIR\setup-env.bat" w
    FileWrite $0 "@echo off$\r$\n"
    FileWrite $0 "echo ================================================================$\r$\n"
    FileWrite $0 "echo   SFEIR School DBT - Configuration de l'environnement$\r$\n"
    FileWrite $0 "echo ================================================================$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "if exist \"%~dp0venv\" ($\r$\n"
    FileWrite $0 "    echo [OK] Environnement deja configure.$\r$\n"
    FileWrite $0 "    goto :end$\r$\n"
    FileWrite $0 ")$\r$\n"
    FileWrite $0 "echo [1/3] Creation de l'environnement virtuel...$\r$\n"
    FileWrite $0 "\"%~dp0python\\python.exe\" -m venv \"%~dp0venv\"$\r$\n"
    FileWrite $0 "echo [2/3] Installation des packages dbt...$\r$\n"
    FileWrite $0 "call \"%~dp0venv\\Scripts\\activate.bat\"$\r$\n"
    FileWrite $0 "pip install --no-index --find-links=\"%~dp0wheels\" dbt-core dbt-duckdb tabulate$\r$\n"
    FileWrite $0 "echo [3/3] Configuration du profil dbt...$\r$\n"
    FileWrite $0 "if not exist \"%USERPROFILE%\\.dbt\" mkdir \"%USERPROFILE%\\.dbt\"$\r$\n"
    FileWrite $0 "copy /Y \"%~dp0profiles.yml\" \"%USERPROFILE%\\.dbt\\profiles.yml\"$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "echo [OK] Installation terminee !$\r$\n"
    FileWrite $0 ":end$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "pause$\r$\n"
    FileClose $0
    
    ; Create launcher script
    FileOpen $0 "$INSTDIR\dbt-shell.bat" w
    FileWrite $0 "@echo off$\r$\n"
    FileWrite $0 "cd /d \"%~dp0\"$\r$\n"
    FileWrite $0 "if not exist venv ($\r$\n"
    FileWrite $0 "    echo Premier lancement - Configuration en cours...$\r$\n"
    FileWrite $0 "    call setup-env.bat$\r$\n"
    FileWrite $0 ")$\r$\n"
    FileWrite $0 "call venv\\Scripts\\activate.bat$\r$\n"
    FileWrite $0 "cd workspace$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "echo ================================================================$\r$\n"
    FileWrite $0 "echo   SFEIR School DBT - Terminal Interactif$\r$\n"
    FileWrite $0 "echo ================================================================$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "echo Commandes: dbt run, dbt test, dbt build, dbt seed$\r$\n"
    FileWrite $0 "echo Labs: cd labs\\lab-01-models$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "cmd /k$\r$\n"
    FileClose $0
    
    ; Create desktop shortcut
    CreateShortCut "$DESKTOP\SFEIR DBT Shell.lnk" "$INSTDIR\dbt-shell.bat" "" "" "" SW_SHOWNORMAL "" "Terminal dbt pour SFEIR School"
    
    ; Create Start Menu shortcuts
    CreateDirectory "$SMPROGRAMS\SFEIR School DBT"
    CreateShortCut "$SMPROGRAMS\SFEIR School DBT\DBT Shell.lnk" "$INSTDIR\dbt-shell.bat"
    CreateShortCut "$SMPROGRAMS\SFEIR School DBT\Workspace.lnk" "$INSTDIR\workspace"
    CreateShortCut "$SMPROGRAMS\SFEIR School DBT\Desinstaller.lnk" "$INSTDIR\scripts\uninstall.bat"
    
    ; Write uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"
    
    ; Success message
    MessageBox MB_YESNO "Installation terminee !$\r$\n$\r$\nVoulez-vous lancer le terminal dbt maintenant ?" IDNO skip_launch
        Exec '"$INSTDIR\dbt-shell.bat"'
    skip_launch:
SectionEnd

Section "Uninstall"
    ; Remove desktop shortcut
    Delete "$DESKTOP\SFEIR DBT Shell.lnk"
    
    ; Remove Start Menu shortcuts
    Delete "$SMPROGRAMS\SFEIR School DBT\DBT Shell.lnk"
    Delete "$SMPROGRAMS\SFEIR School DBT\Workspace.lnk"
    Delete "$SMPROGRAMS\SFEIR School DBT\Desinstaller.lnk"
    RMDir "$SMPROGRAMS\SFEIR School DBT"
    
    ; Remove installation directory
    RMDir /r "$INSTDIR"
SectionEnd
