# Solution

## Create and use 2 variables to replace COMPLETED and CANCELLED filter in your stg__sales model

`dbt_project.yml`
```yaml
...
vars:
  sfeir_school:
    status_completed: 'COMPLETED'
    status_cancelled: 'CANCELLED'
```

`models/school/stg__sales.sql`
```sql
SELECT
  *
FROM {{ source("seeds", "sales") }}
WHERE order_status IN ('{{ var("status_completed") }}', '{{ var("status_cancelled")}}')
```

## Change the values at run time using "--vars" to alter models output

```shell
# Don't forget the space after :
$ dbt run --vars 'status_completed: FOOBAR'
# or
$ dbt run --vars '{"status_completed": "NONE"}'
```

## Create another variable to filter orders in int__sales

`dbt_project.yml`
```yaml
...
vars:
  sfeir_school:
    status_completed: 'COMPLETED'
    status_cancelled: 'CANCELLED'
    order_filter: 
```

`models/school/int__sales.sql`
```sql
SELECT
  sales.*
  , customers.customer_name
  , countries.country_name
FROM {{ ref("stg__sales") }} AS sales
    INNER JOIN {{ source("seeds", "customers") }} AS customers ON customers.customer_id = sales.customer_id
    INNER JOIN {{ source("seeds", "countries") }} AS countries ON customers.customer_country = countries.country_code
WHERE TRUE
{% if var("order_filter") %}
    AND order_datetime > '{{ var("order_filter") }}'
{% endif %}
```

## Create and use a macro to compute the turnover of orders in the int__sales model

`macros/macro_turnover.sql`
```sql
{% macro turnover() %}
  (
  (base_price * quantity - rebate)
  * CASE currency
        WHEN 'EUR' THEN 1
        WHEN 'USD' THEN 1.1
    END
  )
{% endmacro %}
```

`models/school/int__sales.sql`
```sql
SELECT
  sales.*
  , customers.customer_name
  , countries.country_name
  , {{ turnover() }} AS turnover
FROM {{ ref("stg__sales") }} AS sales
    INNER JOIN {{ source("seeds", "customers") }} AS customers ON customers.customer_id = sales.customer_id
    INNER JOIN {{ source("seeds", "countries") }} AS countries ON customers.customer_country = countries.country_code
WHERE TRUE
{% if var("order_filter") %}
    AND order_datetime > '{{ var("order_filter") }}'
{% endif %}
```
