# Setup Étudiant Local - Windows PowerShell
# Pas de droits admin requis

$ErrorActionPreference = "Stop"

Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  Setup Étudiant Local - SFEIR School DBT         ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Vérifier les prérequis
Write-Host "🔍 Vérification des prérequis..." -ForegroundColor Yellow

try {
    $null = docker --version
    Write-Host "✅ Docker trouvé" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker n'est pas installé" -ForegroundColor Red
    Write-Host "Installez Docker Desktop : https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

try {
    $null = docker-compose --version
    Write-Host "✅ Docker Compose trouvé" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Compose n'est pas installé" -ForegroundColor Red
    exit 1
}

try {
    $null = python --version
    Write-Host "✅ Python trouvé" -ForegroundColor Green
} catch {
    Write-Host "❌ Python n'est pas installé" -ForegroundColor Red
    Write-Host "Installez Python : https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Prérequis OK" -ForegroundColor Green
Write-Host ""

# Créer .env
if (-not (Test-Path ".env")) {
    Write-Host "📝 Création du fichier .env..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "✅ Fichier .env créé" -ForegroundColor Green
} else {
    Write-Host "ℹ️  .env existe déjà" -ForegroundColor Yellow
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
pip install -q -r requirements.txt
Write-Host "✅ dbt installé" -ForegroundColor Green
Write-Host ""

# Configurer dbt
$dbtDir = "$env:USERPROFILE\.dbt"
if (-not (Test-Path $dbtDir)) {
    New-Item -ItemType Directory -Path $dbtDir -Force | Out-Null
}

if (-not (Test-Path "$dbtDir\profiles.yml")) {
    Write-Host "📝 Création du profil dbt..." -ForegroundColor Yellow
    $profileContent = @"
sfeir_student:
  target: dev
  outputs:
    dev:
      type: postgres
      threads: 4
      host: localhost
      port: 5432
      user: student
      pass: student123
      dbname: sfeir_dbt
      schema: public
"@
    Set-Content -Path "$dbtDir\profiles.yml" -Value $profileContent
    Write-Host "✅ Profil dbt créé" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Profil dbt existe déjà" -ForegroundColor Yellow
}
Write-Host ""

# Démarrer PostgreSQL
Write-Host "🐳 Démarrage de PostgreSQL..." -ForegroundColor Yellow
docker-compose up -d
Write-Host "✅ PostgreSQL démarré" -ForegroundColor Green
Write-Host ""

# Attendre PostgreSQL
Write-Host "⏳ Attente de PostgreSQL..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Vérifier la connexion
Write-Host "🔗 Vérification de la connexion..." -ForegroundColor Yellow
docker exec sfeir-dbt-postgres-student pg_isready -U student

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ PostgreSQL prêt" -ForegroundColor Green
} else {
    Write-Host "❌ Problème de connexion" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Charger les données
if (Test-Path "..\..\shared\dbt-projects\starter") {
    Write-Host "📊 Chargement des données de démonstration..." -ForegroundColor Yellow
    Push-Location "..\..\shared\dbt-projects\starter"
    dbt seed --profiles-dir $dbtDir 2>$null
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
Write-Host "  User     : student"
Write-Host "  Password : student123"
Write-Host "  Database : sfeir_dbt"
Write-Host ""
Write-Host "Prochaines étapes :" -ForegroundColor Yellow
Write-Host "  1. Copier un projet : Copy-Item ..\..\shared\dbt-projects\starter .\mon-lab -Recurse"
Write-Host "  2. Aller dedans     : cd mon-lab"
Write-Host "  3. Tester           : dbt debug"
Write-Host "  4. Exécuter         : dbt run"
Write-Host ""
Write-Host "Commandes utiles :" -ForegroundColor Yellow
Write-Host "  make psql    # Se connecter à PostgreSQL"
Write-Host "  make test    # Tester dbt"
Write-Host "  make stop    # Arrêter PostgreSQL"
Write-Host ""
