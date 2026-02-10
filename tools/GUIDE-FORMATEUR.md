# Guide Formateur - SFEIR School DBT

## Introduction

Bienvenue dans le guide formateur pour SFEIR School DBT. Ce document vous accompagne dans la mise en place de l'environnement de formation, depuis la préparation de votre propre machine jusqu'au déploiement d'une infrastructure partagée pour vos étudiants.

En tant que formateur, vous disposez de deux environnements complémentaires. Le premier est un environnement local qui tourne sur votre machine et vous permet de préparer la formation, tester les exercices, et réaliser des démonstrations pendant le cours. Le second est un environnement cloud optionnel, hébergé sur Google Cloud Platform, qui permet à tous vos étudiants de se connecter à une base de données commune sans avoir à installer quoi que ce soit localement.

Ce guide est conçu pour être suivi dans l'ordre, en commençant par votre environnement local, puis en abordant le déploiement cloud uniquement si vous en avez besoin.

## Préparation de votre environnement local

### Pourquoi commencer par l'environnement local ?

Avant de déployer quoi que ce soit dans le cloud, il est essentiel que vous maîtrisiez l'environnement de formation sur votre propre machine. Cet environnement local vous servira à tester tous les exercices, préparer vos démonstrations, et résoudre les problèmes pendant le cours sans dépendre d'une connexion internet.

L'environnement local repose sur Docker, ce qui signifie qu'une fois Docker installé, tout le reste s'installe automatiquement sans nécessiter de droits administrateur particuliers. Vous obtiendrez une base de données PostgreSQL 15 complète, DBT pré-configuré, et toutes les données de démonstration nécessaires aux exercices.

### Configuration du profil dbt

**Important** : Le projet dbt dans `tools/shared/dbt-projects/starter/dbt_project.yml` est configuré par défaut avec le profil `sfeir_trainer`. Vérifiez que vous avez bien ce profil dans votre fichier `~/.dbt/profiles.yml` :

```yaml
sfeir_trainer:
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: dbt_trainer
      password: dbt_password
      dbname: sfeir_dbt
      schema: dbt_trainer
      threads: 4
  target: dev
```

Les étudiants devront modifier le fichier `dbt_project.yml` pour utiliser `profile: 'sfeir_student'` avec leurs credentials (voir le guide étudiant).

### Installation des prérequis

Commencez par vous assurer que Docker Desktop est installé sur votre machine. Sur macOS, vous pouvez l'installer via Homebrew avec la commande `brew install --cask docker`. Sur Windows, téléchargez l'installateur depuis le site officiel de Docker. Sur Linux, utilisez votre gestionnaire de paquets habituel (apt, yum, etc.).

Vérifiez également que vous avez l'outil Make installé. Sur macOS et Linux, il est généralement présent par défaut. Sur Windows, vous devrez peut-être l'installer via Chocolatey ou utiliser les scripts PowerShell fournis en alternative.

Enfin, assurez-vous d'avoir Python 3.8 ou supérieur installé sur votre système. Vous pouvez vérifier votre version avec la commande `python --version` ou `python3 --version`.

### Lancement de l'installation

Une fois les prérequis en place, rendez-vous dans le dossier `formateur/local` depuis votre terminal. L'installation complète se fait en une seule commande : `make setup`.

Cette commande va orchestrer plusieurs étapes automatiquement. Elle commence par vérifier que Docker est bien installé et fonctionnel. Ensuite, elle crée automatiquement un environnement virtuel Python (venv) isolé, ce qui garantit que l'installation de DBT ne va pas interférer avec d'autres installations Python sur votre système et ne nécessite aucun droit administrateur. Puis elle crée un fichier de configuration `.env` à partir du modèle fourni, avec des paramètres par défaut adaptés à l'environnement de formation. Elle démarre ensuite un conteneur Docker PostgreSQL, attend qu'il soit complètement initialisé, puis crée la base de données et charge toutes les données de démonstration (entreprises, clients, commandes, etc.). Enfin, elle installe DBT dans l'environnement virtuel avec l'adaptateur PostgreSQL et vérifie que tout communique correctement.

L'ensemble du processus prend généralement entre 3 et 5 minutes selon votre connexion internet et la puissance de votre machine.

### Vérification de l'installation

Une fois l'installation terminée, vous pouvez vérifier que tout fonctionne correctement en testant la connexion à PostgreSQL. La commande `make psql` vous connectera directement à votre base de données. Vous devriez voir apparaître le prompt PostgreSQL, signe que tout est opérationnel.

Vous pouvez également tester DBT en vous rendant dans le projet de démonstration situé dans `shared/dbt-projects/demo`. Lancez la commande `dbt debug` pour vérifier la configuration, puis `dbt run` pour exécuter les modèles de démonstration. Si tout se passe bien, vous verrez les différents modèles s'exécuter avec succès.

### Configuration de votre environnement

Les paramètres par défaut sont prêts à l'emploi, mais vous pouvez les personnaliser si nécessaire. Le fichier `.env` contient toutes les variables d'environnement : nom d'utilisateur PostgreSQL (par défaut `dbt_trainer`), mot de passe (`dbt_password`), nom de la base de données (`sfeir_dbt`), et port d'écoute (5432).

Si le port 5432 est déjà utilisé sur votre machine par une autre instance PostgreSQL, vous pouvez simplement modifier la valeur dans le fichier `.env` et relancer `make restart`. L'environnement s'adaptera automatiquement.

### Utilisation au quotidien

Pendant la préparation de votre formation et pendant le cours lui-même, vous aurez besoin de quelques commandes essentielles. La commande `make start` démarre les services (PostgreSQL), `make stop` les arrête, et `make restart` les redémarre. Pour voir les logs en temps réel, utilisez `make logs`.

Si vous souhaitez réinitialiser complètement votre environnement (par exemple après avoir testé plusieurs scénarios), la commande `make clean` supprimera tous les conteneurs et les données, et vous pourrez repartir de zéro avec `make setup`.

## Déploiement d'un environnement cloud pour vos étudiants

### Quand utiliser l'environnement cloud ?

L'environnement cloud n'est pas obligatoire. Il devient pertinent dans plusieurs situations : lorsque vous avez plus de 15-20 étudiants et que vous souhaitez éviter les problèmes de setup local qui pourraient ralentir le démarrage de la formation, lorsque certains étudiants n'ont pas les droits pour installer Docker sur leurs machines d'entreprise, ou lorsque vous souhaitez garantir que tous les étudiants travaillent exactement dans le même environnement.

L'environnement cloud repose sur CloudSQL, le service de base de données managé de Google Cloud Platform. Vous déployez une instance PostgreSQL accessible depuis internet, et chaque étudiant reçoit des credentials pour s'y connecter.

### Prérequis pour le déploiement cloud

Avant de déployer l'infrastructure cloud, vous devez disposer d'un compte Google Cloud Platform avec un projet actif. Assurez-vous d'avoir installé l'outil en ligne de commande `gcloud` et de vous être authentifié avec `gcloud auth login` et `gcloud auth application-default login`.

Vous aurez également besoin de Terraform version 1.6 ou supérieure pour provisionner l'infrastructure automatiquement. Terraform peut s'installer facilement via Homebrew sur macOS (`brew install terraform`) ou via le gestionnaire de paquets de votre système.

Vérifiez que vous disposez des permissions nécessaires sur votre projet GCP : droits de création d'instances CloudSQL, gestion des règles réseau, et création de bases de données.

### Configuration de l'infrastructure

Commencez par vous rendre dans le dossier `formateur/cloud`. Vous y trouverez un fichier d'exemple `terraform.tfvars.example` que vous devez copier vers `terraform.tfvars`. Ce fichier contient les paramètres essentiels de votre infrastructure.

Éditez ce fichier pour renseigner votre ID de projet GCP, la région où vous souhaitez déployer l'instance (par exemple `europe-west1` pour la Belgique ou `europe-west3` pour la France), et surtout un mot de passe fort pour la base de données. Utilisez un générateur de mots de passe et choisissez quelque chose de robuste, avec au moins 16 caractères mêlant majuscules, minuscules, chiffres et caractères spéciaux.

Le paramètre `cloudsql_user_count` détermine combien de bases de données distinctes seront créées. Si vous avez 20 étudiants, mettez 20. Chaque étudiant aura sa propre base de données dédiée, ce qui facilite l'isolation et le debugging.

Le paramètre `cloudsql_tier` définit la puissance de l'instance. La valeur `db-f1-micro` convient pour jusqu'à 20 étudiants et coûte environ 7 euros par mois. Si vous avez plus d'étudiants ou des besoins de performance accrus, optez pour `db-g1-small` (environ 25 euros par mois).

### Lancement du déploiement

Une fois la configuration en place, lancez simplement `make deploy` depuis le dossier `formateur/cloud`. Cette commande va initialiser Terraform, valider votre configuration, puis créer toutes les ressources nécessaires sur GCP.

Le déploiement prend généralement entre 10 et 15 minutes. Terraform va créer l'instance CloudSQL, configurer les règles réseau pour autoriser les connexions depuis internet, créer les bases de données et les utilisateurs, puis initialiser les schémas et charger les données de démonstration.

Pendant le déploiement, vous verrez défiler les logs de Terraform indiquant les ressources créées. À la fin, un résumé s'affichera avec toutes les informations importantes : l'adresse IP publique de votre instance, les noms des bases de données créées, et les credentials d'accès.

### Vérification du déploiement

Après le déploiement, prenez le temps de vérifier que tout fonctionne correctement. Vous pouvez récupérer toutes les informations de connexion avec la commande `make output`. Notez bien l'adresse IP publique de l'instance.

Testez la connexion depuis votre propre machine en utilisant `psql` (si vous l'avez installé). La commande ressemblera à : `psql "host=VOTRE_IP port=5432 dbname=sfeir_dbt user=dbt password=VOTRE_PASSWORD sslmode=require"`. Si vous arrivez à vous connecter et à voir les tables, c'est que tout fonctionne.

Vous pouvez également tester avec DBT en modifiant temporairement votre `profiles.yml` pour pointer vers l'instance cloud, puis en lançant `dbt debug` et `dbt run` depuis un projet de test.

## Distribution des accès aux étudiants

### Génération des fichiers de connexion

Une fois votre infrastructure déployée et testée, vous devez distribuer les informations de connexion à vos étudiants. La commande `make share-credentials` génère automatiquement un dossier `credentials/` contenant tout ce dont les étudiants ont besoin.

Ce dossier contient trois fichiers essentiels. Le premier est un README.md qui explique aux étudiants comment configurer leur environnement. Le second est un fichier `profiles.yml` pré-rempli avec les paramètres de connexion, prêt à être copié dans leur dossier `.dbt`. Le troisième est un fichier texte simple `connection-info.txt` qui récapitule toutes les informations : adresse IP, nom de la base de données, utilisateur, mot de passe.

### Méthodes de distribution

Vous avez plusieurs options pour partager ces credentials avec vos étudiants. La méthode la plus simple est de créer une archive ZIP du dossier credentials et de la partager via Google Drive, Dropbox, ou par email. Assurez-vous de restreindre l'accès aux seuls participants de la formation.

Une autre approche consiste à créer un repository GitHub privé dédié, d'y pousser le contenu du dossier credentials, puis d'inviter tous les étudiants comme collaborateurs. Cette méthode a l'avantage de pouvoir mettre à jour les informations facilement si nécessaire.

Dans tous les cas, envoyez ces informations au moins 24 heures avant le début de la formation pour que les étudiants aient le temps de tester leur connexion et de vous signaler d'éventuels problèmes.

### Consignes de sécurité pour les étudiants

Rappelez à vos étudiants quelques règles de sécurité importantes. Les credentials ne doivent jamais être committés dans un repository Git public. Ils ne doivent pas être partagés en dehors du groupe de formation. Et surtout, ils doivent être considérés comme temporaires : l'infrastructure sera détruite après la formation.

Conseillez-leur d'ajouter `profiles.yml` et le dossier `credentials/` dans leur `.gitignore` pour éviter toute publication accidentelle.

## Utilisation pendant la formation

### Stratégie de démonstration

Pendant la formation, vous allez jongler entre deux environnements. Utilisez votre environnement local pour toutes les démonstrations live. C'est plus rapide, plus fiable (pas de dépendance réseau), et vous avez un contrôle total. Vous pouvez arrêter et redémarrer PostgreSQL, modifier les données, réinitialiser l'environnement entre deux sessions, tout cela en quelques secondes.

Gardez un terminal ouvert avec `make logs` dans votre environnement local. Cela vous permettra de voir en temps réel ce qui se passe dans PostgreSQL si un étudiant ou vous-même rencontrez un comportement inattendu.

### Surveillance de l'environnement cloud

Si vous avez déployé l'environnement cloud, gardez un œil sur les connexions. Vous pouvez utiliser la console Google Cloud pour monitorer l'activité de votre instance CloudSQL. La section "Observability" vous montrera le nombre de connexions actives, la charge CPU, et les éventuelles erreurs.

Si plusieurs étudiants signalent des problèmes de connexion en même temps, vérifiez d'abord votre connexion internet, puis celle de la salle de formation. Parfois, un firewall d'entreprise peut bloquer les connexions sortantes sur le port 5432. Dans ce cas, vous devrez peut-être contacter l'équipe IT pour autoriser temporairement ces connexions.

### Support aux étudiants

Préparez-vous à ce que certains étudiants rencontrent des problèmes de setup, surtout s'ils utilisent l'environnement local. Les problèmes les plus fréquents concernent Docker qui ne démarre pas, le port 5432 déjà utilisé, ou Python/DBT introuvables.

Pour chaque problème, commencez par leur demander d'exécuter quelques commandes de diagnostic : `docker --version`, `docker ps`, `dbt --version`. Cela vous donnera rapidement une idée de ce qui ne fonctionne pas. La plupart du temps, il suffit de redémarrer Docker, de changer un port, ou de réinstaller DBT avec pip.

Ayez toujours sous la main la commande `make clean && make setup` qui permet de réinitialiser complètement un environnement local. C'est souvent la solution la plus rapide quand on ne comprend pas ce qui bloque.

## Après la formation

### Sauvegarde des données

Si des étudiants ont créé des modèles particulièrement intéressants dans l'environnement cloud et que vous souhaitez les conserver, prenez le temps d'exporter les données avant de détruire l'infrastructure. Vous pouvez utiliser `pg_dump` pour créer une sauvegarde complète d'une ou plusieurs bases de données.

Depuis votre machine, connectez-vous à l'instance cloud et exportez ce qui vous intéresse : `pg_dump -h VOTRE_IP -U dbt -d student_05 > backup-etudiant-05.sql`. Vous pourrez ensuite réimporter ces données dans votre environnement local pour analyse.

### Destruction de l'infrastructure cloud

C'est l'étape la plus importante pour éviter des coûts inutiles. Dès que la formation est terminée et que vous avez fait vos sauvegardes éventuelles, rendez-vous dans le dossier `formateur/cloud` et lancez `make destroy`.

Terraform va supprimer toutes les ressources créées : l'instance CloudSQL, les règles réseau, les bases de données. Cette opération prend environ 5 minutes. À la fin, vérifiez dans la console Google Cloud que l'instance a bien été supprimée. Parfois, elle passe par un état "Deleting" pendant quelques minutes avant de disparaître complètement.

Ne négligez pas cette étape. Une instance CloudSQL oubliée peut générer des coûts conséquents sur plusieurs mois. Configurez également une alerte de facturation dans votre projet GCP pour être prévenu si les coûts dépassent un certain seuil.

### Nettoyage de votre environnement local

Votre environnement local peut rester en place aussi longtemps que vous le souhaitez. Il ne génère aucun coût et peut vous servir pour les prochaines sessions de formation. Si toutefois vous souhaitez libérer de l'espace disque, un simple `make clean` depuis le dossier `formateur/local` supprimera tous les conteneurs et volumes Docker.

## Résolution des problèmes courants

### Docker ne démarre pas

Si Docker refuse de démarrer, commencez par vérifier que Docker Desktop est bien lancé. Sur macOS, vous devriez voir l'icône Docker dans la barre de menu. Sur Windows, elle apparaît dans la zone de notification. Si l'icône n'est pas là, lancez Docker Desktop manuellement.

Parfois, Docker Desktop nécessite un redémarrage complet. Quittez l'application complètement (pas seulement fermer la fenêtre), attendez quelques secondes, puis relancez-la. Sur Linux, redémarrez le service Docker avec `sudo systemctl restart docker`.

Si Docker démarre mais que vos conteneurs ne fonctionnent pas, vérifiez l'espace disque disponible. Docker a besoin d'au moins 10-15 Go d'espace libre pour fonctionner correctement. Vous pouvez nettoyer l'espace Docker avec `docker system prune -a` si nécessaire.

### Port 5432 déjà utilisé

C'est un problème fréquent, surtout si vous avez déjà PostgreSQL installé localement. Pour identifier quel processus utilise le port, lancez `lsof -i :5432` sur macOS/Linux ou `netstat -ano | findstr :5432` sur Windows.

Si c'est une autre instance PostgreSQL qui tourne, vous avez deux options. Soit vous arrêtez cette instance le temps de la formation, soit vous modifiez le port utilisé par l'environnement de formation. Pour changer le port, éditez le fichier `.env` dans `formateur/local` et remplacez `POSTGRES_PORT=5432` par `POSTGRES_PORT=5433` (ou n'importe quel autre port libre). Puis relancez `make restart`.

N'oubliez pas que si vous changez le port, vous devrez également mettre à jour votre fichier `profiles.yml` pour que DBT se connecte sur le bon port.

### Les étudiants ne peuvent pas se connecter au cloud

Si plusieurs étudiants rencontrent des problèmes de connexion au cloud en même temps, vérifiez d'abord l'état de votre instance CloudSQL dans la console GCP. Elle doit être dans l'état "Running". Si elle est "Stopped", redémarrez-la.

Vérifiez ensuite les règles de réseau. Par défaut, l'infrastructure autorise les connexions depuis n'importe quelle IP (0.0.0.0/0). Si vous avez restreint l'accès à certaines plages d'IP, assurez-vous que les étudiants se trouvent bien dans ces plages. Vous pouvez temporairement ouvrir l'accès à tout le monde pour débloquer la situation, puis restreindre à nouveau après la formation.

Si un seul étudiant a un problème, demandez-lui de vérifier ses credentials : l'adresse IP, le nom de la base de données, le mot de passe. Une simple faute de frappe ou un espace en trop peut empêcher la connexion. La commande `dbt debug` affiche des messages d'erreur détaillés qui vous aideront à identifier le problème.

### DBT ne trouve pas la base de données

Si DBT indique qu'il ne peut pas se connecter à la base de données, commencez par vérifier que PostgreSQL est bien démarré. Lancez `docker ps` et cherchez un conteneur avec "postgres" dans le nom. S'il n'apparaît pas, lancez `make start`.

Si le conteneur tourne mais que DBT ne se connecte toujours pas, vérifiez le fichier `~/.dbt/profiles.yml`. Il doit contenir les bons paramètres : host localhost (ou l'IP cloud), port 5432 (ou celui que vous avez configuré), nom de la base de données, utilisateur et mot de passe corrects.

Testez la connexion directement avec psql avant de tester avec DBT. Si psql fonctionne mais pas DBT, c'est probablement un problème de configuration du profile. Si psql ne fonctionne pas non plus, c'est un problème PostgreSQL à résoudre en priorité.

### Erreurs Terraform lors du déploiement cloud

Les erreurs Terraform sont généralement liées aux permissions GCP ou à des quotas dépassés. Si Terraform vous indique un problème de permissions, vérifiez que votre compte a bien les rôles "Cloud SQL Admin" et "Compute Network Admin" sur le projet.

Si le message parle de quotas, c'est que vous avez atteint les limites de votre projet GCP pour les instances CloudSQL ou les adresses IP. Vous pouvez demander une augmentation de quota dans la console GCP, section "IAM & Admin" > "Quotas".

En cas d'erreur lors d'un déploiement précédent, commencez par nettoyer l'état Terraform avec `make clean` puis relancez `make deploy`. Si l'erreur persiste, allez dans la console GCP et vérifiez qu'il n'existe pas déjà une ressource avec le même nom qui bloquerait la création.

## Ressources et contacts

### Documentation officielle

Pour approfondir vos connaissances et répondre aux questions avancées de vos étudiants, consultez régulièrement la documentation officielle de DBT à l'adresse docs.getdbt.com. Elle est très complète et régulièrement mise à jour.

La documentation PostgreSQL (postgresql.org/docs) est également une ressource précieuse, surtout pour comprendre les subtilités des matérialisations et des performances SQL.

Pour tout ce qui concerne Docker, la documentation officielle docs.docker.com contient des guides détaillés sur tous les aspects de l'outil.

### Projets et données partagées

N'oubliez pas que le dossier `shared/` contient tous les projets DBT de référence : le projet starter que les étudiants copient pour démarrer leurs labs, le projet demo que vous utilisez pour vos démonstrations, et surtout le dossier `solutions/` qui contient les solutions complètes de tous les exercices, organisées par module.

Ces solutions sont votre meilleur allié pour préparer la formation. Prenez le temps de les exécuter, de les comprendre, et éventuellement de les adapter à votre style pédagogique.

### Support SFEIR

Pour toute question concernant le contenu pédagogique de la formation, les slides, ou l'organisation logistique, contactez l'équipe pédagogique SFEIR qui coordonne les SFEIR Schools.

Pour les questions techniques spécifiques à cet environnement de setup, référez-vous d'abord à ce guide et à la section troubleshooting. Si le problème persiste, n'hésitez pas à ouvrir une issue sur le repository GitHub du projet ou à contacter le mainteneur.

---

Vous êtes maintenant prêt à animer votre formation SFEIR School DBT. Bonne formation !
