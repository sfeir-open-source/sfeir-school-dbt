#!/bin/bash

# Script de génération des credentials pour les étudiants

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}📦 Génération des credentials pour les étudiants...${NC}"
echo ""

# Créer le dossier credentials
CRED_DIR="./credentials"
rm -rf "$CRED_DIR"
mkdir -p "$CRED_DIR"

# Récupérer les outputs Terraform
cd terraform
INSTANCE_IP=$(terraform output -raw instance_ip_address 2>/dev/null)
DB_USER=$(terraform output -raw database_user 2>/dev/null)
DB_NAME=$(terraform output -raw database_name 2>/dev/null)

if [ -z "$INSTANCE_IP" ]; then
    echo -e "${RED}❌ Impossible de récupérer les informations. L'infrastructure est-elle déployée ?${NC}"
    exit 1
fi

cd ..

# Demander le mot de passe (pas dans les outputs pour sécurité)
echo -e "${YELLOW}⚠️  Le mot de passe n'est pas dans les outputs Terraform pour des raisons de sécurité.${NC}"
read -sp "Entrez le mot de passe CloudSQL (cloudsql_password): " DB_PASSWORD
echo ""
echo ""

# Générer le README pour les étudiants
cat > "$CRED_DIR/README.md" <<EOF
# 🎒 Connexion à l'environnement DBT - SFEIR School

## 📋 Informations de connexion

- **Host** : \`$INSTANCE_IP\`
- **Port** : \`5432\`
- **User** : \`$DB_USER\`
- **Password** : \`$DB_PASSWORD\`
- **Database principale** : \`$DB_NAME\`

## 🚀 Configuration dbt

### 1. Installer dbt

\`\`\`bash
pip install dbt-postgres==1.7.3
\`\`\`

### 2. Configurer le profile

Copiez le fichier \`profiles.yml\` fourni dans \`~/.dbt/profiles.yml\`

Ou créez-le manuellement avec le contenu ci-dessous.

### 3. Tester la connexion

\`\`\`bash
dbt debug
\`\`\`

## 📝 Contenu de profiles.yml

\`\`\`yaml
sfeir_student:
  target: dev
  outputs:
    dev:
      type: postgres
      threads: 4
      host: $INSTANCE_IP
      port: 5432
      user: $DB_USER
      pass: $DB_PASSWORD
      dbname: $DB_NAME
      schema: public
\`\`\`

## 🧪 Test rapide

\`\`\`bash
# Se connecter avec psql
psql "host=$INSTANCE_IP port=5432 dbname=$DB_NAME user=$DB_USER sslmode=require"

# Ou tester dbt
dbt debug
dbt run
\`\`\`

## 🆘 Problèmes ?

- **Connexion refusée** : Vérifiez votre connexion Internet
- **Erreur de mot de passe** : Vérifiez le mot de passe
- **Timeout** : L'instance est peut-être éteinte, contactez le formateur

## 📞 Support

En cas de problème, contactez votre formateur.
EOF

# Générer le fichier profiles.yml
cat > "$CRED_DIR/profiles.yml" <<EOF
sfeir_student:
  target: dev
  outputs:
    dev:
      type: postgres
      threads: 4
      host: $INSTANCE_IP
      port: 5432
      user: $DB_USER
      pass: $DB_PASSWORD
      dbname: $DB_NAME
      schema: public
EOF

# Générer un fichier de connexion rapide
cat > "$CRED_DIR/connection-info.txt" <<EOF
╔═══════════════════════════════════════════════════╗
║  SFEIR School DBT - Informations de Connexion    ║
╚═══════════════════════════════════════════════════╝

Host:     $INSTANCE_IP
Port:     5432
User:     $DB_USER
Password: $DB_PASSWORD
Database: $DB_NAME

Connexion PostgreSQL:
  psql "host=$INSTANCE_IP port=5432 dbname=$DB_NAME user=$DB_USER sslmode=require"

Configuration dbt:
  Copiez profiles.yml dans ~/.dbt/profiles.yml
  Testez avec: dbt debug

⚠️  Gardez ces informations confidentielles !
EOF

echo -e "${GREEN}✅ Fichiers générés dans $CRED_DIR/${NC}"
echo ""
echo -e "${YELLOW}Fichiers créés :${NC}"
echo "  - README.md : Instructions pour les étudiants"
echo "  - profiles.yml : Configuration dbt"
echo "  - connection-info.txt : Résumé des informations"
echo ""
echo -e "${GREEN}📤 Vous pouvez maintenant partager ce dossier avec les étudiants${NC}"
echo ""
