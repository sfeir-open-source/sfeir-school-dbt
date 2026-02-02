#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Setup Formateur Local - SFEIR School DBT        ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""

# Vérifier les prérequis
echo -e "${YELLOW}🔍 Vérification des prérequis...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker n'est pas installé${NC}"
    echo "Installez Docker Desktop depuis : https://www.docker.com/products/docker-desktop"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose n'est pas installé${NC}"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 n'est pas installé${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Tous les prérequis sont installés${NC}"
echo ""

# Créer le fichier .env s'il n'existe pas
if [ ! -f .env ]; then
    echo -e "${YELLOW}📝 Création du fichier .env...${NC}"
    cp .env.example .env
    echo -e "${GREEN}✅ Fichier .env créé${NC}"
else
    echo -e "${YELLOW}ℹ️  Le fichier .env existe déjà${NC}"
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
pip install -q dbt-postgres==1.7.3
echo -e "${GREEN}✅ dbt installé${NC}"
echo ""

# Créer le répertoire de configuration dbt
mkdir -p ~/.dbt
if [ ! -f ~/.dbt/profiles.yml ]; then
    echo -e "${YELLOW}📝 Création du fichier profiles.yml...${NC}"
    cat > ~/.dbt/profiles.yml <<EOF
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
EOF
    echo -e "${GREEN}✅ Fichier profiles.yml créé${NC}"
else
    echo -e "${YELLOW}ℹ️  Le fichier profiles.yml existe déjà${NC}"
fi
echo ""

# Démarrer les services Docker
echo -e "${YELLOW}🐳 Démarrage de PostgreSQL...${NC}"
docker-compose up -d
echo -e "${GREEN}✅ PostgreSQL démarré${NC}"
echo ""

# Attendre que PostgreSQL soit prêt
echo -e "${YELLOW}⏳ Attente que PostgreSQL soit prêt...${NC}"
sleep 10

# Vérifier la connexion
echo -e "${YELLOW}🔗 Vérification de la connexion...${NC}"
docker exec sfeir-dbt-postgres pg_isready -U dbt_trainer

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ PostgreSQL est prêt${NC}"
else
    echo -e "${RED}❌ Impossible de se connecter à PostgreSQL${NC}"
    exit 1
fi
echo ""

# Charger les seeds si le projet demo existe
if [ -d "../../shared/dbt-projects/demo" ]; then
    echo -e "${YELLOW}📊 Chargement des données de démonstration...${NC}"
    cd ../../shared/dbt-projects/demo
    dbt seed --profiles-dir ~/.dbt
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Données chargées${NC}"
    else
        echo -e "${YELLOW}⚠️  Erreur lors du chargement des données (peut être normal si c'est la première fois)${NC}"
    fi
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
echo -e "  User     : dbt_trainer"
echo -e "  Password : dbt_password"
echo -e "  Database : sfeir_dbt"
echo ""
echo -e "${YELLOW}Commandes utiles :${NC}"
echo -e "  make psql      # Se connecter à PostgreSQL"
echo -e "  make test      # Tester dbt"
echo -e "  make dbt-run   # Exécuter les modèles"
echo -e "  make logs      # Voir les logs"
echo -e "  make stop      # Arrêter les services"
echo ""
