param(
    [switch]$SkipDownload,
    [switch]$Verbose
)

# Force UTF-8 encoding for proper character display
$OutputEncoding = [System.Text.Encoding]::UTF8

<#
.SYNOPSIS
    Script de build de l'installateur SFEIR School DBT
    
.DESCRIPTION
    Ce script prépare tous les composants nécessaires et compile l'installateur NSIS.
    - Télécharge Python portable
    - Télécharge les wheels Python (dbt, duckdb, etc.)
    - Prépare la structure du workspace
    - Compile l'installateur avec NSIS
    
.NOTES
    Prérequis : NSIS installé (https://nsis.sourceforge.io/Download)
    Pour installer NSIS : choco install nsis (avec Chocolatey)
#>

$ErrorActionPreference = "Stop"

# Configuration
$PYTHON_VERSION = "3.11.9"
$PYTHON_URL = "https://www.python.org/ftp/python/$PYTHON_VERSION/python-$PYTHON_VERSION-embed-amd64.zip"
$BUILD_DIR = "build"
$WHEELS_DIR = "$BUILD_DIR\wheels"
$PYTHON_DIR = "$BUILD_DIR\python_portable"
$WORKSPACE_DIR = "$BUILD_DIR\workspace"

Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  Build Installateur SFEIR School DBT" -ForegroundColor Green
Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""

# Fonction pour télécharger un fichier
function Download-File {
    param(
        [string]$Url,
        [string]$Output
    )
    
    Write-Host "[DOWNLOAD] Téléchargement : $Output" -ForegroundColor Yellow
    
    if (Test-Path $Output) {
        Write-Host "   [OK] Déjà présent" -ForegroundColor Gray
        return
    }
    
    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $Url -OutFile $Output -UseBasicParsing
        Write-Host "   [OK] Téléchargé" -ForegroundColor Green
    }
    catch {
        Write-Host "   [ERROR] Erreur : $_" -ForegroundColor Red
        throw
    }
}

# Étape 1 : Créer la structure de build
Write-Host "[1/7] Création de la structure de build..." -ForegroundColor Cyan
if (Test-Path $BUILD_DIR) {
    Write-Host "   Nettoyage de l'ancien build..." -ForegroundColor Gray
    Remove-Item -Path $BUILD_DIR -Recurse -Force
}

New-Item -ItemType Directory -Path $BUILD_DIR -Force | Out-Null
New-Item -ItemType Directory -Path $WHEELS_DIR -Force | Out-Null
New-Item -ItemType Directory -Path $PYTHON_DIR -Force | Out-Null
New-Item -ItemType Directory -Path $WORKSPACE_DIR -Force | Out-Null
Write-Host "   [OK] Structure créée" -ForegroundColor Green

# Étape 2 : Télécharger Python portable
if (-not $SkipDownload) {
    Write-Host "[2/7] Téléchargement de Python portable..." -ForegroundColor Cyan
    $pythonZip = "$BUILD_DIR\python-embed.zip"
    Download-File -Url $PYTHON_URL -Output $pythonZip
    
    Write-Host "   Extraction de Python..." -ForegroundColor Yellow
    Expand-Archive -Path $pythonZip -DestinationPath $PYTHON_DIR -Force
    Remove-Item $pythonZip
    
    # Configurer Python pour permettre pip
    $pthFile = Get-ChildItem -Path $PYTHON_DIR -Filter "python*._pth" | Select-Object -First 1
    if ($pthFile) {
        $content = Get-Content $pthFile.FullName
        $content = $content -replace '#import site', 'import site'
        Set-Content -Path $pthFile.FullName -Value $content
        Write-Host "   [OK] Python configuré pour pip" -ForegroundColor Green
    }
    
    # Télécharger et installer get-pip
    Write-Host "   Installation de pip..." -ForegroundColor Yellow
    Download-File -Url "https://bootstrap.pypa.io/get-pip.py" -Output "$PYTHON_DIR\get-pip.py"
    & "$PYTHON_DIR\python.exe" "$PYTHON_DIR\get-pip.py" --no-warn-script-location
    Write-Host "   [OK] Python portable prêt" -ForegroundColor Green
}
else {
    Write-Host "[2/7] Téléchargement de Python ignoré (--SkipDownload)" -ForegroundColor Gray
}

# Étape 3 : Télécharger les wheels Python
if (-not $SkipDownload) {
    Write-Host "[3/7] Téléchargement des dépendances Python..." -ForegroundColor Cyan
    
    Write-Host "   Téléchargement des wheels..." -ForegroundColor Yellow
    
    # Utiliser pip directement depuis Python portable (venv n'est pas disponible en portable)
    & "$PYTHON_DIR\python.exe" -m pip download `
        dbt-core dbt-duckdb tabulate `
        --dest $WHEELS_DIR `
        --no-deps
    
    # Télécharger aussi toutes les dépendances
    & "$PYTHON_DIR\python.exe" -m pip download `
        dbt-core dbt-duckdb tabulate `
        --dest $WHEELS_DIR
    
    $wheelCount = (Get-ChildItem -Path $WHEELS_DIR -Filter "*.whl").Count
    Write-Host "   [OK] $wheelCount wheels téléchargés" -ForegroundColor Green
}
else {
    Write-Host "[3/7] Téléchargement des wheels ignoré (--SkipDownload)" -ForegroundColor Gray
}

# Étape 4 : Préparer le workspace
Write-Host "[4/7] Préparation du workspace..." -ForegroundColor Cyan

# Calculer les chemins depuis la racine du script
# Le script est dans: tools/etudiant/portable/installer/
# On remonte 3 niveaux pour arriver à tools/
$toolsDir = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))

# Copier le projet starter pour chaque lab
$labs = @(
    "lab-01-models",
    "lab-02-sources",
    "lab-03-tests",
    "lab-04-documentation",
    "lab-05-advanced"
)

$starterPath = Join-Path $toolsDir "shared\dbt-projects\starter"
$seedsPath = Join-Path $toolsDir "shared\data\seeds"

Write-Host "   [DEBUG] Tools directory: $toolsDir" -ForegroundColor Gray
Write-Host "   [DEBUG] Starter path: $starterPath" -ForegroundColor Gray

# Vérifier si le dossier starter existe
if (-not (Test-Path $starterPath)) {
    Write-Host "   [WARNING] Dossier starter non trouvé: $starterPath" -ForegroundColor Yellow
    Write-Host "   [WARNING] Création d'une structure vide..." -ForegroundColor Yellow
}

# Créer la structure du workspace
New-Item -ItemType Directory -Path "$WORKSPACE_DIR\labs" -Force | Out-Null
New-Item -ItemType Directory -Path "$WORKSPACE_DIR\my-work" -Force | Out-Null
New-Item -ItemType Directory -Path "$WORKSPACE_DIR\backups" -Force | Out-Null

foreach ($lab in $labs) {
    $labPath = "$WORKSPACE_DIR\labs\$lab"
    Write-Host "   Création de $lab..." -ForegroundColor Gray
    
    # Créer le dossier destination
    New-Item -ItemType Directory -Path $labPath -Force | Out-Null
    
    # Copier le projet starter si disponible
    if (Test-Path $starterPath) {
        Copy-Item -Path "$starterPath\*" -Destination $labPath -Recurse -Force
    }
    else {
        # Créer une structure minimale
        New-Item -ItemType Directory -Path "$labPath\models" -Force | Out-Null
        New-Item -ItemType Directory -Path "$labPath\tests" -Force | Out-Null
        New-Item -ItemType Directory -Path "$labPath\seeds" -Force | Out-Null
        New-Item -ItemType Directory -Path "$labPath\macros" -Force | Out-Null
        
        # Créer un fichier dbt_project.yml minimal
        $dbtProjectContent = @"
name: '$lab'
version: '1.0.0'
config-version: 2
profile: 'sfeir_student_portable'

model-paths: ['models']
test-paths: ['tests']
macro-paths: ['macros']
seed-paths: ['seeds']
"@
        Set-Content -Path "$labPath\dbt_project.yml" -Value $dbtProjectContent
    }
    
    # Copier les seeds si disponible
    if ((Test-Path "$labPath\seeds") -and (Test-Path $seedsPath)) {
        Copy-Item -Path "$seedsPath\*.csv" -Destination "$labPath\seeds\" -Force
    }
    
    # Modifier le dbt_project.yml pour utiliser le bon profil
    $dbtProjectPath = "$labPath\dbt_project.yml"
    if (Test-Path $dbtProjectPath) {
        $content = Get-Content $dbtProjectPath -Raw
        $content = $content -replace "profile: 'sfeir_trainer'", "profile: 'sfeir_student_portable'"
        Set-Content -Path $dbtProjectPath -Value $content
    }
    
    # Créer un README pour le lab
    $readmePath = "$labPath\README.md"
    $readmeContent = @"
# $lab

## Objectif
[À compléter selon le lab]

## Commandes utiles

``````bash
# Charger les données
dbt seed

# Exécuter les modèles
dbt run

# Lancer les tests
dbt test

# Tout faire en une fois
dbt build
``````

## Ressources
- [Documentation dbt](https://docs.getdbt.com)
- [Guide SFEIR](..\..\..\docs\USAGE.md)
"@
    Set-Content -Path $readmePath -Value $readmeContent
}

# Créer un README pour my-work
$myWorkReadme = @"
# Mon Espace de Travail

Cet espace est le vôtre ! Vous pouvez :
- Créer vos propres projets dbt
- Expérimenter librement
- Sauvegarder vos exercices personnels

## Pour démarrer un nouveau projet

Copiez le template starter :
``````bash
cp -r ..\labs\lab-01-models mon-nouveau-projet
cd mon-nouveau-projet
dbt run
``````
"@
Set-Content -Path "$WORKSPACE_DIR\my-work\README.md" -Value $myWorkReadme

Write-Host "   [OK] Workspace créé avec $($labs.Count) labs" -ForegroundColor Green

# Étape 4b : Copier les scripts et templates dans le build
Write-Host "[4b/7] Copie des scripts et templates..." -ForegroundColor Cyan

$SCRIPTS_BUILD_DIR = "$BUILD_DIR\scripts"
$TEMPLATES_BUILD_DIR = "$BUILD_DIR\templates"

New-Item -ItemType Directory -Path $SCRIPTS_BUILD_DIR -Force | Out-Null
New-Item -ItemType Directory -Path $TEMPLATES_BUILD_DIR -Force | Out-Null

# Copier les scripts
$scriptsSource = Join-Path $PSScriptRoot "..\scripts"
if (Test-Path $scriptsSource) {
    Copy-Item -Path "$scriptsSource\*" -Destination $SCRIPTS_BUILD_DIR -Force
    Write-Host "   [OK] Scripts copiés" -ForegroundColor Green
} else {
    Write-Host "   [WARNING] Dossier scripts non trouvé: $scriptsSource" -ForegroundColor Yellow
}

# Copier les templates
$templatesSource = Join-Path $PSScriptRoot "..\templates"
if (Test-Path $templatesSource) {
    Copy-Item -Path "$templatesSource\*" -Destination $TEMPLATES_BUILD_DIR -Force
    Write-Host "   [OK] Templates copiés" -ForegroundColor Green
} else {
    Write-Host "   [WARNING] Dossier templates non trouvé: $templatesSource" -ForegroundColor Yellow
}

# Étape 5 : Vérifier NSIS
Write-Host "[5/7] Vérification de NSIS..." -ForegroundColor Cyan
$nsisPath = "C:\Program Files (x86)\NSIS\makensis.exe"
if (-not (Test-Path $nsisPath)) {
    # Essayer dans Program Files
    $nsisPath = "C:\Program Files\NSIS\makensis.exe"
}

if (-not (Test-Path $nsisPath)) {
    Write-Host "   [ERROR] NSIS n'est pas installé" -ForegroundColor Red
    Write-Host "   Installez NSIS depuis : https://nsis.sourceforge.io/Download" -ForegroundColor Yellow
    Write-Host "   Ou avec Chocolatey : choco install nsis" -ForegroundColor Yellow
    exit 1
}
Write-Host "   [OK] NSIS trouvé : $nsisPath" -ForegroundColor Green

# Étape 6 : Compiler l'installateur
Write-Host "[6/7] Compilation de l'installateur..." -ForegroundColor Cyan
$nsisScript = "installer.nsi"

# Vérification des assets
Write-Host "   Vérification des assets..." -ForegroundColor Yellow
if (-not (Test-Path "assets")) {
    New-Item -ItemType Directory -Path "assets" -Force | Out-Null
}

# Utiliser le script NSIS existant (déjà corrigé pour installation sans admin)
Write-Host "   Utilisation du script NSIS existant..." -ForegroundColor Yellow

# Vérifier que le script NSIS existe
if (-not (Test-Path $nsisScript)) {
    Write-Host "   [ERROR] Script NSIS non trouvé : $nsisScript" -ForegroundColor Red
    Write-Host "   [INFO] Assurez-vous que installer.nsi existe dans le dossier installer/" -ForegroundColor Yellow
    exit 1
}
Write-Host "   [OK] Script NSIS trouvé" -ForegroundColor Green

Write-Host "   Lancement de makensis..." -ForegroundColor Yellow
& $nsisPath $nsisScript

if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] Erreur lors de la compilation NSIS" -ForegroundColor Red
    Write-Host "   [INFO] Cela peut être dû à des chemins manquants dans build/" -ForegroundColor Yellow
    Write-Host "   [INFO] Relancez sans --SkipDownload pour télécharger tous les fichiers" -ForegroundColor Yellow
    exit 1
}

$installerFile = "sfeir-dbt-installer.exe"
if (Test-Path $installerFile) {
    $size = [math]::Round((Get-Item $installerFile).Length / 1MB, 2)
    Write-Host "   [OK] Installateur créé : $installerFile ($size MB)" -ForegroundColor Green
}
else {
    Write-Host "   [ERROR] Installateur non trouvé après compilation" -ForegroundColor Red
    exit 1
}

# Étape 7 : Résumé
Write-Host ""
Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  [SUCCESS] Build terminé avec succès !" -ForegroundColor Green
Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "[PACKAGE] Installateur : $installerFile" -ForegroundColor Cyan
Write-Host "[STATS] Taille : $size MB" -ForegroundColor Cyan
Write-Host ""
Write-Host "[DEPLOY] Distribution :" -ForegroundColor Yellow
Write-Host "   * Par email (si < 25 MB)" -ForegroundColor Gray
Write-Host "   * Google Drive / OneDrive" -ForegroundColor Gray
Write-Host "   * Clé USB" -ForegroundColor Gray
Write-Host "   * Serveur intranet" -ForegroundColor Gray
Write-Host ""
Write-Host "Pour tester l'installation :" -ForegroundColor Yellow
Write-Host "   .\$installerFile" -ForegroundColor Cyan
Write-Host ""
