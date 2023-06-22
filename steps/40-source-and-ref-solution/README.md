# Solution

## Create a "stg__sales" model using the sales seed, with completed and cancelled orders only

`/models/school/stg__sales.sql`
```sql
SELECT
  *
FROM {{ ref("seed_sales") }}
WHERE 
  order_status IN ('COMPLETED', 'CANCELLED')
```

## Use this model and join with customers and countries to create "int__sales"

`/models/school/int__sales.sql`
```sql
SELECT
  sales.*
  , customers.customer_name
  , countries.country_name
FROM {{ ref("stg__sales") }} AS sales
    INNER JOIN {{ ref("seed_customers") }} AS customers ON customers.customer_id = sales.customer_id
    INNER JOIN {{ ref("seed_countries") }} AS countries ON customers.customer_country = countries.country_code
```

## Create sources with the 5 seed tables, as if they were in another database

`models/school/__sources.yml`
```yaml
sources:
  - name: seeds
    schema: sfeir_school_seeds
    tables:
      - name: customers
      - name: countries
      - name: sales
      - name: categories
      - name: companies
```

## Replace your 2 models with sources instead of reference to seeds

`models/school/stg__sales.sql`
```sql
SELECT
  *
FROM {{ source("seeds", "sales") }}
WHERE order_status IN ('COMPLETED', 'CANCELLED')
```

`models/school/int__sales.sql`
```sql
SELECT
  sales.*
  , customers.customer_name
  , countries.country_name
FROM {{ ref("stg__sales") }} AS sales
    INNER JOIN {{ source("seeds", "customers") }} AS customers ON customers.customer_id = sales.customer_id
    INNER JOIN {{ source("seeds", "countries") }} AS countries ON customers.customer_country = countries.country_code
```

## Generate and serve documentation

```shell
$ dbt docs generate
$ dbt docs serve
```

# Bonus

## Add freshness configuration to the sales source

`models/school/__sources.yml`
```yaml
sources:
  - name: seeds
    schema: sfeir_school_seeds
    tables:
      - name: customers
      - name: countries
      - name: sales
        freshness:
          warn_after: {count: 7, period: day}
          error_after: {count: 30, period: day}
        loaded_at_field: order_datetime
      - name: categories
      - name: companies
```

To make the command fail, change the period for warn and error (you can use negative numbers if needed...)

## Try avoiding the creation of the filtered sales model in your database

`models/school/__models.yml`
```yaml
models:
  - name: stg__sales
    config:
      materialized: ephemeral
  - name: int__sales
```
