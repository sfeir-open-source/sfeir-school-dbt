<!-- .slide -->
# What is a model ?

A dbt model is a SELECT statement, written in a `.sql` file.
<!-- .element: class="fragment" -->

* Each SQL file contains only one model
* File name determine the model name
* Models must be defined in directory `models` and its subdirectories
<!-- .element: class="list-fragment" -->


<br/><br/>
During the execution of `dbt run`, the SELECT requests are wrapped in `CREATE VIEW` or `CREATE TABLE` statements.
<!-- .element: class="fragment" -->

Notes:
- There can be more than 1 SELECT statement in each model
- Starting with dbt Core 1.3, it's possible to define models using Python files
- There can't be 2 models with the same name !

##==##
<!-- .slide: class="with-code"-->
# Sample model

`models/staging/customers.sql`
```sql
  SELECT
      id,
      area,
      CONCAT(firstname, ' ', UPPER(lastname)) AS `name`
  FROM customers
```
<br/>

```sql
CREATE VIEW dbt_school.customers AS (
  SELECT
      id,
      area,
      CONCAT(firstname, ' ', UPPER(lastname)) AS `name`
  FROM customers
)
```
<!-- .element: class="fragment" -->


Notes:
- No ";" at the end of the model, or it will generate an error


##==##
<!-- .slide -->
# Model configuration

By default, dbt will create models:

* Using views and not tables
* In the default schema defined in the `dbt_project.yml` file
* Using the `.sql` file name

<br/><br/>

<div>
But it's possible to change this default behavior...<br/>

* In the general dbt_project.yml configuration file
* Directly in the models using `config` blocks
  * Direct config overwrites global dbt_project config
</div>
<!-- .element: class="fragment" -->

##==##
<!-- .slide: class="with-code"-->
# Sample direct configuration

`models/staging/customers.sql`
```sql[6-11|1-4|]
{{ config(
    materialized="table",
    schema="school"
) }}

SELECT
    id,
    area,
    CONCAT(firstname, ' ', UPPER(lastname)) AS `name`
FROM
    customers
```

##==##
<!-- .slide: class="with-code"-->
# Sample dbt_project.yml model configuration

```yaml
name: dbt_school
config-version: 2
...

models:
  dbt_school: # Must match the `name:` config
    +materialized: view # Default configuration for all models
    staging:
      +materialized: table # applies to all models in the `staging` directory
```
