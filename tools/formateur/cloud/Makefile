.PHONY: help deploy destroy plan output share-credentials clean check-prereqs init

# Variables
TF_DIR = terraform
TF = terraform
GCLOUD = gcloud

# Couleurs
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m

help: ## Afficher l'aide
	@echo "$(GREEN)╔═══════════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║  SFEIR School DBT - Setup Formateur Cloud        ║$(NC)"
	@echo "$(GREEN)╚═══════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "Commandes disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

deploy: check-prereqs init ## Déployer l'infrastructure GCP
	@echo "$(GREEN)🚀 Déploiement de l'infrastructure...$(NC)"
	@cd $(TF_DIR) && $(TF) apply -auto-approve
	@echo "$(GREEN)✅ Infrastructure déployée !$(NC)"
	@make output

destroy: ## Détruire l'infrastructure
	@echo "$(RED)⚠️  ATTENTION : Vous allez détruire l'infrastructure !$(NC)"
	@echo "$(RED)Appuyez sur Ctrl+C pour annuler, ou Entrée pour continuer...$(NC)"
	@read
	@echo "$(YELLOW)🧹 Destruction de l'infrastructure...$(NC)"
	@cd $(TF_DIR) && $(TF) destroy -auto-approve
	@echo "$(GREEN)✅ Infrastructure détruite !$(NC)"

plan: init ## Voir les changements avant déploiement
	@echo "$(YELLOW)📋 Planification des changements...$(NC)"
	@cd $(TF_DIR) && $(TF) plan

output: ## Afficher les informations de connexion
	@echo "$(GREEN)📊 Informations de connexion :$(NC)"
	@cd $(TF_DIR) && $(TF) output

share-credentials: ## Générer les fichiers pour les étudiants
	@echo "$(YELLOW)📦 Génération des credentials pour les étudiants...$(NC)"
	@./scripts/generate-credentials.sh
	@echo "$(GREEN)✅ Fichiers générés dans ./credentials/$(NC)"

clean: ## Nettoyer les fichiers temporaires
	@echo "$(YELLOW)🧹 Nettoyage...$(NC)"
	@rm -rf $(TF_DIR)/.terraform
	@rm -rf $(TF_DIR)/.terraform.lock.hcl
	@rm -rf $(TF_DIR)/terraform.tfstate*
	@rm -rf credentials/
	@echo "$(GREEN)✅ Nettoyage terminé$(NC)"

check-prereqs: ## Vérifier les prérequis
	@echo "$(GREEN)🔍 Vérification des prérequis...$(NC)"
	@command -v $(TF) >/dev/null 2>&1 || { echo "$(RED)❌ Terraform n'est pas installé$(NC)"; exit 1; }
	@command -v $(GCLOUD) >/dev/null 2>&1 || { echo "$(RED)❌ gcloud CLI n'est pas installé$(NC)"; exit 1; }
	@$(GCLOUD) auth list 2>&1 | grep -q "ACTIVE" || { echo "$(RED)❌ Vous n'êtes pas connecté à GCP. Exécutez: gcloud auth login$(NC)"; exit 1; }
	@[ -f $(TF_DIR)/terraform.tfvars ] || { echo "$(RED)❌ Fichier terraform.tfvars manquant. Copiez terraform.tfvars.example$(NC)"; exit 1; }
	@echo "$(GREEN)✅ Tous les prérequis sont remplis$(NC)"

init: ## Initialiser Terraform
	@echo "$(YELLOW)🔧 Initialisation de Terraform...$(NC)"
	@cd $(TF_DIR) && $(TF) init
	@echo "$(GREEN)✅ Terraform initialisé$(NC)"
