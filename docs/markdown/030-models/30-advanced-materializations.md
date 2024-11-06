<!-- .slide: class="transition"-->

# Working with _dbt_ models

## Advanced materialization

##==##

<!-- .slide: class="two-column" -->

# Advanced materializations

## incremental

![sfeir-icons big](plus-circle) Allows you to track changes to source data and update only relevant records.

![sfeir-icons big](cpu) Incremental materialization are efficient when working with large datasets, as they avoid recomputing the entire transformation.

![sfeir-icons big](watch) They are commonly used for data pipelines that require frequent updates or near real-time data availability.

##--##

<!-- .slide: data-background="var(--black)" -->

# &nbsp;

## materialized views

![sfeir-icons big](clock) Incremental logic but managed by the database rather than inside dbt. Support starting in dbt 1.6, availability and features depends on the adapter

![sfeir-icons big](git-commit) Combine query performance and the data freshness in a single object.

![sfeir-icons big](refresh-cw) Materialized views may or may not be the good choice for your models, depending on the latency and how often you need to update your data

Notes:
Mviews do not support all features depending on the platform : joins, aggregations, window functions, etc.
MViews support for BigQuery : dbt 1.7+

##==##

# Incremental models strategy

Incremental materialization introduces logic to help reduce computed data and cost.

- Always materialized as table
- Updated with new or updated rows since the last dbt run
- Can be recreated from scratch with `--full-refresh`

To work with incremental models, you need to provide dbt with:

- The logic to filter your new data
- The unicity key (if relevant to your model)

What dbt does under the hood [depends on the adapter](https://docs.getdbt.com/docs/build/incremental-models#supported-incremental-strategies-by-adapter), and is called incremental strategy.

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

## models/sales-append.sql

<!-- {% raw %} -->

```sql
{{
    config(
        materialized='incremental'
    )
}}

SELECT
  id,
  customer_id,
  date,
  status,
  __timestamp
FROM "erp"."sales"

{% if is_incremental() %}
WHERE **timestamp > (SELECT MAX(**timestamp) FROM {{ this }})
{% endif %}
```

<!-- {% endraw %} -->

##==##

<!-- .slide: class="with-code max-height"-->

# Incremental model example

## models/sales-unique.sql

<!-- {% raw %} -->

```sql
{{
    config(
        materialized='incremental',
        unique_key=['datalake_id', ‘collect_date’],
    )
}}

SELECT
  id,
  customer_id,
  date,
  status,
  __timestamp
FROM "erp"."sales"

{% if is_incremental() %}
WHERE **timestamp > (SELECT MAX(**timestamp) FROM {{ this }})
{% endif %}
```

<!-- {% endraw %} -->
