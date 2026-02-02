.PHONY: help setup start stop restart test psql clean check-prereqs

# Variables
DOCKER_COMPOSE = docker-compose
ENV_FILE = .env
PYTHON = ./venv/bin/python3
DBT = ./venv/bin/dbt

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

setup: check-prereqs ## Installation complète
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

psql: ## Se connecter à PostgreSQL
	@echo "$(GREEN)🐘 Connexion à PostgreSQL...$(NC)"
	@docker exec -it sfeir-dbt-postgres-student psql -U student -d sfeir_dbt

clean: ## Nettoyer tout
	@echo "$(RED)🧹 Nettoyage complet...$(NC)"
	@$(DOCKER_COMPOSE) down -v
	@rm -rf .env logs
	@echo "$(GREEN)✅ Nettoyage terminé !$(NC)"

check-prereqs: ## Vérifier les prérequis
	@echo "$(GREEN)🔍 Vérification des prérequis...$(NC)"
	@command -v docker >/dev/null 2>&1 || { echo "$(RED)❌ Docker n'est pas installé$(NC)"; exit 1; }
	@command -v docker-compose >/dev/null 2>&1 || { echo "$(RED)❌ Docker Compose n'est pas installé$(NC)"; exit 1; }
	@command -v $(PYTHON) >/dev/null 2>&1 || { echo "$(RED)❌ Python3 n'est pas installé$(NC)"; exit 1; }
	@echo "$(GREEN)✅ Tous les prérequis sont installés$(NC)"
