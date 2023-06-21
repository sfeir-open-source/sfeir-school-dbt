# Solution

## Using your dbt_project.yml file, change the destination schema of all your seeds

```yaml
...
seeds:
  schema: seeds
```

or:

```yaml
...
seeds:
  sfeir_school:
    schema: seeds
```

## Look in the documentation to remove the "seed_" part of the destination seed tables

`seeds/__seeds.yml`
```yaml
seeds:
  - name: seed_categories
    config:
      alias: categories
  - name: seed_companies
    config:
      alias: companies
  - name: seed_countries
    config:
      alias: countries
  - name: seed_customers
    config:
      alias: customers
  - name: seed_sales
    config:
      alias: sales
```

## Update the "categories" seeds to explicitely define column types:

`seeds/__seeds.yml`
```yaml
...
seeds:
  - name: seed_categories
    config:
      alias: categories
    column_types:
      - category_code: varchar(8)
      - category_name: varchar(32)
      - enabled: boolean
      - date_in: timestamp
...
```
