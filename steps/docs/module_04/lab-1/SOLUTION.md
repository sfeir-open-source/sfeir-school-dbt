# Solution

### Create sources with the provided tables

`models/institute/__sources.yml`
```yaml
sources:
  - name: sales
    schema: sales
    tables:
      - name: categories
      - name: companies
      - name: customers
      - name: countries
      - name: orders
```

### Create a "stg__orders" model using the sales source, with completed and cancelled orders only

`/models/institute/stg__orders.sql`
```sql
SELECT
  *
FROM {{ source("sales", "orders") }}
WHERE 
  order_status IN ('COMPLETED', 'CANCELLED')
```

### Use this model and join with customers and countries to create "int__orders"

You should create staging tables first. Don't mix source() and ref() in the same "int" model.

`/models/institute/int__orders.sql`
```sql
SELECT
  orders.*
  , customers.customer_name
  , countries.country_name
FROM {{ ref("stg__orders") }} AS orders
    INNER JOIN {{ ref("stg__customers") }} AS customers ON customers.customer_id = orders.customer_id
    INNER JOIN {{ ref("stg__countries") }} AS countries ON customers.customer_country = countries.country_code
```

### Run a single model, then all the depending models, or the dependencies of this model 

```
$ dbt run --select int__orders 
$ dbt run --select +int__orders 
$ dbt run --select stg__orders+
```

### Add column list to your "int_orders" model and then modify the model and property file

Nothing will happen if you add columns to the model or the property file because it's declarative only and there is no control. Yet...

### Create 2 new models referencing each others respectively

dbt will not run because of the circular reference: it cannot create an DAG with a correct order of execution.

# Bonus

### Add freshness configuration to the sales source

`models/institute/__sources.yml`
```yaml
sources:
  - name: sales
    schema: sales
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

### Try avoiding the creation of the filtered sales model in your database

`models/institute/__models.yml`
```yaml
models:
  - name: stg__orders
    config:
      materialized: ephemeral
  - name: int__sales
```
