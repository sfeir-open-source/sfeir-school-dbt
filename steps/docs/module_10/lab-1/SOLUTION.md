# Solution

## Contracts

### Add a contract with data types to the stg__orders model

`__models.yml`
```yaml
models:
  - name: stg__orders
    config:
      materialized: table
    contract:
      enforced: true
    columns:
      - name: order_id
        data_type: int
      - name: order_line_id
        data_type: int
      - name: product_id
        data_type: int
      - name: base_price
        data_type: float
      - name: quantity
        data_type: int
      - name: rebate
        data_type: float
      - name: currency
        data_type: char(3)
      - name: order_datetime
        data_type: timestamp
      - name: order_status
        data_type: varchar(32)
      - name: customer_id
        data_type: int
```

### Add / Remove a colum definition in your contract and see what happens

dbt should fail and output the defaults in the contract for easy fixing.

### Add a compound primary key to this model

In the model property file, add the following as primary key:

```yaml
...
constraints:
  - type: primary_key
    columns: [ 'order_id', 'order_line_id' ]
...
```


### Add contraints to columns following the specs below

In the model property file, at the column level, add the following constraints:

```yaml
...
- name: order_id
  data_type: int
  constraints:
    - type: check
      expression: 'order_id > 0'
- name: customer_id
  data_type: int
  constraints:
    - type: not_null
...
```


## Versions

### Refactor your property and SQL files to include a first version if your int__orders model

```yaml
models:
  - name: int__orders
    tests:
      - dbt_expectations.expect_table_columns_to_contain_set:
          column_list: [ "turnover" ]
      - dbt_expectations.expect_table_row_count_to_be_between:
          min_value: 2
    versions:
      - v: 1
```

If you include tests in a specific version, they will only run for this version and not the inherited ones.

## Add a new version of int__orders

```yaml
models:
  - name: int__orders
    latest_version: 1
    tests:
      - dbt_expectations.expect_table_columns_to_contain_set:
          column_list: [ "turnover" ]
      - dbt_expectations.expect_table_row_count_to_be_between:
          min_value: 2
    versions:
      - v: 1
        
      - v: 2
        columns:
          - include: all
            exclude: [country_name]
          - name: total_price
```

## Create a mart model and point to the default version of int__orders

```sql
-- models/institute/orders.sql
SELECT * FROM {{ ref('int__orders') }}
```

When you run this model, you should see a message from dbt about an unpinned recent version not marked as latest.

## Update your mart model and pin the new, not yet official version of int__orders

```sql
-- models/institute/orders.sql
SELECT * FROM {{ ref('int__orders', version=2) }}
```

## Add a near-future or overdue deprecation date to the first version if your model


```yaml
models:
  - name: int__orders
    latest_version: 1
    tests:
      - dbt_expectations.expect_table_columns_to_contain_set:
          column_list: [ "turnover" ]
      - dbt_expectations.expect_table_row_count_to_be_between:
          min_value: 2
    versions:
      - v: 1
        deprecation_date: 2023-12-31 00:00:00.00+00:00
        
      - v: 2
        columns:
          - include: all
            exclude: [country_name]
          - name: total_price
```