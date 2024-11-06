<!-- .slide: class="transition"-->

# Working with dbt models

## Understanding dbt models

##==##

<!-- .slide -->

# What is a model?

A _dbt_ model is a `SELECT` statement, written in a `.sql` file.

- Each SQL file contains only one model
- File name determine the model name
- Models must be defined in directory `models` and its subdirectories

<br/><br/>
During the execution of `dbt run`, `SELECT` requests are wrapped in `CREATE VIEW` or `CREATE TABLE` statements.

Notes:

- There can be more than 1 SELECT statement in each model
- Starting with dbt Core 1.3, it's possible to define models using Python files
- There can't be 2 models with the same name !
  With specific adapters (Snowflake, Databricks, BigQuery), a model can also be a Python file. This is used for very specific use cases where something cannot be achieved in SQL.

It is actually a way to run PySpark code via dbt and requires additional setup.

##==##

<!-- .slide:-->

# How to organize models ?

Models exist at differents stages of your dbt projects, and a common pattern is to organize them in folders:

- staging
- with one folder per source
- with base subfolders if you need to create base models
- intermediate
- marts (or output)

Inside these folders, you should also regroup models together, by domain, type, etc.

- staging/sap
- staging/salesforce
- intermediate/forecast/dimensions
- intermediate/forecast/facts

Even within folders, your dbt model file name must remain globally unique !

<!-- .element: class="admonition important" -->

Notes:
Example of base models : you have the same customers system in multiple regions, with the sames columns, and you union all of them before using them to create your clean, staging models.

Example 2 of base models : you have your customers and deleted customers in 2 differents sources and want to join them as one : create 2 base models and join them in the staging area.

##==##

<!-- .slide:-->

# Use folder to run part of your project

When organized in folders, you can specify which part of your project your want to run using selectors:

```bash
# Run models in the staging folder only
$ dbt run --select "staging"

# Run models in the staging and intermediate folder only
$ dbt run --select "staging intermediate"

# Include full relative path if using slash separator
$ dbt run --select "models/staging/customers"

# Do not include root models path if using dot separator
$ dbt run --select "staging.customers"
```

##==##

<!-- .slide: class="transition"-->

# Working with dbt models

## How do _dbt_ models work?

##==##

<!-- .slide: class="with-code"-->

# Sample model

The model `models/staging/customers.sql`

```sql
SELECT
  id
  , area
  , CONCAT(firstname, ' ', UPPER(lastname)) AS `name`
FROM customers
```

<br/>

will produce the following query:

<!-- .element: class="fragment" data-fragment-index="1" -->

```sql
CREATE VIEW dbt_school.customers AS (
  SELECT
    id
    , area
    , CONCAT(firstname, ' ', UPPER(lastname)) AS `name`
  FROM customers
)
```

<!-- .element: class="fragment" data-fragment-index="1" -->

Notes:

- No ";" at the end of the model, or it will generate an error

##==##

<!-- .slide:-->

# Sample model with CTEs

/models/staging/customers.sql

```sql
WITH _customers AS (
    SELECT id, area, firstname, lastname, country_id FROM erp.customers
),
_countries AS (
    SELECT country_id, country_name FROM erp.countries
)
SELECT * FROM _customers JOIN _countries USING (country_id)
```

Will actually be compiled and run as :

<!-- .element: class="fragment" data-fragment-index="1" -->

```sql
CREATE VIEW sfeir_institute.customers AS (
  WITH _customers AS (
      SELECT id, area, firstname, lastname, country_id FROM erp.customers
  ),
  _countries AS (
      SELECT country_id, country_name FROM erp.countries
  )
  SELECT * FROM _customers JOIN _countries USING (country_id)
)
```

<!-- .element: class="fragment" data-fragment-index="1" -->

Notes:
CTE = Common Table Expression

##==##

<!-- .slide -->

# Model configuration

By default, _dbt_ will create models:

- Using views and not tables
- In the default schema defined in the `dbt_project.yml` file
- Using the `.sql` file name

<br/>

<div>
But it's possible to change this default behavior: <br/>

- In the `dbt_project.yml` configuration file
- In the models definition files
- Directly in models using `config` blocks

</div>
<!-- .element: class="fragment" -->

##==##

<!-- .slide: class="with-code"-->

# dbt_project.yml model configuration

```yaml
name: sfeir_institute
config-version: 2
---
models:
  sfeir_institute: # Must match the `name` configuration
    +materialized: view # Default configuration for all models
    staging:
      +materialized: table # applies to all models in the `staging` directory
```

##==##

<!-- .slide: class="with-code"-->

# Models property file

## models/staging/\_\_models.yml

```yaml
models:
  - name: customers
    config:
      materialized: table
    description: 'Complete list of customers from all sources'
    columns:
      - name: __source
        description: 'Primary source of customer data'
      - name: customer_id
      - name: first_name
      - name: last_name
```

Notes:
Beware of what goes in config and what does not

##==##

<!-- .slide: class="with-code"-->

# Sample direct configuration

`models/staging/customers.sql`

```sql[6-11|1-4]
{{ config(
    materialized="table",
    schema="school"
) }}

SELECT
    id
    , area
    , CONCAT(firstname, ' ', UPPER(lastname)) AS `name`
FROM
    customers
```

Notes:
You can only change config settings here, not declare columns, contracts, etc.

##==##

# Models property file

Models configuration is an important part of using dbt:

- Define **how** to materialize and **where**
- **Describe** the content of your models
- Add **contracts, constraints, tests**
- Include **documentation** directly in your project
- Use pre-**hooks** and post-hooks
- **Tag** your models

<br>
<br>

A complete dbt project includes **both** SQL files and definition files.

##==##

<!-- .slide: class="with-code max-height"-->

# Models property file

## /models/staging/\_\_models.yml

```yaml
models:
  - name: <model-name>
    description: <string>
    columns: ...
    config:
      enabled: true | false
      materialized: view | table | ephemeral | incremental
      tags: <string> | [<string>]
      pre-hook: <sql-statement> | [<sql-statement>]
      post-hook: <sql-statement> | [<sql-statement>]
      database: <string>
      schema: <string>
      alias: <string>
      persist_docs: <dict>
      full_refresh: <boolean>
      meta: { <dictionary> }
      grants: { <dictionary> }
      contract: { <dictionary> }
```
