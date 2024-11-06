# Solution

### In a new folder, create a model in your project with the following specifications

`models/institute/incremental/int__orders_incremental_1.sql`
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

### Create a second model with the same specs but with a unique key on order_id and order_line_id


`models/institute/incremental/int__orders_incremental_2.sql`
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

### Run dbt twice on the new models and their dependencies

Use this command to run the new models and their dependencies only:

```bash
dbt run -s +institute.incremental
```

The first run reads and insert 10000 lines in both new models.
The second run reads and does not insert any line in either of the model.

### Update the source orders table with the query provided and run your models again

Run this query to update a random number of orders in your source
```sql
UPDATE "sales"."orders"
SET order_datetime = NOW(), order_status = 'COMPLETED'
WHERE random() < 0.1 AND order_status != 'COMPLETED';
```

Run dbt with the same command and look at the results.

Use count queries to compare the volume of your incremental models.

The difference comes from the unique keys:
    - Without, dbt stacks new lines on top of the existing ones
    - With unique key, dbt replace the old lines with the new ones

### Run the models again with the full_refresh option

Because of the full-refresh option, dbt dropped the previous models and replaced them from scratch.

You actually lost the history of status of orders because it is now changed forever in the source.