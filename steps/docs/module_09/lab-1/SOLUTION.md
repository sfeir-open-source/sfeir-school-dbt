# Solution

## Add a test to make sure that customer_id is unique in your source

`models/institute/__source.yml`
```yaml
sources:
  - name: sales
    database: sfeir
    schema: sales
    tables:
      - name: customers
        columns:
          - name: customer_id
            tests:
              - unique
```

## Add another test to make sure that order_status is in the list of accepted values:

`models/institute/__source.yml`
```yaml
sources:
  - name: sales
    database: sfeir
    schema: sales
    tables:
      - name: orders
        columns:
          - name: order_status
            tests:
              - accepted_values:
                  values: ['COMPLETED', 'CANCELLED', 'PROCESSING', 'WAITING_PAYMENT', 'SHIPPED']
                  name: test_order_status_values
```

## Create a singular test to make sure there are always at least 100 rows in the int__orders model

`tests/assert_row_count_orders.sql`
```sql
SELECT * FROM (
  SELECT count(*) AS C FROM {{ ref("int__orders") }}
) AS _ WHERE _.C < 2
```

## Install the dbt_utils and dbt_expectations packages

`packages.yml`
```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
  - package: calogica/dbt_expectations
    version: 0.10.1
```

```shell
$ dbt deps
```

## Use one of this package to make sure that int__orders always has the "turnover" column

`models/institute/__models.yml`
```yaml
models:
  - name: int__orders
    tests:
      - dbt_expectations.expect_table_columns_to_contain_set:
          column_list: ["turnover"]
    columns:
      - name: customer_name
        tests:
          - dbt_utils.not_empty_string
```

## Replace your singular test with a generic test from one of the installed packages

`models/institute/__models.yml`
```yaml
models:
  - name: int__orders
    tests:
      - dbt_expectations.expect_table_row_count_to_be_between:
          min_value: 2
```

Don't forget to remove (or disable) your singular test to avoid redundancy.
