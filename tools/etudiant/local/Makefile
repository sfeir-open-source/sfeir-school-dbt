.PHONY: help setup start stop restart test psql clean check-prereqs venv dbt-run dbt-seed dbt-test dbt-build dbt-shell

# Variables
DOCKER_COMPOSE = docker-compose
ENV_FILE = .env
VENV_DIR = venv
PYTHON = ./$(VENV_DIR)/bin/python3
PIP = ./$(VENV_DIR)/bin/pip
DBT = ./$(VENV_DIR)/bin/dbt

# Couleurs
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m

help: ## Afficher l'aide
	@echo "$(GREEN)╔═══════════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║  SFEIR School DBT - Setup Étudiant Local         ║$(NC)"
	@echo "$(GREEN)╚═══════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "Commandes disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

setup: check-prereqs venv ## Installation complète
	@echo "$(GREEN)🚀 Installation de votre environnement...$(NC)"
	@./scripts/setup.sh

start: ## Démarrer PostgreSQL
	@echo "$(GREEN)▶️  Démarrage de PostgreSQL...$(NC)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)✅ PostgreSQL démarré !$(NC)"
	@echo ""
	@echo "Host : localhost:5432"
	@echo "User : student"
	@echo "DB   : sfeir_dbt"

stop: ## Arrêter PostgreSQL
	@echo "$(YELLOW)⏸️  Arrêt de PostgreSQL...$(NC)"
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)✅ PostgreSQL arrêté !$(NC)"

restart: stop start ## Redémarrer PostgreSQL

test: ## Tester dbt
	@echo "$(GREEN)🧪 Test de dbt...$(NC)"
	@$(DBT) --version
	@echo "$(GREEN)✅ dbt fonctionne !$(NC)"

dbt-run: ## Exécuter les modèles dbt
	@echo "$(GREEN)🔄 Exécution des modèles dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/local/$(DBT) run

dbt-seed: ## Charger les seeds (dbt seed)
	@echo "$(GREEN)🌱 Chargement des seeds...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/local/$(DBT) seed
	@echo "$(GREEN)✅ Seeds chargés !$(NC)"

dbt-test: ## Exécuter les tests dbt
	@echo "$(GREEN)🧪 Exécution des tests dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/local/$(DBT) test
	@echo "$(GREEN)✅ Tests terminés !$(NC)"

dbt-build: ## Builder le projet dbt (seed + run + test)
	@echo "$(GREEN)🏗️  Build du projet dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../etudiant/local/$(DBT) build
	@echo "$(GREEN)✅ Build terminé !$(NC)"

dbt-shell: ## Entrer en mode interactif dbt (utiliser dbt directement)
	@echo "$(GREEN)🐚 Mode interactif dbt activé$(NC)"
	@echo "$(YELLOW)Vous êtes maintenant dans le projet starter$(NC)"
	@echo "$(YELLOW)Utilisez les commandes dbt directement : dbt run, dbt test, etc.$(NC)"
	@echo "$(YELLOW)Note: Modifiez 'profile' dans dbt_project.yml si nécessaire$(NC)"
	@echo "$(YELLOW)Tapez 'exit' pour quitter ce mode$(NC)"
	@echo ""
	@cd ../../shared/dbt-projects/starter && \
		export PATH="$(shell pwd)/$(VENV_DIR)/bin:$$PATH" && \
		export DBT_PROFILES_DIR=~/.dbt && \
		export PS1="(dbt) \W $$ " && \
		dbt --version && \
		bash

psql: ## Se connecter à PostgreSQL
	@echo "$(GREEN)🐘 Connexion à PostgreSQL...$(NC)"
	@docker exec -it sfeir-dbt-postgres-student psql -U student -d sfeir_dbt

clean: ## Nettoyer tout
	@echo "$(RED)🧹 Nettoyage complet...$(NC)"
	@$(DOCKER_COMPOSE) down -v
	@rm -rf .env logs $(VENV_DIR)
	@echo "$(GREEN)✅ Nettoyage terminé !$(NC)"

check-prereqs: ## Vérifier les prérequis
	@echo "$(GREEN)🔍 Vérification des prérequis...$(NC)"
	@command -v docker >/dev/null 2>&1 || { echo "$(RED)❌ Docker n'est pas installé$(NC)"; exit 1; }
	@command -v docker-compose >/dev/null 2>&1 || { echo "$(RED)❌ Docker Compose n'est pas installé$(NC)"; exit 1; }
	@command -v python3 >/dev/null 2>&1 || { echo "$(RED)❌ Python3 n'est pas installé$(NC)"; exit 1; }
	@echo "$(GREEN)✅ Tous les prérequis sont installés$(NC)"

venv: ## Créer l'environnement virtuel Python
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "$(GREEN)🐍 Création de l'environnement virtuel Python...$(NC)"; \
		python3 -m venv $(VENV_DIR); \
		echo "$(GREEN)✅ Environnement virtuel créé !$(NC)"; \
	else \
		echo "$(GREEN)✓ Environnement virtuel déjà existant$(NC)"; \
	fi
