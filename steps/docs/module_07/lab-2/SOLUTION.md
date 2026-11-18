# Solution

## Create a model with incremental materialization

`models/intermediate/incremental/int__orders_incremental_1.sql`
```sql
{{
  config(
    materialized='incremental',
  )
}}

SELECT
  *
FROM {{ ref("stg__orders") }}

{% if is_incremental() %}
WHERE order_datetime > (SELECT MAX(order_datetime) FROM {{ this }})
{% endif %}
```

## Create a second model with a unique key

`models/intermediate/incremental/int__orders_incremental_2.sql`
```sql
{{
  config(
    materialized='incremental',
    unique_key=['order_id', 'order_line_id']
  )
}}

SELECT
  *
FROM {{ ref("stg__orders") }}

{% if is_incremental() %}
WHERE order_datetime > (SELECT MAX(order_datetime) FROM {{ this }})
{% endif %}
```

## Run dbt twice on the new models and their dependencies

Use this command to run the new models and their dependencies only:

```shell
dbt run -s +intermediate.incremental
```

The first run reads and inserts 10000 lines in both new models.
The second run reads and does not insert any line in either of the models.

## Update the source orders table and run again

```sql
UPDATE "sales"."orders"
SET order_datetime = NOW(), order_status = 'COMPLETED'
WHERE random() < 0.1 AND order_status != 'COMPLETED';
```

Run dbt with the same command and look at the results.

Use count queries to compare the volume of your incremental models.

The difference comes from the unique keys:
- Without unique key, dbt stacks new lines on top of the existing ones
- With unique key, dbt replaces the old lines with the new ones

## Run with full_refresh

Because of the `full_refresh` option, dbt dropped the previous tables and re-created them from scratch.

You actually lost the history of status of orders because it is now changed forever in the source.
