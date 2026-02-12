#!/bin/bash
set -e

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  SFEIR School DBT - Setup Formateur Portable     ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}🚀 Mode portable : Installation sans Docker${NC}"
echo ""

# 1. Vérifier Python
echo -e "${GREEN}[1/5] Vérification de Python...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 n'est pas installé${NC}"
    echo "Installez Python 3.8+ depuis https://www.python.org/"
    exit 1
fi
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo -e "${GREEN}✓ Python ${PYTHON_VERSION} trouvé${NC}"

# 2. Créer l'environnement virtuel
echo -e "${GREEN}[2/5] Création de l'environnement virtuel...${NC}"
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo -e "${GREEN}✓ Environnement virtuel créé${NC}"
else
    echo -e "${GREEN}✓ Environnement virtuel déjà existant${NC}"
fi

# 3. Activer et installer les dépendances
echo -e "${GREEN}[3/5] Installation de dbt et DuckDB...${NC}"
source venv/bin/activate
pip install --upgrade pip > /dev/null 2>&1
pip install -r requirements.txt
echo -e "${GREEN}✓ dbt-duckdb $(dbt --version | head -1 | cut -d':' -f2) installé${NC}"

# 4. Configurer le profil dbt
echo -e "${GREEN}[4/5] Configuration du profil dbt...${NC}"
mkdir -p ~/.dbt
if [ ! -f ~/.dbt/profiles.yml ]; then
    cp profiles.yml.example ~/.dbt/profiles.yml
    echo -e "${GREEN}✓ Profil dbt créé dans ~/.dbt/profiles.yml${NC}"
else
    if ! grep -q "sfeir_trainer_portable" ~/.dbt/profiles.yml; then
        echo "" >> ~/.dbt/profiles.yml
        cat profiles.yml.example >> ~/.dbt/profiles.yml
        echo -e "${GREEN}✓ Profil sfeir_trainer_portable ajouté à ~/.dbt/profiles.yml${NC}"
    else
        echo -e "${GREEN}✓ Profil sfeir_trainer_portable déjà présent${NC}"
    fi
fi

# 5. Initialiser la base de données
echo -e "${GREEN}[5/5] Initialisation de la base de données DuckDB...${NC}"
mkdir -p ../../shared/dbt-projects/starter/seeds

# Copier les seeds s'ils existent
if [ -d "../../shared/data/seeds" ]; then
    echo -e "${YELLOW}📋 Copie des seeds...${NC}"
    cp ../../shared/data/seeds/*.csv ../../shared/dbt-projects/starter/seeds/ 2>/dev/null || true
fi

# Charger les seeds avec dbt
cd ../../shared/dbt-projects/starter
echo -e "${YELLOW}🌱 Chargement des seeds avec dbt...${NC}"
../../../formateur/portable/venv/bin/dbt seed --profiles-dir ~/.dbt --profile sfeir_trainer_portable

cd ../../../formateur/portable

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✅ Installation terminée !            ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}📊 Base de données : ../../shared/dbt-projects/starter/sfeir_dbt.duckdb${NC}"
echo ""
echo -e "${YELLOW}Prochaines étapes :${NC}"
echo "  • Tester dbt       : make test"
echo "  • Charger les seeds: make dbt-seed"
echo "  • Lancer les modèles: make dbt-run"
echo "  • Mode interactif  : make dbt-shell"
echo ""
echo -e "${GREEN}✓ Aucun Docker requis, tout est portable !${NC}"
