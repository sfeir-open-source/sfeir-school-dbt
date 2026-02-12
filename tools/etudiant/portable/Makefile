.PHONY: help setup start stop restart logs clean test dbt-run dbt-seed dbt-test dbt-build dbt-shell check-prereqs venv init-db

# Variables
VENV_DIR = venv
PYTHON = ./$(VENV_DIR)/bin/python3
PIP = ./$(VENV_DIR)/bin/pip
DBT = ./$(VENV_DIR)/bin/dbt
DB_FILE = ../../shared/dbt-projects/starter/sfeir_dbt.duckdb

# Couleurs pour l'affichage
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

help: ## Afficher l'aide
	@echo "$(GREEN)╔═══════════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║  SFEIR School DBT - Setup Étudiant Portable      ║$(NC)"
	@echo "$(GREEN)╚═══════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)Mode portable : Base de données DuckDB embarquée$(NC)"
	@echo "$(YELLOW)✓ Pas besoin de Docker ni de droits admin$(NC)"
	@echo ""
	@echo "Commandes disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

setup: check-prereqs venv ## Installation complète (à faire une fois)
	@echo "$(GREEN)🚀 Installation de votre environnement portable...$(NC)"
	@./scripts/setup.sh

start: ## Démarrer l'environnement (rien à démarrer avec DuckDB)
	@echo "$(GREEN)✓ Mode portable : la base DuckDB est prête à l'emploi$(NC)"
	@if [ -f "$(DB_FILE)" ]; then \
		echo "$(GREEN)📊 Base de données : $(DB_FILE)$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  Base non initialisée. Lancez 'make dbt-seed' pour charger les données$(NC)"; \
	fi

stop: ## Arrêter l'environnement (rien à arrêter avec DuckDB)
	@echo "$(GREEN)✓ Mode portable : rien à arrêter$(NC)"

restart: ## Redémarrer l'environnement (rien à redémarrer)
	@echo "$(GREEN)✓ Mode portable : rien à redémarrer$(NC)"

logs: ## Voir les logs (pas de logs serveur avec DuckDB)
	@echo "$(YELLOW)Mode portable : pas de logs serveur$(NC)"
	@echo "$(GREEN)Les logs dbt se trouvent dans target/dbt.log$(NC)"

clean: ## Nettoyer tout (DB + venv)
	@echo "$(RED)🧹 Nettoyage complet...$(NC)"
	@rm -rf $(VENV_DIR) $(DB_FILE) $(DB_FILE).wal
	@cd ../../shared/dbt-projects/starter && rm -rf dbt_packages target logs
	@echo "$(GREEN)✅ Nettoyage terminé !$(NC)"

test: ## Tester la connexion dbt
	@echo "$(GREEN)🧪 Test de la connexion dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/portable/$(DBT) debug --profile sfeir_student_portable
	@echo "$(GREEN)✅ Test réussi !$(NC)"

dbt-run: ## Exécuter les modèles dbt
	@echo "$(GREEN)🔄 Exécution des modèles dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/portable/$(DBT) run --profile sfeir_student_portable

dbt-seed: ## Charger les seeds (dbt seed)
	@echo "$(GREEN)🌱 Chargement des seeds...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/portable/$(DBT) seed --profile sfeir_student_portable
	@echo "$(GREEN)✅ Seeds chargés !$(NC)"

dbt-test: ## Exécuter les tests dbt
	@echo "$(GREEN)🧪 Exécution des tests dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/portable/$(DBT) test --profile sfeir_student_portable
	@echo "$(GREEN)✅ Tests terminés !$(NC)"

dbt-build: ## Builder le projet dbt (seed + run + test)
	@echo "$(GREEN)🏗️  Build du projet dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/portable/$(DBT) build --profile sfeir_student_portable
	@echo "$(GREEN)✅ Build terminé !$(NC)"

dbt-shell: ## Entrer en mode interactif dbt (utiliser dbt directement)
	@echo "$(GREEN)🐚 Mode interactif dbt activé$(NC)"
	@echo "$(YELLOW)Vous êtes maintenant dans le projet starter$(NC)"
	@echo "$(YELLOW)Utilisez les commandes dbt directement : dbt run, dbt test, etc.$(NC)"
	@echo "$(YELLOW)Note: Le profil 'sfeir_student_portable' est utilisé$(NC)"
	@echo "$(YELLOW)Tapez 'exit' pour quitter ce mode$(NC)"
	@echo ""
	@cd ../../shared/dbt-projects/starter && \
		export PATH="$(shell pwd)/$(VENV_DIR)/bin:$$PATH" && \
		export DBT_PROFILES_DIR=~/.dbt && \
		export DBT_PROFILE=sfeir_student_portable && \
		export PS1="(dbt-portable) \W $$ " && \
		dbt --version && \
		bash

duckdb-cli: ## Ouvrir DuckDB en ligne de commande
	@echo "$(GREEN)🦆 Connexion à DuckDB...$(NC)"
	@if [ -f "$(DB_FILE)" ]; then \
		cd ../../shared/dbt-projects/starter && ../../../etudiant/portable/$(VENV_DIR)/bin/python3 -c "import duckdb; conn = duckdb.connect('sfeir_dbt.duckdb'); print('Tables:', conn.execute('SHOW TABLES').fetchall())"; \
	else \
		echo "$(RED)❌ Base de données non trouvée. Lancez 'make dbt-seed' d'abord$(NC)"; \
	fi

check-prereqs: ## Vérifier les prérequis
	@echo "$(GREEN)🔍 Vérification des prérequis...$(NC)"
	@command -v python3 >/dev/null 2>&1 || { echo "$(RED)❌ Python3 n'est pas installé$(NC)"; exit 1; }
	@echo "$(GREEN)✅ Tous les prérequis sont installés$(NC)"
	@echo "$(GREEN)✓ Docker n'est PAS nécessaire pour le mode portable$(NC)"

venv: ## Créer l'environnement virtuel Python
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "$(GREEN)🐍 Création de l'environnement virtuel Python...$(NC)"; \
		python3 -m venv $(VENV_DIR); \
		echo "$(GREEN)✅ Environnement virtuel créé !$(NC)"; \
	else \
		echo "$(GREEN)✓ Environnement virtuel déjà existant$(NC)"; \
	fi

init-db: ## Initialiser la base de données
	@echo "$(GREEN)📊 Initialisation de la base de données DuckDB...$(NC)"
	@mkdir -p ../../shared/dbt-projects/starter/seeds
	@echo "$(YELLOW)📋 Copie des seeds...$(NC)"
	@cp ../../shared/data/seeds/*.csv ../../shared/dbt-projects/starter/seeds/ 2>/dev/null || echo "$(YELLOW)Seeds déjà présents$(NC)"
	@echo "$(GREEN)🌱 Chargement des seeds avec dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/portable/$(DBT) seed --profile sfeir_student_portable
	@echo "$(GREEN)✅ Base de données DuckDB initialisée !$(NC)"
