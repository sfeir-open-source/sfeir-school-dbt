.PHONY: help setup start stop restart logs clean test psql dbt-run dbt-seed dbt-test dbt-build dbt-shell check-prereqs init-db venv

# Variables
DOCKER_COMPOSE = docker-compose
ENV_FILE = .env
VENV_DIR = venv
PYTHON = ./$(VENV_DIR)/bin/python3
PIP = ./$(VENV_DIR)/bin/pip
DBT = ./$(VENV_DIR)/bin/dbt

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

setup: check-prereqs venv ## Installation complète (à faire une fois)
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
	@rm -rf .env dbt_packages target logs $(VENV_DIR)
	@echo "$(GREEN)✅ Nettoyage terminé !$(NC)"

test: ## Tester la connexion dbt
	@echo "$(GREEN)🧪 Test de la connexion dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../formateur/local/$(DBT) debug
	@echo "$(GREEN)✅ Test réussi !$(NC)"

psql: ## Se connecter à PostgreSQL
	@echo "$(GREEN)🐘 Connexion à PostgreSQL...$(NC)"
	@docker exec -it sfeir-dbt-postgres psql -U $$(grep POSTGRES_USER $(ENV_FILE) | cut -d '=' -f2) -d $$(grep POSTGRES_DB $(ENV_FILE) | cut -d '=' -f2)

dbt-run: ## Exécuter les modèles dbt
	@echo "$(GREEN)🔄 Exécution des modèles dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../formateur/local/$(DBT) run

dbt-seed: ## Charger les seeds (dbt seed)
	@echo "$(GREEN)🌱 Chargement des seeds...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../formateur/local/$(DBT) seed
	@echo "$(GREEN)✅ Seeds chargés !$(NC)"

dbt-test: ## Exécuter les tests dbt
	@echo "$(GREEN)🧪 Exécution des tests dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../formateur/local/$(DBT) test
	@echo "$(GREEN)✅ Tests terminés !$(NC)"

dbt-build: ## Builder le projet dbt (seed + run + test)
	@echo "$(GREEN)🏗️  Build du projet dbt...$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../formateur/local/$(DBT) build
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

init-db: ## Initialiser la base de données
	@echo "$(GREEN)📊 Initialisation de la base de données...$(NC)"
	@sleep 5  # Attendre que PostgreSQL soit prêt
	@echo "$(YELLOW)📋 Copie des seeds...$(NC)"
	@mkdir -p ../../shared/dbt-projects/starter/seeds
	@cp ../../shared/data/seeds/*.csv ../../shared/dbt-projects/starter/seeds/
	@echo "$(GREEN)✅ Seeds copiés$(NC)"
	@cd ../../shared/dbt-projects/starter && ../../../formateur/local/$(DBT) seed
	@echo "$(GREEN)✅ Base de données initialisée !$(NC)"
