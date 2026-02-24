<#
.SYNOPSIS
    Script de vérification de l'installation SFEIR School DBT
    
.DESCRIPTION
    Ce script vérifie que tous les composants ont été correctement installés.
    À exécuter après l'installation pour valider la configuration.
#>

Write-Host ""
Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Vérification de l'installation SFEIR School DBT" -ForegroundColor Cyan
Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$installDir = "$env:USERPROFILE\Documents\sfeir-school-dbt"
$errors = 0

# Fonction de vérification
function Test-Component {
    param(
        [string]$Name,
        [string]$Path,
        [switch]$IsFile
    )
    
    if ($IsFile) {
        $exists = Test-Path $Path -PathType Leaf
    }
    else {
        $exists = Test-Path $Path -PathType Container
    }
    
    if ($exists) {
        Write-Host "[OK] $Name" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "[ERREUR] $Name non trouvé: $Path" -ForegroundColor Red
        return $false
    }
}

Write-Host "[1/5] Vérification du dossier d'installation..." -ForegroundColor Yellow
if (-not (Test-Component "Dossier principal" $installDir)) {
    Write-Host ""
    Write-Host "ERREUR: L'installation n'a pas été trouvée dans:" -ForegroundColor Red
    Write-Host "  $installDir" -ForegroundColor Red
    Write-Host ""
    Write-Host "Assurez-vous d'avoir exécuté l'installateur." -ForegroundColor Yellow
    exit 1
}
Write-Host ""

Write-Host "[2/5] Vérification de la structure..." -ForegroundColor Yellow
$components = @(
    @{Name="Python portable"; Path="$installDir\python"; IsFile=$false},
    @{Name="Wheels Python"; Path="$installDir\wheels"; IsFile=$false},
    @{Name="Workspace"; Path="$installDir\workspace"; IsFile=$false},
    @{Name="Labs"; Path="$installDir\workspace\labs"; IsFile=$false},
    @{Name="Scripts"; Path="$installDir\scripts"; IsFile=$false}
)

foreach ($comp in $components) {
    if (-not (Test-Component $comp.Name $comp.Path)) {
        $errors++
    }
}
Write-Host ""

Write-Host "[3/5] Vérification des fichiers clés..." -ForegroundColor Yellow
$files = @(
    @{Name="Python.exe"; Path="$installDir\python\python.exe"; IsFile=$true},
    @{Name="dbt-shell.bat"; Path="$installDir\dbt-shell.bat"; IsFile=$true},
    @{Name="setup-env.bat"; Path="$installDir\setup-env.bat"; IsFile=$true},
    @{Name="profiles.yml"; Path="$installDir\profiles.yml"; IsFile=$true}
)

foreach ($file in $files) {
    if (-not (Test-Component $file.Name $file.Path -IsFile)) {
        $errors++
    }
}
Write-Host ""

Write-Host "[4/5] Vérification de l'environnement virtuel..." -ForegroundColor Yellow
$venvPath = "$installDir\venv"
if (Test-Path $venvPath) {
    Write-Host "[OK] Environnement virtuel créé" -ForegroundColor Green
    
    # Vérifier dbt
    $dbtPath = "$venvPath\Scripts\dbt.exe"
    if (Test-Path $dbtPath) {
        Write-Host "[OK] dbt installé" -ForegroundColor Green
        
        # Tester dbt --version
        Write-Host ""
        Write-Host "   Version de dbt:" -ForegroundColor Gray
        & "$venvPath\Scripts\activate.ps1"
        $dbtVersion = & dbt --version 2>$null | Select-Object -First 3
        foreach ($line in $dbtVersion) {
            Write-Host "   $line" -ForegroundColor Gray
        }
    }
    else {
        Write-Host "[ERREUR] dbt.exe non trouvé" -ForegroundColor Red
        $errors++
    }
}
else {
    Write-Host "[INFO] Environnement non encore créé" -ForegroundColor Yellow
    Write-Host "       Lancez dbt-shell.bat pour l'initialiser" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "[5/5] Vérification du profil dbt..." -ForegroundColor Yellow
$profilePath = "$env:USERPROFILE\.dbt\profiles.yml"
if (Test-Path $profilePath) {
    Write-Host "[OK] Profil dbt configuré" -ForegroundColor Green
    
    # Vérifier le contenu
    $content = Get-Content $profilePath -Raw
    if ($content -match "sfeir_student_portable") {
        Write-Host "[OK] Profil sfeir_student_portable présent" -ForegroundColor Green
    }
    else {
        Write-Host "[WARNING] Le profil sfeir_student_portable n'est pas dans profiles.yml" -ForegroundColor Yellow
    }
}
else {
    Write-Host "[INFO] Profil non encore copié" -ForegroundColor Yellow
    Write-Host "       Sera créé au premier lancement" -ForegroundColor Yellow
}
Write-Host ""

# Résumé
Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Cyan
if ($errors -eq 0) {
    Write-Host "  [SUCCESS] Installation vérifiée avec succès !" -ForegroundColor Green
    Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Pour commencer:" -ForegroundColor Yellow
    Write-Host "  1. Double-cliquez sur 'SFEIR DBT Shell' sur le Bureau" -ForegroundColor White
    Write-Host "  2. Ou lancez: $installDir\dbt-shell.bat" -ForegroundColor White
    Write-Host ""
}
else {
    Write-Host "  [ERREUR] $errors problème(s) détecté(s)" -ForegroundColor Red
    Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Actions suggérées:" -ForegroundColor Yellow
    Write-Host "  1. Réexécutez l'installateur" -ForegroundColor White
    Write-Host "  2. Vérifiez les permissions sur le dossier Documents" -ForegroundColor White
    Write-Host ""
}
