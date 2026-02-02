# ☁️ Connection Cloud Étudiant

Se connecter à l'environnement PostgreSQL fourni par le formateur.

## 🎯 Objectif

Utiliser la base de données partagée hébergée sur Google Cloud Platform au lieu d'installer PostgreSQL localement.

## 🚀 Prérequis

- **Python 3.8+**
- **dbt-postgres** installé
- **Credentials fournis par le formateur**

## 📋 Instructions

### 1. Obtenir les credentials

Le formateur vous a fourni un dossier `credentials/` contenant :
- `README.md` : Instructions
- `profiles.yml` : Configuration dbt
- `connection-info.txt` : Informations de connexion

### 2. Installer dbt

```bash
pip install dbt-postgres==1.7.3
```

### 3. Configurer le profile dbt

**Option A : Copier le fichier fourni**
```bash
# macOS/Linux
cp profiles.yml ~/.dbt/profiles.yml

# Windows
copy profiles.yml %USERPROFILE%\.dbt\profiles.yml
```

**Option B : Créer manuellement**

Créez le fichier `~/.dbt/profiles.yml` avec :

```yaml
sfeir_student:
  target: dev
  outputs:
    dev:
      type: postgres
      threads: 4
      host: <IP_FOURNIE>
      port: 5432
      user: dbt
      pass: <PASSWORD_FOURNI>
      dbname: sfeir_dbt  # ou student_XX selon attribution
      schema: public
```

### 4. Tester la connexion

```bash
dbt debug
```

Vous devriez voir :
```
All checks passed!
```

## 📊 Travailler sur les Labs

### Démarrer un lab

```bash
# 1. Copier le projet starter
cp -r ../shared/dbt-projects/starter ./mon-lab

# 2. Aller dedans
cd mon-lab

# 3. Vérifier la connexion
dbt debug

# 4. Charger les données (si nécessaire)
dbt seed

# 5. Exécuter
dbt run
```

## 🔧 Configuration Rapide

### Makefile pour simplifier

```bash
make connect  # Tester la connexion
make help     # Voir les commandes
```

## 🧪 Tests

### Test rapide avec psql

Si vous avez `psql` installé :

```bash
psql "host=<IP> port=5432 dbname=sfeir_dbt user=dbt sslmode=require"
```

### Test avec dbt

```bash
dbt debug      # Tester la connexion
dbt --version  # Vérifier dbt
```

## 🐛 Troubleshooting

### "Could not connect to server"

**Causes possibles :**
1. Mauvaise IP/credentials
2. Pas de connexion Internet
3. Instance arrêtée

**Solutions :**
```bash
# Vérifier votre connexion Internet
ping google.com

# Vérifier les credentials dans profiles.yml
cat ~/.dbt/profiles.yml

# Tester avec psql
psql "host=<IP> port=5432 dbname=sfeir_dbt user=dbt sslmode=require"
```

### "Connection timed out"

L'instance cloud peut prendre quelques minutes à démarrer. Contactez le formateur.

### "Password authentication failed"

Vérifiez le mot de passe dans `profiles.yml`. Attention aux espaces !

### "Database does not exist"

Vérifiez le nom de la base de données. Vous avez peut-être une base dédiée comme `student_01`.

## 💡 Conseils

### Éviter les problèmes réseau

- **Connexion stable** : Utilisez une connexion Internet fiable
- **VPN** : Désactivez le VPN si problèmes de connexion
- **Firewall** : Autorisez les connexions sortantes sur le port 5432

### Optimiser les performances

```yaml
# Dans profiles.yml
outputs:
  dev:
    threads: 2  # Réduire si connexion lente
```

### Travailler hors ligne

Si vous devez travailler hors ligne, utilisez le [setup local](../local/README.md) à la place.

## 🔐 Sécurité

⚠️ **Important** :
- Ne partagez **JAMAIS** vos credentials
- Ne commitez **PAS** `profiles.yml` dans Git
- Changez le mot de passe après la formation (demandez au formateur)

### .gitignore recommandé

```gitignore
# dbt
profiles.yml
*.secret
credentials/
```

## 📚 Comparaison Local vs Cloud

| Critère | Local | Cloud |
|---------|-------|-------|
| Setup | Installation Docker | Juste dbt |
| Internet | Pas nécessaire | Requis |
| Performance | Rapide | Dépend du réseau |
| Coût | Gratuit | Gratuit (formateur paie) |
| Autonomie | Complète | Dépend du formateur |

## 🔄 Passer au Setup Local

Si vous préférez travailler en local :

```bash
cd ../local
make setup
```

Voir le [Guide Local](../local/README.md)

## 🆘 Support

En cas de problème :
1. Vérifiez cette documentation
2. Testez avec `dbt debug`
3. Vérifiez vos credentials
4. Contactez le formateur

## 📞 Contact Formateur

En cas de problème persistant, contactez le formateur avec :
- Le message d'erreur complet
- Votre nom de base de données (ex: `student_05`)
- Le résultat de `dbt debug`
