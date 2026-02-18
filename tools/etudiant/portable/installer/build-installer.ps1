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

param(
    [switch]$SkipDownload = $false,
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Stop"

# Configuration
$PYTHON_VERSION = "3.11.9"
$PYTHON_URL = "https://www.python.org/ftp/python/$PYTHON_VERSION/python-$PYTHON_VERSION-embed-amd64.zip"
$BUILD_DIR = "build"
$WHEELS_DIR = "$BUILD_DIR\wheels"
$PYTHON_DIR = "$BUILD_DIR\python_portable"
$WORKSPACE_DIR = "$BUILD_DIR\workspace"

Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  Build Installateur SFEIR School DBT             ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Fonction pour télécharger un fichier
function Download-File {
    param(
        [string]$Url,
        [string]$Output
    )
    
    Write-Host "⬇️  Téléchargement : $Output" -ForegroundColor Yellow
    
    if (Test-Path $Output) {
        Write-Host "   ✓ Déjà présent" -ForegroundColor Gray
        return
    }
    
    try {
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $Url -OutFile $Output -UseBasicParsing
        Write-Host "   ✓ Téléchargé" -ForegroundColor Green
    }
    catch {
        Write-Host "   ❌ Erreur : $_" -ForegroundColor Red
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
Write-Host "   ✓ Structure créée" -ForegroundColor Green

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
        Write-Host "   ✓ Python configuré pour pip" -ForegroundColor Green
    }
    
    # Télécharger et installer get-pip
    Write-Host "   Installation de pip..." -ForegroundColor Yellow
    Download-File -Url "https://bootstrap.pypa.io/get-pip.py" -Output "$PYTHON_DIR\get-pip.py"
    & "$PYTHON_DIR\python.exe" "$PYTHON_DIR\get-pip.py" --no-warn-script-location
    Write-Host "   ✓ Python portable prêt" -ForegroundColor Green
}
else {
    Write-Host "[2/7] Téléchargement de Python ignoré (--SkipDownload)" -ForegroundColor Gray
}

# Étape 3 : Télécharger les wheels Python
if (-not $SkipDownload) {
    Write-Host "[3/7] Téléchargement des dépendances Python..." -ForegroundColor Cyan
    
    # Créer un venv temporaire pour télécharger les wheels
    $tempVenv = "$BUILD_DIR\temp_venv"
    & "$PYTHON_DIR\python.exe" -m venv $tempVenv
    
    Write-Host "   Téléchargement des wheels..." -ForegroundColor Yellow
    & "$tempVenv\Scripts\pip.exe" download `
        dbt-core dbt-duckdb tabulate `
        --dest $WHEELS_DIR `
        --no-deps
    
    # Télécharger aussi toutes les dépendances
    & "$tempVenv\Scripts\pip.exe" download `
        dbt-core dbt-duckdb tabulate `
        --dest $WHEELS_DIR
    
    Remove-Item -Path $tempVenv -Recurse -Force
    
    $wheelCount = (Get-ChildItem -Path $WHEELS_DIR -Filter "*.whl").Count
    Write-Host "   ✓ $wheelCount wheels téléchargés" -ForegroundColor Green
}
else {
    Write-Host "[3/7] Téléchargement des wheels ignoré (--SkipDownload)" -ForegroundColor Gray
}

# Étape 4 : Préparer le workspace
Write-Host "[4/7] Préparation du workspace..." -ForegroundColor Cyan

# Copier le projet starter pour chaque lab
$labs = @(
    "lab-01-models",
    "lab-02-sources",
    "lab-03-tests",
    "lab-04-documentation",
    "lab-05-advanced"
)

$starterPath = "..\..\..\..\shared\dbt-projects\starter"
$seedsPath = "..\..\..\..\shared\data\seeds"

# Créer la structure du workspace
New-Item -ItemType Directory -Path "$WORKSPACE_DIR\labs" -Force | Out-Null
New-Item -ItemType Directory -Path "$WORKSPACE_DIR\my-work" -Force | Out-Null
New-Item -ItemType Directory -Path "$WORKSPACE_DIR\backups" -Force | Out-Null

foreach ($lab in $labs) {
    $labPath = "$WORKSPACE_DIR\labs\$lab"
    Write-Host "   Création de $lab..." -ForegroundColor Gray
    
    # Copier le projet starter
    Copy-Item -Path "$starterPath\*" -Destination $labPath -Recurse -Force
    
    # Copier les seeds
    if (Test-Path "$labPath\seeds") {
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

Write-Host "   ✓ Workspace créé avec $($labs.Count) labs" -ForegroundColor Green

# Étape 5 : Vérifier NSIS
Write-Host "[5/7] Vérification de NSIS..." -ForegroundColor Cyan
$nsisPath = "C:\Program Files (x86)\NSIS\makensis.exe"
if (-not (Test-Path $nsisPath)) {
    # Essayer dans Program Files
    $nsisPath = "C:\Program Files\NSIS\makensis.exe"
}

if (-not (Test-Path $nsisPath)) {
    Write-Host "   ❌ NSIS n'est pas installé" -ForegroundColor Red
    Write-Host "   Installez NSIS depuis : https://nsis.sourceforge.io/Download" -ForegroundColor Yellow
    Write-Host "   Ou avec Chocolatey : choco install nsis" -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✓ NSIS trouvé : $nsisPath" -ForegroundColor Green

# Étape 6 : Compiler l'installateur
Write-Host "[6/7] Compilation de l'installateur..." -ForegroundColor Cyan
$nsisScript = "installer.nsi"

if (-not (Test-Path $nsisScript)) {
    Write-Host "   ❌ Script NSIS non trouvé : $nsisScript" -ForegroundColor Red
    exit 1
}

Write-Host "   Lancement de makensis..." -ForegroundColor Yellow
& $nsisPath $nsisScript

if ($LASTEXITCODE -ne 0) {
    Write-Host "   ❌ Erreur lors de la compilation" -ForegroundColor Red
    exit 1
}

$installerFile = "sfeir-dbt-installer.exe"
if (Test-Path $installerFile) {
    $size = [math]::Round((Get-Item $installerFile).Length / 1MB, 2)
    Write-Host "   ✓ Installateur créé : $installerFile ($size MB)" -ForegroundColor Green
}
else {
    Write-Host "   ❌ Installateur non trouvé après compilation" -ForegroundColor Red
    exit 1
}

# Étape 7 : Résumé
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          ✅ Build terminé avec succès !            ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "📦 Installateur : $installerFile" -ForegroundColor Cyan
Write-Host "📊 Taille : $size MB" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Distribution :" -ForegroundColor Yellow
Write-Host "   • Par email (si < 25 MB)" -ForegroundColor Gray
Write-Host "   • Google Drive / OneDrive" -ForegroundColor Gray
Write-Host "   • Clé USB" -ForegroundColor Gray
Write-Host "   • Serveur intranet" -ForegroundColor Gray
Write-Host ""
Write-Host "Pour tester l'installation :" -ForegroundColor Yellow
Write-Host "   .\$installerFile" -ForegroundColor Cyan
Write-Host ""
