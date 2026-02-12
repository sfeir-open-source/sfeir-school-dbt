#!/bin/bash
# Bootstrap sans prérequis - Télécharge et installe Python portable puis dbt

set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Installation COMPLÈTE sans prérequis             ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Cette installation fonctionne SANS droits admin${NC}"
echo ""

# Détecter l'OS
OS="$(uname -s)"
ARCH="$(uname -m)"

echo -e "${GREEN}[1/6] Détection du système...${NC}"
echo "OS détecté : $OS"
echo "Architecture : $ARCH"

# Définir les URLs selon l'OS
PYTHON_DIR="python_portable"
PYTHON_EXEC=""

if [[ "$OS" == "Darwin" ]]; then
    # macOS - utiliser Miniforge (conda portable sans droits admin)
    echo -e "${GREEN}[2/6] Téléchargement de Miniforge pour macOS...${NC}"
    if [[ "$ARCH" == "arm64" ]]; then
        MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh"
    else
        MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh"
    fi
    
    if [ ! -d "$PYTHON_DIR" ]; then
        curl -L -o miniforge.sh "$MINIFORGE_URL"
        chmod +x miniforge.sh
        bash miniforge.sh -b -p "$PYTHON_DIR"
        rm miniforge.sh
        echo -e "${GREEN}✓ Miniforge installé dans $PYTHON_DIR${NC}"
    else
        echo -e "${GREEN}✓ Python portable déjà installé${NC}"
    fi
    
    PYTHON_EXEC="$PYTHON_DIR/bin/python"
    
elif [[ "$OS" == "Linux" ]]; then
    # Linux - utiliser Miniforge aussi
    echo -e "${GREEN}[2/6] Téléchargement de Miniforge pour Linux...${NC}"
    if [[ "$ARCH" == "aarch64" ]]; then
        MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh"
    else
        MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
    fi
    
    if [ ! -d "$PYTHON_DIR" ]; then
        wget -O miniforge.sh "$MINIFORGE_URL" || curl -L -o miniforge.sh "$MINIFORGE_URL"
        chmod +x miniforge.sh
        bash miniforge.sh -b -p "$PYTHON_DIR"
        rm miniforge.sh
        echo -e "${GREEN}✓ Miniforge installé dans $PYTHON_DIR${NC}"
    else
        echo -e "${GREEN}✓ Python portable déjà installé${NC}"
    fi
    
    PYTHON_EXEC="$PYTHON_DIR/bin/python"
else
    echo -e "${RED}❌ OS non supporté pour l'installation automatique${NC}"
    echo "Sur Windows, utilisez bootstrap.bat ou bootstrap.ps1"
    exit 1
fi

# Vérifier Python
echo -e "${GREEN}[3/6] Vérification de Python portable...${NC}"
if [ ! -f "$PYTHON_EXEC" ]; then
    echo -e "${RED}❌ Erreur : Python portable non trouvé${NC}"
    exit 1
fi

PYTHON_VERSION=$($PYTHON_EXEC --version 2>&1)
echo -e "${GREEN}✓ $PYTHON_VERSION${NC}"

# Créer environnement virtuel
echo -e "${GREEN}[4/6] Création de l'environnement virtuel...${NC}"
if [ ! -d "venv" ]; then
    $PYTHON_EXEC -m venv venv
    echo -e "${GREEN}✓ Environnement virtuel créé${NC}"
else
    echo -e "${GREEN}✓ Environnement virtuel déjà existant${NC}"
fi

# Installer dbt
echo -e "${GREEN}[5/6] Installation de dbt et DuckDB...${NC}"
source venv/bin/activate
pip install --upgrade pip > /dev/null 2>&1
pip install -r requirements.txt
echo -e "${GREEN}✓ dbt-duckdb installé${NC}"

# Configurer profil
echo -e "${GREEN}[6/6] Configuration du profil dbt...${NC}"
mkdir -p ~/.dbt
if [ ! -f ~/.dbt/profiles.yml ]; then
    cp profiles.yml.example ~/.dbt/profiles.yml
    echo -e "${GREEN}✓ Profil dbt créé${NC}"
else
    if ! grep -q "sfeir_student_portable" ~/.dbt/profiles.yml; then
        echo "" >> ~/.dbt/profiles.yml
        cat profiles.yml.example >> ~/.dbt/profiles.yml
        echo -e "${GREEN}✓ Profil sfeir_student_portable ajouté${NC}"
    else
        echo -e "${GREEN}✓ Profil déjà configuré${NC}"
    fi
fi

# Charger les seeds
if [ -d "../../shared/data/seeds" ]; then
    echo ""
    echo -e "${YELLOW}📋 Chargement des données initiales...${NC}"
    mkdir -p ../../shared/dbt-projects/starter/seeds
    cp ../../shared/data/seeds/*.csv ../../shared/dbt-projects/starter/seeds/ 2>/dev/null || true
    cd ../../shared/dbt-projects/starter
    ../../../etudiant/portable/venv/bin/dbt seed --profile sfeir_student_portable
    cd ../../../etudiant/portable
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║       ✅ Installation complète terminée !          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Python portable installé dans : $PYTHON_DIR${NC}"
echo -e "${GREEN}Base de données : ../../shared/dbt-projects/starter/sfeir_dbt.duckdb${NC}"
echo ""
echo -e "${YELLOW}Pour utiliser :${NC}"
echo "  source venv/bin/activate"
echo "  make dbt-run"
echo ""
echo -e "${GREEN}✓ Aucun droit administrateur requis !${NC}"
