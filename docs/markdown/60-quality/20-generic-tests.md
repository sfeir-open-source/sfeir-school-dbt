<!-- .slide -->

# Generic tests

## The easiest part

Generic tests are parameterized queries that accepts arguments.

There are four generic tests that are available out of the box:

1. unique

2. not_null

3. relationships

4. accepted_values

Notes:

- Tests in dbt use SQL count() requests to count rows matching the condition
  - If there are more than 1 result: test fails
  - There are option to define warn / error threshold

##==##

<!-- .slide: class="with-code"-->

# Using a generic test

Tests are declared in models configuration files, at the column or model level:

`models/__models.yml`

```yaml[|5-6,8-13]
models:
  - name: int__sales
    columns:
      - name: order_id
        tests:
          - unique
      - name: order_status
        tests:
          - not_null:
              tags: [ 'fail_on_error' ]
          - accepted_values:
              tags: [ 'warn_on_error' ]
              values: ['COMPLETED', 'CANCELLED', 'PROCESSING', 'WAITING_PAYMENT', 'SHIPPED']
```

Notes:

- You can tag individual tests, and use these tags in dbt test command

##==##

<!-- .slide: class="with-code"-->

# Running tests

How to run tests?

```shell[]
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

<!-- .slide: class="with-code"-->

# Custom generic tests

Custom generic tests are declared in the `/tests/generic` folder.

They require 1 or 2 arguments:

- model _(mandatory)_: the resource on which the test is run
- column*name *(optional)\_: the column on which the test is run
  <!-- {% raw %} -->
  `/tests/generic/customer_code.sql`

```sql[]
{% test valid_id(model, column_name) %}
    SELECT
        {{ column_name }}
    FROM {{ model }}
    WHERE {{ column_name }} !~ '^\d{10}$'
{% endtest %}
```

<!-- {% endraw %} -->

Notes:

- "model" argument can be a model, a source or a snapshot
- column name is optional if the test does not require a column name
- the example checks that a field value is always 10 char long, digits only

##==##

<!-- .slide: class="with-code"-->

# Using custom generic tests

Like any other generic tests, simply use your custom generic test name:

`models/__models.yml`

```yaml[|5,7-8]
models:
  - name: int__sales
    columns:
      - name: order_id
        tests:
          - unique
          - valid_id
              name: "VALID_ORDER_ID"
```
