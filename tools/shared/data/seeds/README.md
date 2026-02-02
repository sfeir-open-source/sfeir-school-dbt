# 📊 Seeds Data - SFEIR School DBT

Données CSV utilisées pour les exercices et démos.

## 📋 Fichiers Disponibles

### companies.csv
Entreprises clientes
- `company_id` : ID unique
- `company_name` : Nom de l'entreprise
- `country_code` : Code pays (lien vers countries)
- `founded_year` : Année de création

### customers.csv
Clients individuels
- `customer_id` : ID unique
- `first_name` : Prénom
- `last_name` : Nom
- `email` : Email
- `company_id` : Entreprise (lien vers companies)
- `country_code` : Code pays
- `created_at` : Date de création

### orders.csv
Commandes
- `order_id` : ID unique
- `customer_id` : Client (lien vers customers)
- `order_date` : Date de commande
- `amount` : Montant
- `category_id` : Catégorie (lien vers categories)
- `status` : Statut (pending, completed, cancelled)

### categories.csv
Catégories de produits
- `category_id` : ID unique
- `category_name` : Nom de la catégorie
- `parent_category_id` : Catégorie parente (nullable)

### countries.csv
Liste des pays
- `country_code` : Code ISO (PK)
- `country_name` : Nom du pays
- `continent` : Continent

## 🚀 Utilisation

### Dans un projet dbt

```bash
# 1. Copier les seeds dans votre projet
cp ../../shared/data/seeds/*.csv ./seeds/

# 2. Charger dans la base de données
dbt seed

# 3. Utiliser dans vos modèles
select * from {{ ref('customers') }}
```

### Recharger les données

```bash
# Recharger tout
dbt seed --full-refresh

# Recharger un seed spécifique
dbt seed --select customers --full-refresh
```

## 📊 Relations entre les tables

```
countries
    └─ companies (country_code)
           └─ customers (company_id)
                  └─ orders (customer_id)
                         └─ categories (category_id)
```

## 💡 Exemples de Requêtes

### Chiffre d'affaires par pays

```sql
select
    co.country_name,
    sum(o.amount) as total_revenue
from {{ ref('orders') }} o
join {{ ref('customers') }} cu on o.customer_id = cu.customer_id
join {{ ref('countries') }} co on cu.country_code = co.country_code
where o.status = 'completed'
group by co.country_name
order by total_revenue desc
```

### Top 10 clients

```sql
select
    cu.first_name || ' ' || cu.last_name as customer_name,
    count(o.order_id) as order_count,
    sum(o.amount) as total_spent
from {{ ref('customers') }} cu
join {{ ref('orders') }} o on cu.customer_id = o.customer_id
where o.status = 'completed'
group by customer_name
order by total_spent desc
limit 10
```

## 🔧 Personnalisation

### Ajouter vos propres données

Créez vos propres fichiers CSV dans ce dossier :

```csv
# my_custom_data.csv
id,name,value
1,Item A,100
2,Item B,200
```

Puis chargez-les :
```bash
dbt seed --select my_custom_data
```

### Configuration des seeds

Dans `dbt_project.yml` :

```yaml
seeds:
  mon_projet:
    # Colonnes à caster
    customers:
      +column_types:
        customer_id: integer
        created_at: timestamp
    
    # Seeds à ne pas matérialiser
    +enabled: true
```

## 📚 Documentation

Documentez vos seeds dans `seeds/schema.yml` :

```yaml
version: 2

seeds:
  - name: customers
    description: "Liste des clients"
    columns:
      - name: customer_id
        description: "ID unique du client"
        tests:
          - unique
          - not_null
      - name: email
        tests:
          - unique
```
