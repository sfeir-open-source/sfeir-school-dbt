## Module 3 - Lab 1 - Solution

#### Use the SQL provided to create a simple "products" model.

In the `models/institute` subdirectory, create a file name "products.sql" and simply copy the SQL from sample.

#### Execute `dbt run` command and see what happens

The problem is the ";" at the end of the SQL.

Indeed, dbt wraps your SQL code in a CREATE TABLE or CREATE VIEW, and this would produce invalid SQL.

#### Copy the SQL file (keep the same name) in another subdirectory within models and run dbt again

dbt cannot run because there is a naming conflict: all models name must be unique in your project.

#### Create a model definition file, referencing this new model

In the same folder, create a YAML file (for instance `__models.yml`) with this content:

```yaml
models:
  - name: products
  - name: customers
```

#### Rename the model file only and re-run `dbt run` --> what happens ?

A new model with the new name is created by dbt, which also outputs a warning because the property file references an inexisting model.

#### Change the destination schema to "lab" using your dbt_project file

```yaml
...
...
models:
    sfeir_institute:  # Don't forget the name of your project here...
        institute:
            +schema: lab
            +materialized: table
...
```

The actual target schema will be "xxx_lab", and not just "lab" (xxx is your default schema name in profiles.yml)

#### Add tags "institute" and "static" to your model using 3 different methods

In the SQL file:

```sql
{{ config(
    tags=["institute", "static"]
) }}
-- SQL below this line
```

In the models definition file:

```yaml
models:
  - name: products
    config:
      tags:
        - institute
        - static
```

In the dbt_project file:

```yaml
...
models:
  sfeir_institute:  # Don't forget the name of your project here...
    institute:
      +schema: lab
      +materialized: table
      +tags: ["institute", "static"]
...
```