# Bootstrap PowerShell sans prérequis - Télécharge Python portable puis dbt

Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  Installation COMPLÈTE sans prérequis (Windows)   ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Cette installation fonctionne SANS droits admin" -ForegroundColor Yellow
Write-Host ""

# Détecter l'architecture
$arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "win32" }
Write-Host "[1/6] Détection du système..." -ForegroundColor Green
Write-Host "Architecture : $arch"

# Configuration
$pythonDir = "python_portable"
$pythonZip = "python-embed.zip"
$pythonUrl = "https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-$arch.zip"

# Télécharger Python embeddable si pas présent
if (-Not (Test-Path $pythonDir)) {
    Write-Host "[2/6] Téléchargement de Python portable..." -ForegroundColor Green
    Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonZip
    
    Write-Host "[3/6] Extraction de Python portable..." -ForegroundColor Green
    Expand-Archive -Path $pythonZip -DestinationPath $pythonDir -Force
    Remove-Item $pythonZip
    
    # Installer pip
    Write-Host "Installation de pip..." -ForegroundColor Yellow
    Push-Location $pythonDir
    Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "get-pip.py"
    
    # Décommenter les imports dans python311._pth
    $pthFile = Get-ChildItem -Filter "python*._pth" | Select-Object -First 1
    if ($pthFile) {
        (Get-Content $pthFile.FullName) -replace '#import site', 'import site' | Set-Content $pthFile.FullName
    }
    
    & ".\python.exe" "get-pip.py"
    Pop-Location
    
    Write-Host "✓ Python portable installé dans $pythonDir" -ForegroundColor Green
} else {
    Write-Host "[2/6] Python portable déjà installé" -ForegroundColor Green
}

# Vérifier Python
Write-Host "[3/6] Vérification de Python portable..." -ForegroundColor Green
$pythonExe = Join-Path $pythonDir "python.exe"
$version = & $pythonExe --version 2>&1
Write-Host "✓ $version" -ForegroundColor Green

# Créer environnement virtuel
Write-Host "[4/6] Création de l'environnement virtuel..." -ForegroundColor Green
if (-Not (Test-Path "venv")) {
    & $pythonExe -m venv venv
    Write-Host "✓ Environnement virtuel créé" -ForegroundColor Green
} else {
    Write-Host "✓ Environnement virtuel déjà existant" -ForegroundColor Green
}

# Installer dbt
Write-Host "[5/6] Installation de dbt et DuckDB..." -ForegroundColor Green
& "venv\Scripts\Activate.ps1"
python -m pip install --upgrade pip | Out-Null
pip install -r requirements.txt
Write-Host "✓ dbt-duckdb installé" -ForegroundColor Green

# Configurer profil
Write-Host "[6/6] Configuration du profil dbt..." -ForegroundColor Green
$dbtDir = "$env:USERPROFILE\.dbt"
if (-Not (Test-Path $dbtDir)) {
    New-Item -ItemType Directory -Path $dbtDir | Out-Null
}

$profilePath = "$dbtDir\profiles.yml"
if (-Not (Test-Path $profilePath)) {
    Copy-Item "profiles.yml.example" $profilePath
    Write-Host "✓ Profil dbt créé" -ForegroundColor Green
} else {
    $content = Get-Content $profilePath -Raw
    if (-Not ($content -match "sfeir_trainer_portable")) {
        Add-Content $profilePath "`n"
        Get-Content "profiles.yml.example" | Add-Content $profilePath
        Write-Host "✓ Profil sfeir_trainer_portable ajouté" -ForegroundColor Green
    } else {
        Write-Host "✓ Profil déjà configuré" -ForegroundColor Green
    }
}

# Charger les seeds
if (Test-Path "..\..\shared\data\seeds\*.csv") {
    Write-Host ""
    Write-Host "📋 Chargement des données initiales..." -ForegroundColor Yellow
    $seedsDir = "..\..\shared\dbt-projects\starter\seeds"
    if (-Not (Test-Path $seedsDir)) {
        New-Item -ItemType Directory -Path $seedsDir -Force | Out-Null
    }
    Copy-Item "..\..\shared\data\seeds\*.csv" $seedsDir -Force -ErrorAction SilentlyContinue
    
    Push-Location "..\..\shared\dbt-projects\starter"
    & "..\..\..\formateur\portable\venv\Scripts\dbt.exe" seed --profile sfeir_trainer_portable
    Pop-Location
}

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║       ✅ Installation complète terminée !          ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Python portable installé dans : $pythonDir" -ForegroundColor Green
Write-Host "Base de données : ..\..\shared\dbt-projects\starter\sfeir_dbt.duckdb" -ForegroundColor Green
Write-Host ""
Write-Host "Pour utiliser :" -ForegroundColor Yellow
Write-Host "  venv\Scripts\Activate.ps1"
Write-Host "  (puis utiliser les commandes dbt)"
Write-Host ""
Write-Host "✓ Aucun droit administrateur requis !" -ForegroundColor Green
