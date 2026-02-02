.PHONY: help setup start stop restart logs clean test psql dbt-run check-prereqs init-db

# Variables
DOCKER_COMPOSE = docker-compose
ENV_FILE = .env
PYTHON = ./venv/bin/python3
DBT = ./venv/bin/dbt

# Couleurs pour l'affichage
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

help: ## Afficher l'aide
	@echo "$(GREEN)╔═══════════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║  SFEIR School DBT - Setup Formateur Local        ║$(NC)"
	@echo "$(GREEN)╚═══════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "Commandes disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

setup: check-prereqs ## Installation complète (à faire une fois)
	@echo "$(GREEN)🚀 Installation de l'environnement formateur local...$(NC)"
	@./scripts/setup.sh

start: ## Démarrer les services
	@echo "$(GREEN)▶️  Démarrage des services...$(NC)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)✅ Services démarrés !$(NC)"
	@echo ""
	@echo "PostgreSQL : localhost:$$(grep POSTGRES_PORT $(ENV_FILE) | cut -d '=' -f2)"
	@echo "Utilisateur : $$(grep POSTGRES_USER $(ENV_FILE) | cut -d '=' -f2)"

stop: ## Arrêter les services
	@echo "$(YELLOW)⏸️  Arrêt des services...$(NC)"
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)✅ Services arrêtés !$(NC)"

restart: stop start ## Redémarrer les services

logs: ## Voir les logs
	@$(DOCKER_COMPOSE) logs -f

clean: ## Nettoyer tout (DB + containers)
	@echo "$(RED)🧹 Nettoyage complet...$(NC)"
	@$(DOCKER_COMPOSE) down -v
	@rm -rf .env dbt_packages target logs
	@echo "$(GREEN)✅ Nettoyage terminé !$(NC)"

test: ## Tester la connexion dbt
	@echo "$(GREEN)🧪 Test de la connexion dbt...$(NC)"
	@cd ../../shared/dbt-projects/demo && $(DBT) debug
	@echo "$(GREEN)✅ Test réussi !$(NC)"

psql: ## Se connecter à PostgreSQL
	@echo "$(GREEN)🐘 Connexion à PostgreSQL...$(NC)"
	@docker exec -it sfeir-dbt-postgres psql -U $$(grep POSTGRES_USER $(ENV_FILE) | cut -d '=' -f2) -d $$(grep POSTGRES_DB $(ENV_FILE) | cut -d '=' -f2)

dbt-run: ## Exécuter les modèles dbt
	@echo "$(GREEN)🔄 Exécution des modèles dbt...$(NC)"
	@cd ../../shared/dbt-projects/demo && $(DBT) run

check-prereqs: ## Vérifier les prérequis
	@echo "$(GREEN)🔍 Vérification des prérequis...$(NC)"
	@command -v docker >/dev/null 2>&1 || { echo "$(RED)❌ Docker n'est pas installé$(NC)"; exit 1; }
	@command -v docker-compose >/dev/null 2>&1 || { echo "$(RED)❌ Docker Compose n'est pas installé$(NC)"; exit 1; }
	@command -v $(PYTHON) >/dev/null 2>&1 || { echo "$(RED)❌ Python3 n'est pas installé$(NC)"; exit 1; }
	@echo "$(GREEN)✅ Tous les prérequis sont installés$(NC)"

init-db: ## Initialiser la base de données
	@echo "$(GREEN)📊 Initialisation de la base de données...$(NC)"
	@sleep 5  # Attendre que PostgreSQL soit prêt
	@cd ../../shared/dbt-projects/demo && $(DBT) seed
	@echo "$(GREEN)✅ Base de données initialisée !$(NC)"
