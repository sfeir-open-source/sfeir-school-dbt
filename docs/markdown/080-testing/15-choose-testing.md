<!-- .slide: class="transition"-->

# Testing

## Choose the appropriate test

##==##

<!-- .slide:-->

# Choosing the right test

| Test type      | Target                                  | Pros/cons                                                              |
| -------------- | --------------------------------------- | ---------------------------------------------------------------------- |
| Generic        | Models, Sources                         | Available in dbt core and community packages<br>Very easy to implement |
| Singular       | Models, Sources, business logic, macros | Option to test any custom logic<br>Written in SQL                      |
| Custom generic | Models, Sources                         | Complement to the default generic tests<br>Easy to implement           |
| Unit           | Code logic, SQL validity                | Used in CI/CD to prevent regression<br>More complex to implement       |

##==##

# Generic tests

**The easiest part**

Generic tests are parameterized queries that accepts arguments.

There are four generic tests that are available out of the box:

1. unique
1. not_null
1. relationships
1. accepted_values

##==##

<!-- .slide: class="with-code max-height"-->

# Using a generic test

Tests are declared in models configuration files, at the column or model level.

**models/\_\_models.yml**

```yaml[5-6,8-13]
models:
  - name: int__sales
    columns:
      - name: order_id
        data_tests:
          - unique
      - name: order_status
        data_tests:
          - not_null:
            tags: ['fail_on_error']
          - accepted_values:
            tags: ['warn_on_error']
            values: ['COMPLETED', 'CANCELLED', 'PROCESSING', 'WAITING_PAYMENT', 'SHIPPED']
```

##==##

<!-- .slide: class="with-code"-->

# Running tests

How to run tests?

```bash
# Will run all the tests without any filter
$ dbt test

# Will compile, execute models and run tests afterwards
$ dbt build

# Will only run tests with tag "fail_on_error"
$ dbt test --select tag:fail_on_error

# Will only run tests with tag "fail_on_error" AND the model `int__sales`
$ dbt test --select tag:fail_on_error,int__sales
```

##==##

# Custom Generic tests

Custom generic tests are declared in the `/tests/generic` folder.

They require 2 arguments:

- `model` (mandatory): the resource on which the test is run
- `column_name` (optional): the column on which the test is run

##==##

<!-- .slide: class="with-code"-->

# Custom generic tests

_tests/generic/validator/id.sql_

<!-- {% raw %} -->

```sql
{% test valid_id(model, column_name) %}
  SELECT
    {{ column_name }}
  FROM {{ model }}
  WHERE {{ column_name }} !~ '^\d{10}$'
{% endtest %}
```

<!-- {% endraw %} -->

Notes:
If the test return at least 1 row, then it means it failed

Those tests are ideal candidates for packages

##==##

<!-- .slide: class="with-code"-->

# Using custom generic test

Like any other generic tests, simply use your custom generic test name:

_models/\_\_models.yml_

```yaml[5,7-8]
models:
- name: int__sales
  columns:
  - name: order_id
    data_tests:
      - unique
      - valid_id
        name: "VALID_ORDER_ID"
```

##==##

# Singular tests

A singular test is a custom SQL query that returns failing rows.

dbt runs a `count(*)` on the defined query:

- If there is at least 1 result, the test fails
- If there is 0 result, the test pass

You have to write a SQL file with your custom query.

##==##

<!-- .slide: class="with-code"-->

# Singular tests

_tests/assert_total_payment_amount_is_positive.sql_

```sql
SELECT
  order_id,
  SUM(amount) AS total_amount
FROM {{ ref('fct_payments' )}}
GROUP BY 1
HAVING NOT(total_amount >= 0)
```

##==##

<!-- .slide: class="with-code"-->

# Test macros with singular tests

Singular tests are good candidates to test your custom macros.

Simply write asserts that would fail if your macros changes or breaks.

_tests/assert_macro_turnover_ok.sql_

```sql
SELECT
  'case1' AS case_name,
  10 AS base_price,
  2 AS quantity,
  5 AS rebate,
  {{ turnover(true) }} AS turnover
EXCEPT DISTINCT
-- Write your expectation here
SELECT
  'case1', 10, 2, 5, 15
```

##==##

<!-- .slide: class="with-code"-->

# Packages for tests

Rather than rebuilding your own tests, you should use ones provided in packages:

- dbt-labs/dbt_utils (official !)
- calogica/dbt_expectations (community)
- EqualExperts/dbt_unit_testing (community)

_models/\_\_models.yml_

```yaml
models:
  - name: int__sales
    columns:
      - name: order_id
        data_tests:
          - dbt_utils.not_empty_string
          - dbt_utils.accepted_range:
            min_value: 0
            max_value: 999999999
            inclusive: false
```
