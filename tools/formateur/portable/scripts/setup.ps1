# SFEIR School DBT - Setup Formateur Portable (PowerShell)
# Mode portable : Installation sans Docker

Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SFEIR School DBT - Setup Formateur Portable     ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Mode portable : Installation sans Docker" -ForegroundColor Yellow
Write-Host ""

# 1. Vérifier Python
Write-Host "[1/5] Vérification de Python..." -ForegroundColor Green
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ $pythonVersion trouvé" -ForegroundColor Green
} catch {
    Write-Host "❌ Python n'est pas installé" -ForegroundColor Red
    Write-Host "Installez Python 3.8+ depuis https://www.python.org/" -ForegroundColor Yellow
    exit 1
}

# 2. Créer l'environnement virtuel
Write-Host "[2/5] Création de l'environnement virtuel..." -ForegroundColor Green
if (-Not (Test-Path "venv")) {
    python -m venv venv
    Write-Host "✓ Environnement virtuel créé" -ForegroundColor Green
} else {
    Write-Host "✓ Environnement virtuel déjà existant" -ForegroundColor Green
}

# 3. Installer les dépendances
Write-Host "[3/5] Installation de dbt et DuckDB..." -ForegroundColor Green
& "venv\Scripts\Activate.ps1"
python -m pip install --upgrade pip | Out-Null
pip install -r requirements.txt
Write-Host "✓ dbt-duckdb installé" -ForegroundColor Green

# 4. Configurer le profil dbt
Write-Host "[4/5] Configuration du profil dbt..." -ForegroundColor Green
$dbtDir = "$env:USERPROFILE\.dbt"
if (-Not (Test-Path $dbtDir)) {
    New-Item -ItemType Directory -Path $dbtDir | Out-Null
}

$profilePath = "$dbtDir\profiles.yml"
if (-Not (Test-Path $profilePath)) {
    Copy-Item "profiles.yml.example" $profilePath
    Write-Host "✓ Profil dbt créé dans $profilePath" -ForegroundColor Green
} else {
    $content = Get-Content $profilePath -Raw
    if (-Not ($content -match "sfeir_trainer_portable")) {
        Add-Content $profilePath "`n"
        Get-Content "profiles.yml.example" | Add-Content $profilePath
        Write-Host "✓ Profil sfeir_trainer_portable ajouté" -ForegroundColor Green
    } else {
        Write-Host "✓ Profil sfeir_trainer_portable déjà présent" -ForegroundColor Green
    }
}

# 5. Initialiser la base de données
Write-Host "[5/5] Initialisation de la base de données DuckDB..." -ForegroundColor Green
$seedsDir = "..\..\shared\dbt-projects\starter\seeds"
if (-Not (Test-Path $seedsDir)) {
    New-Item -ItemType Directory -Path $seedsDir -Force | Out-Null
}

if (Test-Path "..\..\shared\data\seeds\*.csv") {
    Write-Host "📋 Copie des seeds..." -ForegroundColor Yellow
    Copy-Item "..\..\shared\data\seeds\*.csv" $seedsDir -Force -ErrorAction SilentlyContinue
}

Write-Host "🌱 Chargement des seeds avec dbt..." -ForegroundColor Yellow
Push-Location "..\..\shared\dbt-projects\starter"
& "..\..\..\formateur\portable\venv\Scripts\dbt.exe" seed --profiles-dir $dbtDir --profile sfeir_trainer_portable
Pop-Location

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              ✅ Installation terminée !            ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Base de données : ..\..\shared\dbt-projects\starter\sfeir_dbt.duckdb" -ForegroundColor Green
Write-Host ""
Write-Host "Prochaines étapes :" -ForegroundColor Yellow
Write-Host "  • Tester dbt        : make test (ou voir README)"
Write-Host "  • Charger les seeds : make dbt-seed"
Write-Host "  • Lancer les modèles: make dbt-run"
Write-Host ""
Write-Host "✓ Aucun Docker requis, tout est portable !" -ForegroundColor Green
