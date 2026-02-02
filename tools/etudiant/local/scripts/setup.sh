#!/bin/bash

# Script de setup étudiant - Pas de droits admin requis

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Setup Étudiant Local - SFEIR School DBT         ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""

# Vérifier les prérequis
echo -e "${YELLOW}🔍 Vérification des prérequis...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker n'est pas installé${NC}"
    echo "Installez Docker Desktop : https://www.docker.com/products/docker-desktop"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose n'est pas installé${NC}"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 n'est pas installé${NC}"
    echo "Installez Python depuis : https://www.python.org/downloads/"
    exit 1
fi

echo -e "${GREEN}✅ Prérequis OK${NC}"
echo ""

# Créer .env
if [ ! -f .env ]; then
    echo -e "${YELLOW}📝 Création du fichier .env...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✅ Fichier .env créé${NC}"
else
    echo -e "${YELLOW}ℹ️  .env existe déjà${NC}"
fi
echo ""

# Installer dbt
echo -e "${YELLOW}📦 Installation de dbt dans un environnement virtuel...${NC}"
if [ ! -d "venv" ]; then
    echo "Création du venv..."
    python3 -m venv venv
fi
source venv/bin/activate
pip install -U pip -q
pip install -q -r requirements.txt
echo -e "${GREEN}✅ dbt installé${NC}"
echo ""

# Configurer dbt
mkdir -p ~/.dbt
if [ ! -f ~/.dbt/profiles.yml ]; then
    echo -e "${YELLOW}📝 Création du profil dbt...${NC}"
    cat > ~/.dbt/profiles.yml <<EOF
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
EOF
    echo -e "${GREEN}✅ Profil dbt créé${NC}"
else
    echo -e "${YELLOW}ℹ️  Profil dbt existe déjà${NC}"
fi
echo ""

# Démarrer PostgreSQL
echo -e "${YELLOW}🐳 Démarrage de PostgreSQL...${NC}"
docker-compose up -d
echo -e "${GREEN}✅ PostgreSQL démarré${NC}"
echo ""

# Attendre PostgreSQL
echo -e "${YELLOW}⏳ Attente de PostgreSQL...${NC}"
sleep 10

# Vérifier la connexion
echo -e "${YELLOW}🔗 Vérification de la connexion...${NC}"
docker exec sfeir-dbt-postgres-student pg_isready -U student

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ PostgreSQL prêt${NC}"
else
    echo -e "${RED}❌ Problème de connexion${NC}"
    exit 1
fi
echo ""

# Charger les données
if [ -d "../../shared/dbt-projects/starter" ]; then
    echo -e "${YELLOW}📊 Chargement des données de démonstration...${NC}"
    cd ../../shared/dbt-projects/starter
    dbt seed --profiles-dir ~/.dbt 2>/dev/null || true
    cd -
    echo ""
fi

# Résumé
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Installation terminée ! 🎉               ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Informations de connexion :${NC}"
echo -e "  Host     : localhost"
echo -e "  Port     : 5432"
echo -e "  User     : student"
echo -e "  Password : student123"
echo -e "  Database : sfeir_dbt"
echo ""
echo -e "${YELLOW}Prochaines étapes :${NC}"
echo -e "  1. Copier un projet : cp -r ../../shared/dbt-projects/starter ./mon-lab"
echo -e "  2. Aller dedans      : cd mon-lab"
echo -e "  3. Tester            : dbt debug"
echo -e "  4. Exécuter          : dbt run"
echo ""
echo -e "${YELLOW}Commandes utiles :${NC}"
echo -e "  make psql    # Se connecter à PostgreSQL"
echo -e "  make test    # Tester dbt"
echo -e "  make stop    # Arrêter PostgreSQL"
echo ""
