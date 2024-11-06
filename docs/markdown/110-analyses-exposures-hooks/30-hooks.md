<!-- .slide: class="transition"-->

# Analyses, Exposures and Hooks

## Execute custom code before and after dbt runs

##==##

# Executing custom code

Using hooks, dbt allows the execution of custom code, like administrative SQL queries, at different time during execution:

- Before or after a seed, model or snapshot is built

  - `pre-hook` and `post-hook`

- Before or after a dbt run/build/compile/seed/snapshot/test/docs command execution
  - on-run-start and on-run-end

Common usages are:

- Executing a dbt macro
- Vacuum cleaning and administrative operations
- Creating indexes
- Creating UDFs (user defined functions)
- Exporting data to cloud storages

Notes:
In recent dbt version, grant operations should leverage the “grant” properties of models and not hooks anymore, unless for specific cases.

##==##

<!-- .slide:-->

# Executing custom code

Hooks can be declared in config blocks, property files or even the `dbt_project.yml` file, but they are **cumulative** and respect an order of execution.

Models, seeds and snapshot support both type of hooks, using the same syntax.

Macros can be used in hooks, and return a valid SQL query sent to the adapter.

Some adapters run dbt queries inside SQL transactions: use helper macros (`before_begin` and `after_commit`) or dictionary syntax to avoid errors in this specific case.

<!-- .element: class="admonition warning" -->

##==##

<!-- .slide: class="with-code max-height"-->

# Declaring a hook in a model

_models/customers.sql_

```sql
{{ config(
  post_hook = "EXPORT DATA
  OPTIONS (
    uri = 'gs://bucket/folder/{{ this }}.csv',
    format = 'CSV',
    overwrite = true,
    header = true,
    field_delimiter = ';')
AS (
  SELECT \*
  FROM {{ this }}
);"
) }}

SELECT customer_id, customer_firstname, customer_lastname
FROM {{ ref('stg_customers') }}
```

##==##

# Before-run and after-run

`on-run-start` and `on-run-end` are project-wide hooks and defined in the `dbt_project.yml` file only.

Like hooks, they are mostly used for administrative queries but are not linked to a particular model, seed or snapshot.

dbt does not run the `on-run-start` nor `on-run-end` hooks if it has nothing else to do (empty result selector).

If an error occurs in the `on-run-start` sequence, dbt does **not** stop execution.

Notes:
Once again : administrative use, your pipeline should not depend on.
