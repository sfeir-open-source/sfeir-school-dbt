; SFEIR School DBT - Installateur Portable Windows
; Aucun droit administrateur requis - Installation utilisateur uniquement
;
; Pour compiler : makensis installer.nsi
; Produit : sfeir-dbt-installer.exe

!define PRODUCT_NAME "SFEIR School DBT"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "SFEIR"
!define PRODUCT_WEB_SITE "https://www.sfeir.com"

; Configuration
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "sfeir-dbt-installer.exe"
InstallDir "$DOCUMENTS\sfeir-school-dbt"
InstallDirRegKey HKCU "Software\${PRODUCT_NAME}" "InstallDir"

; Pas de droits admin requis
RequestExecutionLevel user

; Interface moderne
!include "MUI2.nsh"

; Pages de l'installateur
!define MUI_ABORTWARNING
!define MUI_ICON "assets\icon.ico"
!define MUI_WELCOMEPAGE_TITLE "Bienvenue dans l'installation de ${PRODUCT_NAME}"
!define MUI_WELCOMEPAGE_TEXT "Cet assistant va installer ${PRODUCT_NAME} sur votre ordinateur.$\r$\n$\r$\n✅ Aucun droit administrateur requis$\r$\n✅ Installation rapide (2-3 minutes)$\r$\n✅ Environnement portable complet$\r$\n$\r$\nCliquez sur Suivant pour continuer."

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE "Installation terminée !"
!define MUI_FINISHPAGE_TEXT "${PRODUCT_NAME} a été installé avec succès.$\r$\n$\r$\nDouble-cliquez sur 'SFEIR DBT Terminal' sur votre bureau pour commencer."
!define MUI_FINISHPAGE_RUN "$INSTDIR\scripts\dbt-shell.bat"
!define MUI_FINISHPAGE_RUN_TEXT "Ouvrir le terminal DBT maintenant"
!insertmacro MUI_PAGE_FINISH

; Page de désinstallation
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Langues
!insertmacro MUI_LANGUAGE "French"

; Section principale
Section "Installation" SEC01
    SetOutPath "$INSTDIR"
    SetOverwrite ifnewer
    
    ; Message de progression
    DetailPrint "Installation de Python portable..."
    
    ; Extraire Python portable (pré-packagé)
    File /r "build\python_portable"
    
    ; Extraire le projet DBT
    DetailPrint "Installation du projet DBT..."
    File /r "build\workspace"
    
    ; Extraire les scripts
    DetailPrint "Installation des scripts..."
    CreateDirectory "$INSTDIR\scripts"
    SetOutPath "$INSTDIR\scripts"
    File "..\scripts\dbt-shell.bat"
    File "..\scripts\explore-db.py"
    File "..\scripts\explore-db.bat"
    File "..\scripts\backup-work.bat"
    File "..\scripts\uninstall.bat"
    File "..\scripts\setup.bat"
    
    ; Extraire les templates et configs
    DetailPrint "Configuration de l'environnement..."
    CreateDirectory "$INSTDIR\templates"
    SetOutPath "$INSTDIR\templates"
    File "..\templates\profiles.yml"
    File "..\templates\dbeaver-template.json"
    
    ; Extraire la documentation
    CreateDirectory "$INSTDIR\docs"
    SetOutPath "$INSTDIR\docs"
    File "..\docs\INSTALLATION.md"
    File "..\docs\USAGE.md"
    File "..\docs\VISUALIZATION.md"
    
    ; Extraire les wheels Python (pré-téléchargés)
    DetailPrint "Installation des dépendances Python..."
    CreateDirectory "$INSTDIR\wheels"
    SetOutPath "$INSTDIR\wheels"
    File /r "build\wheels\*.*"
    
    ; Créer l'environnement virtuel
    DetailPrint "Création de l'environnement virtuel Python..."
    SetOutPath "$INSTDIR"
    nsExec::ExecToLog '"$INSTDIR\python_portable\python.exe" -m venv venv'
    
    ; Configurer pip pour permettre import site
    DetailPrint "Configuration de Python..."
    FileOpen $0 "$INSTDIR\python_portable\python311._pth" a
    FileSeek $0 0 END
    FileWrite $0 "$\r$\nimport site$\r$\n"
    FileClose $0
    
    ; Installer get-pip si nécessaire
    nsExec::ExecToLog '"$INSTDIR\python_portable\python.exe" -m ensurepip'
    
    ; Installer les packages depuis les wheels (pas besoin d'internet)
    DetailPrint "Installation de dbt et DuckDB..."
    nsExec::ExecToLog '"$INSTDIR\venv\Scripts\pip.exe" install --upgrade pip'
    nsExec::ExecToLog '"$INSTDIR\venv\Scripts\pip.exe" install --no-index --find-links=wheels dbt-core dbt-duckdb tabulate'
    
    ; Créer le profil dbt dans le répertoire utilisateur
    DetailPrint "Configuration du profil dbt..."
    CreateDirectory "$PROFILE\.dbt"
    CopyFiles /SILENT "$INSTDIR\templates\profiles.yml" "$PROFILE\.dbt\profiles.yml"
    
    ; Initialiser les bases de données pour chaque lab
    DetailPrint "Initialisation des bases de données..."
    SetOutPath "$INSTDIR\workspace\labs\lab-01-models"
    nsExec::ExecToLog '"$INSTDIR\venv\Scripts\dbt.exe" seed --profiles-dir "$PROFILE\.dbt" --profile sfeir_student_portable'
    
    ; Créer les raccourcis
    DetailPrint "Création des raccourcis..."
    
    ; Raccourci Bureau - Terminal DBT
    CreateShortcut "$DESKTOP\SFEIR DBT Terminal.lnk" \
        "$INSTDIR\scripts\dbt-shell.bat" \
        "" \
        "$INSTDIR\python_portable\python.exe" \
        0 \
        SW_SHOWNORMAL \
        "" \
        "Terminal DBT interactif avec toutes les commandes"
    
    ; Raccourci Bureau - Workspace
    CreateShortcut "$DESKTOP\SFEIR DBT Workspace.lnk" \
        "$INSTDIR\workspace" \
        "" \
        "" \
        0
    
    ; Raccourci Bureau - Explorateur DB
    CreateShortcut "$DESKTOP\SFEIR DB Explorer.lnk" \
        "$INSTDIR\scripts\explore-db.bat" \
        "" \
        "$INSTDIR\python_portable\python.exe" \
        0
    
    ; Menu Démarrer
    CreateDirectory "$SMPROGRAMS\SFEIR School DBT"
    CreateShortcut "$SMPROGRAMS\SFEIR School DBT\DBT Terminal.lnk" \
        "$INSTDIR\scripts\dbt-shell.bat"
    CreateShortcut "$SMPROGRAMS\SFEIR School DBT\Workspace.lnk" \
        "$INSTDIR\workspace"
    CreateShortcut "$SMPROGRAMS\SFEIR School DBT\Explorateur DB.lnk" \
        "$INSTDIR\scripts\explore-db.bat"
    CreateShortcut "$SMPROGRAMS\SFEIR School DBT\Sauvegarder mon travail.lnk" \
        "$INSTDIR\scripts\backup-work.bat"
    CreateShortcut "$SMPROGRAMS\SFEIR School DBT\Documentation.lnk" \
        "$INSTDIR\docs\USAGE.md"
    CreateShortcut "$SMPROGRAMS\SFEIR School DBT\Désinstaller.lnk" \
        "$INSTDIR\uninstall.exe"
    
    ; Écrire les informations de désinstallation
    WriteRegStr HKCU "Software\${PRODUCT_NAME}" "InstallDir" "$INSTDIR"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayVersion" "${PRODUCT_VERSION}"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher" "${PRODUCT_PUBLISHER}"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoModify" 1
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoRepair" 1
    
    ; Créer le désinstallateur
    WriteUninstaller "$INSTDIR\uninstall.exe"
    
    ; Message final
    DetailPrint "Installation terminée avec succès !"
    
SectionEnd

; Description des sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "Installation complète de ${PRODUCT_NAME} avec Python portable, dbt et DuckDB."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Section de désinstallation
Section "Uninstall"
    ; Demander confirmation pour supprimer les données
    MessageBox MB_YESNO|MB_ICONQUESTION "Voulez-vous également supprimer vos projets et bases de données ?$\r$\n(Choisir Non gardera vos travaux)" IDYES RemoveData IDNO KeepData
    
    RemoveData:
        RMDir /r "$INSTDIR\workspace"
        Goto Continue
    
    KeepData:
        ; Créer une sauvegarde avant de désinstaller
        CreateDirectory "$DOCUMENTS\sfeir-dbt-backup"
        CopyFiles /SILENT "$INSTDIR\workspace\*.*" "$DOCUMENTS\sfeir-dbt-backup\"
        MessageBox MB_OK "Vos travaux ont été sauvegardés dans :$\r$\n$DOCUMENTS\sfeir-dbt-backup"
    
    Continue:
    ; Supprimer les fichiers de l'application
    Delete "$INSTDIR\uninstall.exe"
    RMDir /r "$INSTDIR\python_portable"
    RMDir /r "$INSTDIR\venv"
    RMDir /r "$INSTDIR\wheels"
    RMDir /r "$INSTDIR\scripts"
    RMDir /r "$INSTDIR\templates"
    RMDir /r "$INSTDIR\docs"
    
    ; Supprimer les raccourcis
    Delete "$DESKTOP\SFEIR DBT Terminal.lnk"
    Delete "$DESKTOP\SFEIR DBT Workspace.lnk"
    Delete "$DESKTOP\SFEIR DB Explorer.lnk"
    RMDir /r "$SMPROGRAMS\SFEIR School DBT"
    
    ; Supprimer le répertoire d'installation s'il est vide
    RMDir "$INSTDIR"
    
    ; Demander si on supprime la config dbt
    MessageBox MB_YESNO|MB_ICONQUESTION "Supprimer également la configuration dbt (~\.dbt\profiles.yml) ?" IDYES RemoveConfig IDNO KeepConfig
    
    RemoveConfig:
        Delete "$PROFILE\.dbt\profiles.yml"
        Goto EndConfig
    
    KeepConfig:
        ; Ne rien faire
    
    EndConfig:
    ; Supprimer les clés de registre
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
    DeleteRegKey HKCU "Software\${PRODUCT_NAME}"
    
    MessageBox MB_OK "Désinstallation terminée !"
    
SectionEnd
