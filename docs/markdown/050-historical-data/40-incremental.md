<!-- .slide: class="transition"-->

# Manage historical data

## Incremental materialization


##==##


# Incremental models strategy

Incremental materialization introduces logic to help reduce computed data and cost.

- Always materialized as table
- Updated with new or updated rows since the last `dbt run`
- Can be recreated from scratch with `--full-refresh`

To work with incremental models, you need to provide dbt with:

- The logic to filter your new data
- The unicity key (if relevant to your model)

What dbt does under the hood depends on the adapter, and is called incremental strategy.

Notes:
When supported : MERGE

Otherwise : DELETE AND INSERT within TRANSACTIONS


##==##


# Filtering data for incremental models

Incremental models are built on top of a standard SQL model, with filters wrapped inside the `is_incremental()` macro.

Filters inside the macro will be applied if:

- the materialization of the model is set to “incremental”
- the destination table already exists
- dbt is not running in full-refresh mode

Full-refresh execution mode forces dbt to recreate incremental models from scratch.
It will drop the current table and create new one.

Depending on your incremental logic, full refresh may incur data loss, and is costly for large models because it rebuilds everything.

<!-- .element: class="admonition important" -->


##==##


<!-- .slide: class="with-code max-height"-->

# Incremental model example

## models/staging/sales-append.sql

<!-- {% raw %} -->

```sql
{{
    config(
        materialized='incremental'
    )
}}

SELECT
  datalake_id,
  customer_id,
  collect_date,
  status,
  __timestamp
FROM {{ source("ERP", "sales") }}

{% if is_incremental() %}
WHERE __timestamp > (SELECT MAX(__timestamp) FROM {{ this }})
{% endif %}
```

<!-- {% endraw %} -->


##==##


<!-- .slide: class="with-code max-height"-->

# Incremental model example

## models/staging/sales-unique.sql

<!-- {% raw %} -->

```sql
{{
    config(
        materialized='incremental',
        unique_key=['datalake_id', 'collect_date'],
    )
}}

SELECT
  datalake_id,
  customer_id,
  collect_date,
  status,
  __timestamp
FROM {{ source("ERP", "sales") }}

{% if is_incremental() %}
WHERE __timestamp > (SELECT MAX(__timestamp) FROM {{ this }})
{% endif %}
```

<!-- {% endraw %} -->
