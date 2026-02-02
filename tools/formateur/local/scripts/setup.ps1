# Setup Formateur Local - Windows PowerShell
# Compatible PowerShell Core (pas de droits admin requis)

$ErrorActionPreference = "Stop"

Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  Setup Formateur Local - SFEIR School DBT        ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Vérifier les prérequis
Write-Host "🔍 Vérification des prérequis..." -ForegroundColor Yellow

# Vérifier Docker
try {
    $null = docker --version
    Write-Host "✅ Docker trouvé" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker n'est pas installé" -ForegroundColor Red
    Write-Host "Installez Docker Desktop depuis : https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Vérifier Docker Compose
try {
    $null = docker-compose --version
    Write-Host "✅ Docker Compose trouvé" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Compose n'est pas installé" -ForegroundColor Red
    exit 1
}

# Vérifier Python
try {
    $null = python --version
    Write-Host "✅ Python trouvé" -ForegroundColor Green
} catch {
    Write-Host "❌ Python n'est pas installé" -ForegroundColor Red
    Write-Host "Installez Python depuis : https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Créer le fichier .env
if (-not (Test-Path ".env")) {
    Write-Host "📝 Création du fichier .env..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "✅ Fichier .env créé" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Le fichier .env existe déjà" -ForegroundColor Yellow
}
Write-Host ""

# Installer dbt
Write-Host "📦 Installation de dbt dans un environnement virtuel..." -ForegroundColor Yellow
if (-not (Test-Path "venv")) {
    Write-Host "Création du venv..."
    python -m venv venv
}
& .\venv\Scripts\Activate.ps1
pip install -U pip -q
pip install -q dbt-postgres==1.7.3
Write-Host "✅ dbt installé" -ForegroundColor Green
Write-Host ""

# Créer le répertoire de configuration dbt
$dbtDir = "$env:USERPROFILE\.dbt"
if (-not (Test-Path $dbtDir)) {
    New-Item -ItemType Directory -Path $dbtDir -Force | Out-Null
}

if (-not (Test-Path "$dbtDir\profiles.yml")) {
    Write-Host "📝 Création du fichier profiles.yml..." -ForegroundColor Yellow
    $profileContent = @"
sfeir_trainer:
  target: dev
  outputs:
    dev:
      type: postgres
      threads: 4
      host: localhost
      port: 5432
      user: dbt_trainer
      pass: dbt_password
      dbname: sfeir_dbt
      schema: public
"@
    Set-Content -Path "$dbtDir\profiles.yml" -Value $profileContent
    Write-Host "✅ Fichier profiles.yml créé" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Le fichier profiles.yml existe déjà" -ForegroundColor Yellow
}
Write-Host ""

# Démarrer les services Docker
Write-Host "🐳 Démarrage de PostgreSQL..." -ForegroundColor Yellow
docker-compose up -d
Write-Host "✅ PostgreSQL démarré" -ForegroundColor Green
Write-Host ""

# Attendre que PostgreSQL soit prêt
Write-Host "⏳ Attente que PostgreSQL soit prêt..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Vérifier la connexion
Write-Host "🔗 Vérification de la connexion..." -ForegroundColor Yellow
docker exec sfeir-dbt-postgres pg_isready -U dbt_trainer

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ PostgreSQL est prêt" -ForegroundColor Green
} else {
    Write-Host "❌ Impossible de se connecter à PostgreSQL" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Charger les seeds
if (Test-Path "..\..\shared\dbt-projects\demo") {
    Write-Host "📊 Chargement des données de démonstration..." -ForegroundColor Yellow
    Push-Location "..\..\shared\dbt-projects\demo"
    dbt seed --profiles-dir $dbtDir
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Données chargées" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Erreur lors du chargement des données" -ForegroundColor Yellow
    }
    Pop-Location
    Write-Host ""
}

# Résumé
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          Installation terminée ! 🎉               ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Informations de connexion :" -ForegroundColor Yellow
Write-Host "  Host     : localhost"
Write-Host "  Port     : 5432"
Write-Host "  User     : dbt_trainer"
Write-Host "  Password : dbt_password"
Write-Host "  Database : sfeir_dbt"
Write-Host ""
Write-Host "Commandes utiles :" -ForegroundColor Yellow
Write-Host "  make psql      # Se connecter à PostgreSQL"
Write-Host "  make test      # Tester dbt"
Write-Host "  make dbt-run   # Exécuter les modèles"
Write-Host "  make logs      # Voir les logs"
Write-Host "  make stop      # Arrêter les services"
Write-Host ""
