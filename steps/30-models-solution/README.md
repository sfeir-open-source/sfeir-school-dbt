# Solution

## Use the SQL provided to create a simple "products" model.

In the `models/school` subdirectory, create a file name "products.sql" and simply copy the SQL from sample.

## Create a model definition file, referencing this new model

In the same folder, create a YAML file (for instance `__models.yml`) with this content:

```yaml
version: 2

models:
  - name: products
```

## Rename the model file only and re-run `dbt run` --> what happens ?

A new model with the new name is created by dbt, which also outputs a warning because the definition file references a inexisting model.

## Change the destination schema to "lab" using your dbt_project file

```yaml
...
...
models:
    sfeir_school:  # Don't forget the name of your project here...
        school:
            schema: lab
...
```

The actual target schema will be "sfeir_school_lab", and not just "lab" !

## Add tags "school" and "static" to your model using 3 different methods

In the SQL file:

```sql
{{ config(
    tags=["school", "static"]
) }}
-- SQL below this line
```

In the models definition file:

```yaml
version: 2

models:
  - name: products
    tags:
      - school
      - static
```

In the dbt_project file:

```yaml
...
models:
    sfeir_school:  # Don't forget the name of your project here...
        school:
            schema: lab
            tags: ["school", "static"]
...
```

## Add a description and the column list in the definition file 

```yaml
version: 2

models:
  - name: products
    description: "My sample model for dbt school"
    tags:
      - school
      - static
    columns:
      - name: product_name
      - name: product_category
      - name: product_type
      - name: stock
      - name: weight
      - name: shipping_cost
      - name: product_price
```
