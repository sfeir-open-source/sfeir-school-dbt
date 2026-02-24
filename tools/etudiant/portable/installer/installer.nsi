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
    
    ; === Generate profiles.yml directly ===
    SetOutPath "$INSTDIR"
    FileOpen $0 "$INSTDIR\profiles.yml" w
    FileWrite $0 "# dbt profiles configuration for SFEIR School DBT Portable$\r$\n"
    FileWrite $0 "# Ce fichier est copie dans ~/.dbt/profiles.yml au premier lancement$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "sfeir_student_portable:$\r$\n"
    FileWrite $0 "  target: dev$\r$\n"
    FileWrite $0 "  outputs:$\r$\n"
    FileWrite $0 "    dev:$\r$\n"
    FileWrite $0 "      type: duckdb$\r$\n"
    FileWrite $0 "      path: ./sfeir_dbt.duckdb$\r$\n"
    FileWrite $0 "      threads: 4$\r$\n"
    FileClose $0
    
    ; === Generate explore-db.py directly ===
    SetOutPath "$INSTDIR\scripts"
    FileOpen $0 "$INSTDIR\scripts\explore-db.py" w
    FileWrite $0 "#!/usr/bin/env python3$\r$\n"
    FileWrite $0 "import sys$\r$\n"
    FileWrite $0 "import os$\r$\n"
    FileWrite $0 "try:$\r$\n"
    FileWrite $0 "    import duckdb$\r$\n"
    FileWrite $0 "    from tabulate import tabulate$\r$\n"
    FileWrite $0 "except ImportError:$\r$\n"
    FileWrite $0 "    print('Erreur: duckdb ou tabulate non installe')$\r$\n"
    FileWrite $0 "    sys.exit(1)$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "def find_db():\n"
    FileWrite $0 "    for f in os.listdir('.'):\n"
    FileWrite $0 "        if f.endswith('.duckdb'): return f\n"
    FileWrite $0 "    return None\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "def main():\n"
    FileWrite $0 "    db = find_db()\n"
    FileWrite $0 "    if not db: print('Aucune base .duckdb trouvee'); return\n"
    FileWrite $0 "    conn = duckdb.connect(db, read_only=True)\n"
    FileWrite $0 "    tables = conn.execute('SHOW TABLES').fetchall()\n"
    FileWrite $0 "    print(f'Base: {db}')\n"
    FileWrite $0 "    print(f'Tables: {len(tables)}')\n"
    FileWrite $0 "    for t in tables:\n"
    FileWrite $0 "        print(f'  - {t[0]}')\n"
    FileWrite $0 "    conn.close()\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "if __name__ == '__main__': main()\n"
    FileClose $0
    
    ; === Generate explore-db.bat ===
    FileOpen $0 "$INSTDIR\scripts\explore-db.bat" w
    FileWrite $0 "@echo off$\r$\n"
    FileWrite $0 "cd /d $\"%~dp0..$\"$\r$\n"
    FileWrite $0 "call venv\\Scripts\\activate.bat$\r$\n"
    FileWrite $0 "python scripts\\explore-db.py %*$\r$\n"
    FileClose $0
    
    ; === Generate backup-work.bat ===
    FileOpen $0 "$INSTDIR\scripts\backup-work.bat" w
    FileWrite $0 "@echo off$\r$\n"
    FileWrite $0 "setlocal$\r$\n"
    FileWrite $0 "set TIMESTAMP=%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%$\r$\n"
    FileWrite $0 "set TIMESTAMP=%TIMESTAMP: =0%$\r$\n"
    FileWrite $0 "set BACKUP_DIR=%~dp0..\\workspace\\backups\\backup_%TIMESTAMP%$\r$\n"
    FileWrite $0 "mkdir $\"%BACKUP_DIR%$\" 2>nul$\r$\n"
    FileWrite $0 "xcopy /E /I /Y $\"%~dp0..\\workspace\\my-work$\" $\"%BACKUP_DIR%\\my-work$\"$\r$\n"
    FileWrite $0 "echo Backup cree: %BACKUP_DIR%$\r$\n"
    FileWrite $0 "pause$\r$\n"
    FileClose $0
    
    ; === Generate uninstall.bat ===
    FileOpen $0 "$INSTDIR\scripts\uninstall.bat" w
    FileWrite $0 "@echo off$\r$\n"
    FileWrite $0 "echo ================================================================$\r$\n"
    FileWrite $0 "echo   Desinstallation SFEIR School DBT$\r$\n"
    FileWrite $0 "echo ================================================================$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "echo ATTENTION: Cela supprimera tous vos fichiers de travail!$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "set /p CONFIRM=Continuer? (O/N): $\r$\n"
    FileWrite $0 "if /i not $\"%CONFIRM%$\"==$\"O$\" goto :end$\r$\n"
    FileWrite $0 "echo Suppression...$\r$\n"
    FileWrite $0 "del $\"%USERPROFILE%\\Desktop\\SFEIR DBT Shell.lnk$\" 2>nul$\r$\n"
    FileWrite $0 "rmdir /s /q $\"%USERPROFILE%\\Documents\\sfeir-school-dbt$\"$\r$\n"
    FileWrite $0 "echo Desinstallation terminee.$\r$\n"
    FileWrite $0 ":end$\r$\n"
    FileWrite $0 "pause$\r$\n"
    FileClose $0
    
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
