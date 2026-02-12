# Guide Étudiant - SFEIR School DBT

## Bienvenue !

Bienvenue dans la formation SFEIR School DBT ! Ce guide va vous accompagner dans l'installation de votre environnement de travail. Ne vous inquiétez pas, tout est prévu pour que le setup soit simple et rapide.

Vous allez découvrir DBT (Data Build Tool), un outil puissant qui transforme la façon dont on construit des pipelines de données. Mais avant de commencer à coder, vous devez préparer votre machine pour pouvoir exécuter les exercices de la formation.

Vous avez **trois options** pour travailler pendant la formation :

1. **Option locale avec Docker** - Installation complète avec PostgreSQL (recommandée si vous avez Docker)
2. **Option cloud** - Connexion à une base hébergée par le formateur (nécessite internet stable)
3. **Option portable** 🆕 - Base de données DuckDB embarquée (idéale si pas de droits admin ou Docker)

Lisez les trois sections suivantes pour choisir l'option qui vous convient le mieux.

## Option 1 : Installation locale (recommandée)

### Pourquoi choisir l'installation locale ?

L'installation locale vous donne le contrôle total de votre environnement. Une fois installé, vous pourrez travailler n'importe où, même dans le train sans wifi. Vous ne dépendez d'aucun serveur externe, donc pas de risque de lenteur réseau ou de déconnexion en plein exercice. Et surtout, vous apprenez à manipuler les outils dans des conditions réelles, comme vous le feriez dans un vrai projet.

L'installation locale utilise Docker pour lancer une base de données PostgreSQL directement sur votre machine. Une fois Docker installé, tout le reste se fait automatiquement en une seule commande. Vous n'avez pas besoin de droits administrateur pour utiliser Docker une fois qu'il est installé.

### Configuration du profil dbt

**Important** : Le projet dbt dans `tools/shared/dbt-projects/starter/dbt_project.yml` est configuré par défaut avec le profil `sfeir_trainer` (pour les formateurs). Vous devez le modifier pour utiliser votre propre profil :

1. Ouvrez le fichier `tools/shared/dbt-projects/starter/dbt_project.yml`
2. Changez la ligne :
   ```yaml
   profile: 'sfeir_trainer'
   ```
   en :
   ```yaml
   profile: 'sfeir_student'
   ```

Assurez-vous également d'avoir le profil `sfeir_student` dans votre fichier `~/.dbt/profiles.yml` :

```yaml
sfeir_student:
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5432
      user: student
      password: student123
      dbname: sfeir_dbt
      schema: student_dev
      threads: 4
  target: dev
```

### Qu'est-ce qui va être installé ?

Concrètement, vous allez avoir sur votre machine une base de données PostgreSQL version 15 qui tourne dans un conteneur Docker, DBT (Data Build Tool) installé avec l'adaptateur PostgreSQL pour qu'il puisse communiquer avec votre base, et toutes les données d'exemple nécessaires aux exercices (entreprises, clients, commandes, etc.) déjà chargées dans la base.

Le tout occupe environ 2 Go d'espace disque et utilise très peu de ressources une fois lancé. Même un ordinateur portable de milieu de gamme peut faire tourner cet environnement sans problème.

### Installation de Docker

Commencez par installer Docker Desktop si ce n'est pas déjà fait. C'est le seul prérequis un peu technique, mais les installateurs sont très bien faits.

Sur macOS, vous pouvez utiliser Homebrew si vous l'avez déjà installé en tapant `brew install --cask docker` dans votre terminal. Sinon, téléchargez l'installateur depuis le site officiel docker.com. Suivez les instructions d'installation, acceptez les permissions demandées, et lancez Docker Desktop depuis vos applications. Vous verrez une petite icône de baleine apparaître dans votre barre de menu quand Docker est prêt.

Sur Windows, téléchargez Docker Desktop depuis docker.com. L'installateur vous demandera peut-être d'activer WSL 2 (Windows Subsystem for Linux). Acceptez et laissez-le faire, c'est normal et nécessaire. Une fois l'installation terminée, redémarrez votre ordinateur si demandé, puis lancez Docker Desktop. Attendez que l'interface vous indique "Docker is running" avant de continuer.

Sur Linux, la procédure dépend de votre distribution. Sur Ubuntu ou Debian, vous pouvez installer Docker avec `sudo apt-get install docker.io docker-compose`. Sur Fedora ou CentOS, utilisez `sudo dnf install docker docker-compose`. Une fois installé, ajoutez votre utilisateur au groupe docker avec `sudo usermod -aG docker $USER`, puis déconnectez-vous et reconnectez-vous pour que le changement prenne effet.

### Vérification des autres prérequis

Vérifiez que vous avez Python installé sur votre système. Ouvrez un terminal et tapez `python --version` ou `python3 --version`. Vous devriez voir quelque chose comme "Python 3.8" ou une version supérieure. Si Python n'est pas installé, téléchargez-le depuis python.org et installez la dernière version stable.

Sur macOS et Linux, l'outil Make est normalement déjà présent. Vous pouvez le vérifier en tapant `make --version`. Sur Windows, Make n'est pas installé par défaut, mais ne vous inquiétez pas : des scripts PowerShell alternatifs sont fournis pour faire exactement la même chose.

### Lancement de l'installation

Une fois Docker en place, ouvrez un terminal et naviguez jusqu'au dossier de la formation. Rendez-vous dans le sous-dossier `tools/etudiant/local`. C'est là que tout va se passer.

Sur macOS et Linux, lancez simplement la commande `make setup`. Sur Windows, vous avez deux options : soit vous lancez le script batch `scripts\setup.bat` depuis l'invite de commandes, soit vous lancez le script PowerShell `.\scripts\setup.ps1` depuis PowerShell.

Cette commande va maintenant orchestrer toute l'installation. Elle commence par vérifier que Docker est bien installé et fonctionnel. Ensuite, elle crée automatiquement un environnement virtuel Python (venv) isolé dans le dossier de l'installation. Cet environnement virtuel est important car il garantit que DBT et ses dépendances seront installés de manière isolée, sans interférer avec d'autres installations Python que vous pourriez avoir sur votre machine, et surtout sans nécessiter de droits administrateur. Puis elle télécharge l'image PostgreSQL depuis Docker Hub (c'est un peu comme télécharger une application), démarre un conteneur avec cette image, attend que PostgreSQL soit complètement initialisé, crée la base de données et les tables nécessaires, charge toutes les données d'exemple, installe DBT dans l'environnement virtuel via pip, et enfin teste que DBT arrive bien à se connecter à PostgreSQL.

Le tout prend entre 3 et 5 minutes selon votre connexion internet. Vous verrez défiler plein de messages dans le terminal. C'est normal. À la fin, vous devriez voir un message de succès indiquant que tout est prêt.

### Vérification que tout fonctionne

Pour vérifier que votre installation a bien fonctionné, vous pouvez lancer quelques tests simples. La commande `make test` depuis le dossier `etudiant/local` va vérifier que DBT arrive à communiquer avec PostgreSQL. Si vous voyez "All checks passed!", c'est parfait.

Vous pouvez également vous connecter directement à votre base de données avec la commande `make psql`. Vous devriez voir apparaître le prompt PostgreSQL qui ressemble à `sfeir_dbt=#`. Tapez `\dt` pour voir la liste des tables. Vous devriez voir apparaître les tables companies, customers, orders, etc. Tapez `\q` pour quitter.

Si ces deux tests passent, vous êtes prêt à commencer la formation !

### Commandes utiles au quotidien

Pendant la formation, vous aurez besoin de quelques commandes essentielles. Pour démarrer PostgreSQL le matin, utilisez `make start` depuis le dossier `etudiant/local`. Pour l'arrêter le soir, utilisez `make stop`. Pour redémarrer en cas de problème, utilisez `make restart`.

Si à un moment vous voulez repartir de zéro avec une base de données propre, la commande `make clean` supprime tout, et vous pouvez relancer `make setup` pour réinstaller.

## Option 2 : Connexion à l'environnement cloud

### Quand choisir cette option ?

L'option cloud est faite pour vous si vous n'arrivez pas à installer Docker (par exemple si vous n'avez pas les droits administrateur sur votre machine d'entreprise), si votre ordinateur est un peu ancien et peine avec Docker, ou si vous voulez simplement la solution la plus rapide sans installation locale.

Avec l'option cloud, vous n'installez qu'un seul outil : DBT. Toute la base de données tourne sur un serveur hébergé par votre formateur sur Google Cloud Platform. Vous vous y connectez via internet, exactement comme vous vous connecteriez à n'importe quel service web.

### Prérequis et obtention des credentials

Vous aurez besoin de Python 3.8 ou supérieur installé sur votre machine. C'est le seul prérequis technique. Vérifiez avec `python --version` ou `python3 --version`.

Votre formateur vous a normalement fourni un dossier ou une archive contenant vos credentials de connexion. Ce dossier contient trois fichiers : un README avec les instructions, un fichier `profiles.yml` avec la configuration DBT toute prête, et un fichier `connection-info.txt` avec les détails de connexion (adresse IP, nom de base de données, mot de passe).

Commencez par extraire cette archive si vous l'avez reçue en ZIP, ou téléchargez les fichiers si le formateur les a mis sur un drive partagé.

### Installation de DBT

DBT s'installe très facilement avec pip, le gestionnaire de paquets Python. Ouvrez un terminal et tapez la commande suivante :

```bash
pip install dbt-postgres==1.7.3
```

Sur certains systèmes, vous devrez peut-être utiliser `pip3` au lieu de `pip`. L'installation prend une minute ou deux. À la fin, vérifiez que tout s'est bien passé en tapant `dbt --version`. Vous devriez voir s'afficher la version de DBT et de l'adaptateur PostgreSQL.

### Configuration du profile DBT

DBT a besoin de savoir comment se connecter à votre base de données. Cette configuration se fait via un fichier appelé `profiles.yml` qui doit se trouver dans un dossier caché `.dbt` de votre répertoire personnel.

La façon la plus simple est de copier le fichier `profiles.yml` fourni par votre formateur directement au bon endroit. Sur macOS et Linux, tapez :

```bash
mkdir -p ~/.dbt
cp profiles.yml ~/.dbt/profiles.yml
```

Sur Windows, ouvrez PowerShell et tapez :

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.dbt"
Copy-Item profiles.yml "$env:USERPROFILE\.dbt\profiles.yml"
```

Si vous préférez créer le fichier manuellement, créez le dossier `.dbt` dans votre répertoire personnel, puis créez-y un fichier `profiles.yml` avec le contenu suivant (en remplaçant les valeurs entre chevrons par celles fournies par votre formateur) :

```yaml
sfeir_student:
  target: dev
  outputs:
    dev:
      type: postgres
      threads: 4
      host: <IP_FOURNIE_PAR_FORMATEUR>
      port: 5432
      user: dbt
      pass: <MOT_DE_PASSE_FOURNI>
      dbname: <NOM_BASE_FOURNIE>
      schema: public
```

### Test de la connexion

Maintenant que tout est configuré, testez que vous arrivez bien à vous connecter. Depuis n'importe quel dossier contenant un projet DBT (vous pouvez copier le projet starter que nous verrons plus loin), lancez la commande `dbt debug`.

DBT va vérifier votre configuration et tenter de se connecter à la base de données. Si tout va bien, vous verrez plusieurs lignes vertes avec des "OK" et à la fin le message "All checks passed!". Si vous voyez ce message, vous êtes prêt pour la formation.

Si vous voyez un message d'erreur parlant de connexion refusée ou de timeout, vérifiez d'abord votre connexion internet. Vérifiez ensuite que vous avez bien copié l'adresse IP, le mot de passe, et le nom de la base de données sans faute de frappe ni espace supplémentaire. Les espaces en début ou fin de ligne sont la cause la plus fréquente de problèmes.

### Points d'attention avec le cloud

Quelques choses à garder en tête si vous utilisez l'option cloud. D'abord, vous devez avoir une connexion internet stable pendant toute la formation. Une connexion wifi de qualité médiocre peut rendre l'expérience frustrante avec des requêtes qui mettent longtemps à s'exécuter.

Ensuite, pensez à garder vos credentials en sécurité. Ne les partagez avec personne, ne les committez jamais dans un repository Git public, et ne les laissez pas dans un dossier partagé où n'importe qui pourrait les voir.

Enfin, sachez que si plusieurs étudiants exécutent des requêtes lourdes en même temps, la base de données peut ralentir temporairement. C'est normal, ce n'est pas un problème de votre côté.

## Option 3 : Mode portable avec DuckDB (nouvelle option recommandée !)

### Pourquoi choisir le mode portable ?

Le mode portable est la **solution idéale** si vous êtes dans l'une de ces situations :
- ❌ Vous n'avez **pas les droits administrateur** sur votre machine d'entreprise
- ❌ Vous ne pouvez **pas installer Docker** (politique IT restrictive)
- ❌ Votre ordinateur est **ancien** et peine avec Docker
- ✅ Vous voulez l'installation **la plus rapide** possible (2 minutes chrono)
- ✅ Vous voulez un environnement **100% portable** (copiable sur clé USB)

Avec le mode portable, vous n'installez qu'un seul outil : **dbt avec l'adaptateur DuckDB**. DuckDB est une base de données embarquée (fichier unique) qui ne nécessite aucun serveur. C'est ultra-léger, ultra-rapide, et la syntaxe SQL est quasi identique à PostgreSQL.

### Prérequis et installation

Vous avez **deux options** selon votre situation :

#### Option A : Vous avez Python installé (≥3.8)

Si vous avez déjà Python sur votre machine, l'installation est ultra-simple :

**Sur macOS / Linux :**
```bash
cd tools/etudiant/portable
make setup
```

**Sur Windows (sans Make) :**
```batch
cd tools\etudiant\portable
scripts\setup.bat
```

**Ou avec PowerShell :**
```powershell
cd tools\etudiant\portable
.\scripts\setup.ps1
```

L'installation prend **2 minutes maximum** et installe :
- Un environnement virtuel Python (sans droits admin)
- dbt-core version 1.10+
- dbt-duckdb (adaptateur DuckDB pour dbt)
- Configure automatiquement votre profil dbt
- Charge les données d'exemple dans une base DuckDB

#### Option B : Vous n'avez RIEN installé (installation bootstrap - zéro prérequis)

**🎯 Solution idéale si vous n'avez même pas Python installé et aucun moyen de l'installer !**

Le script **bootstrap** télécharge automatiquement Python portable (sans installation système) et installe tout le nécessaire dans le dossier du projet. **Aucun droit administrateur requis !**

**Sur macOS / Linux :**
```bash
cd tools/etudiant/portable/scripts
./bootstrap.sh
```

**Sur Windows :**
```batch
cd tools\etudiant\portable\scripts
bootstrap.bat
```

**Ou avec PowerShell :**
```powershell
cd tools\etudiant\portable\scripts
.\bootstrap.ps1
```

Le script bootstrap fait tout automatiquement :
1. 📥 Télécharge Python portable (Miniforge sur Mac/Linux, Python Embeddable sur Windows)
2. 📦 Installe Python dans le dossier `python_portable/` (aucune modification système)
3. 🔧 Crée un environnement virtuel avec dbt + DuckDB
4. ⚙️ Configure automatiquement les profils dbt
5. 📊 Charge les données d'exemple
6. ✅ Teste que tout fonctionne

**Tout reste dans le dossier du projet, rien n'est installé dans le système !**

Installation complète : **5-7 minutes** selon votre connexion internet.

### Utilisation au quotidien

Les commandes sont identiques à la version locale :

```bash
cd tools/etudiant/portable

make test          # Tester que dbt fonctionne
make dbt-seed      # Charger les données CSV
make dbt-run       # Exécuter vos modèles dbt
make dbt-test      # Lancer les tests
make dbt-build     # Tout faire : seed + run + test
make dbt-shell     # Mode interactif dbt
make clean         # Tout nettoyer et repartir de zéro
```

### Votre base de données

Votre base de données complète tient dans **un seul fichier** :
```
tools/shared/dbt-projects/starter/sfeir_dbt.duckdb
```

Pour explorer vos données avec Python :
```python
import duckdb
conn = duckdb.connect('sfeir_dbt.duckdb')
conn.execute("SHOW TABLES").fetchall()
conn.execute("SELECT * FROM companies LIMIT 5").fetchdf()
```

### Différences avec PostgreSQL

**Bonne nouvelle** : Pour 95% des exercices de la formation, vous ne verrez **aucune différence** !

DuckDB supporte :
- ✅ Tous les types de données standards (INT, VARCHAR, DATE, etc.)
- ✅ Les window functions (ROW_NUMBER, LAG, LEAD, etc.)
- ✅ Les CTEs (WITH clauses)
- ✅ Les JOINs complexes
- ✅ Les macros dbt
- ✅ Les tests et la documentation dbt

Petites différences (rares dans la formation) :
- Un seul schema par défaut (vs plusieurs dans PostgreSQL)
- Une seule écriture à la fois (mais OK pour usage individuel)

### Avantages du mode portable

| Avantage | Description |
|----------|-------------|
| 🚀 **Installation rapide** | 2 minutes vs 30 minutes avec Docker |
| 💻 **Pas de droits admin** | Fonctionne même sur machines verrouillées |
| 📦 **100% portable** | Copiez le dossier sur clé USB = environnement complet |
| 🔌 **Hors ligne** | Aucun serveur, aucune connexion nécessaire |
| 🧹 **Nettoyage facile** | Supprimez le fichier .duckdb = reset complet |
| 💾 **Backup simple** | Copiez le fichier = backup complet |

### En cas de problème

Si vous rencontrez des problèmes, consultez le [README détaillé du mode portable](etudiant/portable/README.md) qui contient :
- Résolution des problèmes courants
- Astuces pour Windows/Mac/Linux
- Exemples d'utilisation avancée
- FAQ complète

## Démarrer votre premier lab

### Copier le projet starter

Maintenant que votre environnement est prêt (local, cloud, ou portable), vous allez pouvoir commencer à travailler. Pour chaque exercice de la formation, vous allez partir d'un projet de base appelé "starter" et le modifier selon les consignes.

Le projet starter se trouve dans le dossier `shared/dbt-projects/starter` du repository. Pour commencer un lab, copiez ce dossier et renommez-le. Par exemple, pour le premier lab :

```bash
cp -r tools/shared/dbt-projects/starter ./lab-01
cd lab-01
```

Sur Windows, utilisez plutôt :

```cmd
xcopy /E /I tools\shared\dbt-projects\starter lab-01
cd lab-01
```

Vous avez maintenant votre propre copie du projet dans laquelle vous pouvez travailler librement sans risquer de casser quoi que ce soit.

### Comprendre la structure d'un projet DBT

Ouvrez le dossier `lab-01` dans votre éditeur de code favori (VS Code, Sublime, IntelliJ, peu importe). Vous allez voir plusieurs fichiers et dossiers.

Le fichier `dbt_project.yml` est le fichier de configuration principal. Il décrit votre projet : son nom, sa version, où se trouvent les modèles, etc. Vous n'aurez probablement pas besoin de le modifier pendant les premiers exercices.

Le dossier `models/` va contenir tous vos modèles DBT. Un modèle, c'est simplement un fichier SQL avec du templating Jinja. Chaque modèle représente une table ou une vue que DBT va créer dans votre base de données.

Le dossier `seeds/` peut contenir des fichiers CSV. DBT peut charger ces fichiers directement dans votre base de données sous forme de tables. C'est pratique pour des données de référence ou des petits jeux de données de test.

Le dossier `tests/` contiendra vos tests personnalisés pour valider que vos données respectent certaines règles métier.

### Charger les données initiales

Avant de pouvoir exécuter des modèles, vous avez besoin de données dans votre base. Le projet starter contient déjà quelques fichiers CSV dans le dossier `seeds/`. Pour les charger dans votre base de données, lancez la commande :

```bash
dbt seed
```

DBT va lire tous les fichiers CSV, créer les tables correspondantes dans PostgreSQL, et y insérer les données. Vous devriez voir des messages indiquant que plusieurs seeds ont été créés avec succès.

Ces données représentent un système simple de e-commerce : des entreprises, des clients, des commandes, des catégories de produits, et des pays. C'est sur ces données que vous allez travailler pendant les exercices.

### Exécuter vos premiers modèles

Le projet starter contient quelques modèles d'exemple dans le dossier `models/`. Pour les exécuter, lancez simplement :

```bash
dbt run
```

DBT va compiler vos fichiers SQL (en remplaçant les parties Jinja par du SQL pur), puis exécuter chaque requête dans votre base de données pour créer les tables ou vues correspondantes. Vous verrez défiler les logs de chaque modèle exécuté.

Si tout se passe bien, vous verrez des messages de succès en vert. Félicitations, vous venez d'exécuter votre premier pipeline DBT !

### Vérifier les résultats

Pour voir ce que DBT a créé dans votre base de données, vous pouvez vous connecter directement à PostgreSQL.

Si vous utilisez l'environnement local, lancez `make psql` depuis le dossier `etudiant/local`. Si vous utilisez le cloud, connectez-vous avec psql en utilisant les credentials fournis :

```bash
psql "host=VOTRE_IP port=5432 dbname=VOTRE_BASE user=dbt sslmode=require"
```

Une fois connecté, tapez `\dt` pour voir toutes les tables. Vous devriez voir les tables créées par vos seeds (companies, customers, orders, etc.) et celles créées par vos modèles. Tapez `SELECT * FROM nom_de_table LIMIT 10;` pour voir le contenu d'une table.

C'est comme ça que vous vérifierez vos résultats tout au long de la formation : exécuter des modèles avec `dbt run`, puis inspecter les tables créées avec psql ou un client PostgreSQL graphique si vous en avez un.

## Travailler pendant la formation

### Cycle de travail typique

Pendant la formation, vous allez répéter un cycle simple : le formateur présente un concept DBT, vous donne un exercice à réaliser, vous modifiez vos modèles SQL, vous exécutez `dbt run` pour voir si ça fonctionne, et vous vérifiez les résultats dans la base de données.

N'ayez pas peur d'expérimenter. Si vous cassez quelque chose, vous pouvez toujours repartir d'une copie fraîche du projet starter. C'est même recommandé de tester différentes approches pour bien comprendre comment DBT fonctionne.

Entre deux exercices, pensez à committer votre travail avec Git si vous voulez garder une trace. Créez un repository Git dans votre dossier de lab avec `git init`, puis committez régulièrement avec `git add .` et `git commit -m "Description de ce que j'ai fait"`.

### Utiliser les solutions pour débloquer

Si vous bloquez sur un exercice, ne restez pas coincé trop longtemps. Les solutions de tous les labs sont disponibles dans le dossier `shared/dbt-projects/solutions/`, organisées par module.

Par exemple, les solutions du module 3 se trouvent dans `shared/dbt-projects/solutions/module-03/`. Vous pouvez aller voir comment c'est fait, comprendre l'approche, puis revenir dans votre propre projet pour l'appliquer.

L'idéal est d'essayer d'abord par vous-même pendant 10-15 minutes. Si vous ne trouvez vraiment pas, regardez la solution. Mais ne vous contentez pas de la copier : prenez le temps de comprendre chaque ligne, pourquoi elle est là, ce qu'elle fait. C'est comme ça qu'on apprend vraiment.

### Où trouver de l'aide

Si vous rencontrez un problème technique (erreur DBT, connexion qui ne marche plus, etc.), regardez d'abord la section "Résolution des problèmes" plus bas dans ce guide. La plupart des problèmes courants y sont documentés avec leurs solutions.

Si le problème persiste, demandez au formateur. N'hésitez pas, c'est son rôle de vous aider. Préparez-vous à lui montrer le message d'erreur exact que vous obtenez (faites un screenshot ou copiez le texte) et expliquez ce que vous essayiez de faire.

Pour les questions sur DBT lui-même (comment utiliser telle fonction, quelle est la syntaxe de tel concept), la documentation officielle à docs.getdbt.com est excellente. Elle contient des guides, des références complètes, et plein d'exemples.

### Sauvegarder votre travail

Votre travail est stocké localement sur votre machine, dans les dossiers lab que vous créez. Pensez à les sauvegarder régulièrement, surtout si vous êtes fier d'un modèle particulièrement élégant que vous avez créé.

Le plus simple est d'utiliser Git. Initialisez un repository dans chaque dossier de lab, et committez votre travail à chaque étape importante. Vous pouvez même pousser vos commits sur GitHub ou GitLab si vous voulez avoir une sauvegarde en ligne.

Faites juste attention à ne pas committer le fichier `profiles.yml` si vous l'avez copié dans votre projet, surtout si vous utilisez le cloud. Ce fichier contient des credentials et ne devrait jamais être partagé publiquement. Ajoutez-le dans votre `.gitignore`.

## Résolution des problèmes

### Docker ne démarre pas (installation locale)

Si Docker refuse de démarrer, c'est généralement que Docker Desktop n'est pas lancé. Sur macOS, cherchez l'icône de baleine dans votre barre de menu en haut. Sur Windows, cherchez-la dans la zone de notification en bas à droite. Si elle n'est pas là, lancez Docker Desktop depuis vos applications.

Si Docker Desktop est lancé mais que vos conteneurs ne démarrent pas, essayez de redémarrer Docker complètement. Quittez l'application (menu Docker > Quit Docker Desktop), attendez quelques secondes, puis relancez-la. Attendez que l'interface indique que Docker est prêt avant de réessayer votre commande make.

Si le problème persiste, vérifiez que vous avez assez d'espace disque. Docker a besoin d'au moins 10 Go libres pour fonctionner correctement. Vous pouvez libérer de l'espace Docker en lançant `docker system prune -a` (attention, ça supprime tous les conteneurs et images non utilisés).

### Port 5432 déjà utilisé (installation locale)

Cette erreur signifie qu'un autre programme utilise déjà le port 5432, qui est le port par défaut de PostgreSQL. C'est fréquent si vous avez déjà PostgreSQL installé sur votre machine.

Vous avez deux solutions. Soit vous arrêtez l'autre PostgreSQL temporairement (sur macOS : `brew services stop postgresql`, sur Windows : arrêtez le service PostgreSQL depuis les services Windows), soit vous changez le port utilisé par l'environnement de formation.

Pour changer le port, éditez le fichier `.env` dans le dossier `etudiant/local`. Trouvez la ligne `POSTGRES_PORT=5432` et changez-la en `POSTGRES_PORT=5433` (ou n'importe quel autre port libre). Sauvegardez le fichier, puis relancez `make restart`.

Si vous changez le port, pensez à mettre à jour aussi votre fichier `profiles.yml` pour que DBT se connecte sur le bon port.

### Connexion impossible au cloud

Si DBT vous dit qu'il n'arrive pas à se connecter à la base de données cloud, commencez par vérifier votre connexion internet. Ouvrez un navigateur et vérifiez que vous accédez bien à internet normalement.

Ensuite, vérifiez vos credentials dans le fichier `~/.dbt/profiles.yml`. Comparez-les avec ce que le formateur vous a fourni. Une simple faute de frappe dans l'adresse IP, le mot de passe, ou le nom de la base de données empêchera la connexion. Faites particulièrement attention aux espaces en début ou fin de ligne qui peuvent s'être glissés lors du copier-coller.

Si vos credentials sont corrects mais que la connexion échoue toujours, contactez votre formateur. L'instance cloud peut être temporairement arrêtée ou en maintenance. Le formateur pourra vérifier et résoudre le problème rapidement.

### DBT ne trouve pas la commande

Si votre terminal vous dit que la commande `dbt` n'existe pas, c'est que DBT n'est pas installé ou que Python ne trouve pas le dossier où il est installé.

Commencez par vérifier que DBT est bien installé. Lancez `pip list | grep dbt` sur macOS/Linux ou `pip list | findstr dbt` sur Windows. Vous devriez voir apparaître `dbt-core` et `dbt-postgres` dans la liste.

Si DBT n'apparaît pas, réinstallez-le avec `pip install dbt-postgres==1.7.3`. Si vous avez plusieurs versions de Python installées, essayez avec `pip3` au lieu de `pip`.

Si DBT apparaît dans la liste mais que la commande ne fonctionne toujours pas, c'est un problème de PATH. Le dossier où pip installe les commandes n'est pas dans votre PATH système. Sur macOS/Linux, ajoutez cette ligne à votre `~/.bashrc` ou `~/.zshrc` : `export PATH="$HOME/.local/bin:$PATH"`. Sur Windows, ajoutez le dossier Scripts de Python à votre PATH depuis les variables d'environnement.

### Erreurs lors de dbt run

Si `dbt run` échoue avec une erreur SQL, lisez attentivement le message d'erreur. DBT affiche la requête SQL qui a échoué et l'erreur PostgreSQL correspondante. La plupart du temps, c'est une faute de syntaxe dans votre modèle SQL ou une référence à une table qui n'existe pas.

Les erreurs courantes incluent : une virgule manquante ou en trop dans une liste de colonnes, un mot-clé SQL mal orthographié, une référence à une colonne qui n'existe pas, ou l'oubli du point-virgule final (qui n'est pas obligatoire dans DBT mais peut aider).

Si l'erreur parle d'une "relation" qui n'existe pas, c'est que vous référencez une table qui n'a pas été créée. Vérifiez que vous avez bien exécuté `dbt seed` pour charger les données initiales, et que vous utilisez bien la fonction `ref()` de DBT pour référencer d'autres modèles.

N'hésitez pas à lancer `dbt compile` avant `dbt run`. Cette commande compile vos modèles sans les exécuter et affiche le SQL généré. Ça vous permet de voir à quoi ressemble la requête finale avant de l'exécuter pour de vrai.

### Les données ne sont pas à jour

Si vous modifiez un modèle mais que les résultats dans la base de données ne changent pas, c'est peut-être que votre modèle est matérialisé en table et que DBT n'a pas recalculé les données.

Par défaut, DBT ne recrée pas les tables qui existent déjà. Si vous voulez forcer un recalcul complet, ajoutez l'option `--full-refresh` à votre commande : `dbt run --full-refresh`.

Vous pouvez aussi supprimer manuellement la table problématique depuis PostgreSQL avec `DROP TABLE nom_table;`, puis relancer `dbt run`.

### Réinitialisation complète

Si vraiment vous êtes perdu et que rien ne fonctionne plus, le plus simple est de repartir de zéro. Supprimez votre dossier de lab complètement, recopiez le projet starter, et recommencez. Ça prend 30 secondes et ça résout la plupart des problèmes.

Si vous utilisez l'installation locale, vous pouvez aussi réinitialiser complètement l'environnement avec `make clean` suivi de `make setup` depuis le dossier `etudiant/local`. Vous repartez avec une base de données toute propre.

## Aller plus loin

### Documentation DBT

La documentation officielle de DBT à l'adresse docs.getdbt.com est votre meilleure amie pour apprendre. Elle est très bien faite, avec des guides pour débutants, des références complètes de toutes les fonctionnalités, et des best practices.

Commencez par le "Getting Started Guide" si vous voulez approfondir les bases. Consultez la section "Building Models" pour tout savoir sur les différentes matérialisations. Et explorez la section "Testing" pour découvrir comment garantir la qualité de vos données.

La communauté DBT est également très active. Le Discourse officiel (discourse.getdbt.com) et le Slack DBT sont remplis de gens prêts à aider. N'hésitez pas à y poser des questions si vous bloquez sur quelque chose de technique.

### Apprendre le SQL et PostgreSQL

DBT, c'est avant tout du SQL. Si vous voulez progresser en DBT, vous devez progresser en SQL. La documentation PostgreSQL (postgresql.org/docs) est une excellente ressource pour apprendre toutes les subtilités du langage SQL et les fonctions spécifiques à PostgreSQL.

Il existe aussi de nombreux tutoriels en ligne, des cours gratuits, et des plateformes d'exercices comme SQLZoo ou LeetCode qui vous permettent de pratiquer le SQL de façon interactive.

### Découvrir Jinja

DBT utilise Jinja comme moteur de templating. Jinja vous permet d'écrire du SQL dynamique, avec des boucles, des conditions, des variables, etc. C'est ce qui rend DBT si puissant.

La documentation Jinja (jinja.palletsprojects.com) explique toute la syntaxe et les fonctionnalités disponibles. Vous n'avez pas besoin de tout lire, mais savoir faire des boucles `{% for %}`, des conditions `{% if %}`, et utiliser des variables `{{ }}` vous sera très utile.

### Projets personnels

Le meilleur moyen de vraiment apprendre DBT, c'est de l'utiliser sur vos propres projets. Identifiez un petit projet data que vous pourriez faire : analyser vos dépenses personnelles, explorer un dataset public qui vous intéresse, ou reproduire une analyse que vous avez vue quelque part.

Créez un nouveau projet DBT, chargez vos données en seeds ou connectez-vous à une source de données externe, et construisez vos transformations étape par étape. Vous apprendrez dix fois plus en faisant qu'en suivant simplement des tutoriels.

### Contribuer à la communauté

Une fois que vous serez à l'aise avec DBT, vous pourrez contribuer à la communauté. Partagez vos learnings sur un blog ou sur les réseaux sociaux. Répondez aux questions des débutants sur Discourse ou Slack. Créez des packages DBT réutilisables. Ou même contribuez au code open source de DBT sur GitHub.

La communauté DBT est bienveillante et toujours ravie d'accueillir de nouveaux contributeurs, quel que soit votre niveau.

## Contacter le formateur

### Pendant la formation

Pendant la formation, n'hésitez jamais à lever la main pour poser une question. Il n'y a pas de question bête, et ce qui vous bloque bloque probablement d'autres personnes dans la salle qui n'osent pas demander.

Si vous avez un problème technique que le formateur ne peut pas résoudre immédiatement, notez l'erreur et continuez avec un autre exercice pendant qu'il cherche une solution. Vous pourrez revenir au problème plus tard.

### Après la formation

Après la formation, si vous avez des questions ou si vous voulez partager ce que vous avez fait avec DBT, vous pouvez généralement recontacter le formateur par email. Les coordonnées sont normalement fournies au début de la formation.

Vous pouvez aussi rejoindre la communauté SFEIR si vous êtes intéressé par d'autres formations ou événements techniques. Les détails sont disponibles sur le site sfeir.com.

---

Vous êtes maintenant prêt à démarrer la formation. Profitez-en bien, et surtout, amusez-vous avec DBT !
