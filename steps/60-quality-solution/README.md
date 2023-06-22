# Solution

## Add a test to make sure that customer_id is unique in your source

`models/school/__source.yml`
```yaml
sources:
  - name: seeds
    schema: sfeir_school_seeds
    tables:
      - name: customers
        columns:
          - name: customer_id
            tests:
              - unique
```

## Add another test to make sure that order_status is in the list of accepted values:

`models/school/__source.yml`
```yaml
sources:
  - name: seeds
    schema: sfeir_school_seeds
    tables:
      - name: sales
        columns:
          - name: order_status
            tests:
              - accepted_values:
                  values: ['COMPLETED', 'CANCELLED', 'PROCESSING', 'WAITING_PAYMENT', 'SHIPPED']
```

## Create a singular test to make sure there are always at least 100 rows in the int__sales model

`tests/assert_row_count_sales.sql`
```sql
SELECT * FROM (
  SELECT count(*) AS C FROM {{ ref("int__sales") }}
) AS _ WHERE _.C < 100
```

## Install the dbt_utils and dbt_expectations packages

`packages.yml`
```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
  - package: calogica/dbt_expectations
    version: [">=0.8.0", "<0.9.0"]
```

```shell
$ dbt deps
```

## Use one of this package to make sure that int__sales always has the "turnover" column

`models/school/__models.yml`
```yaml
models:
  - name: int__sales
    tests:
      - dbt_expectations.expect_table_columns_to_contain_set:
          column_list: ["turnover"]
    columns:
      - name: customer_name
        tests:
          - dbt_utils.not_empty_string
```

## Replace your singular test with a generic test from one of the installed packages

`models/school/__models.yml`
```yaml
models:
  - name: int__sales
    tests:
      - dbt_expectations.expect_table_row_count_to_be_between:
          min_value: 100
```

Don't forget to remove your singular test !
