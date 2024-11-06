<!-- .slide: class="transition"-->

# Contracts

## Enforcing data type on models

##==##

# Enforcing data type on models

Starting in version 1.5, dbt lets your add **constraints** to your models by using **contracts**.

With enforced contracts, dbt make sure that generated models will match data types defined in the property files.

If the model does not match the requirements specified in the yaml file, it will not be created or replaced.

On the opposite of tests, contracts are checked **before the model is built**, allowing dbt to stop before bad data is materialized in the data warehouse.

Contracts change the way `CREATE TABLE` or `CREATE VIEW` statement are built, and enforce types and constraints this way.

##==##

<!-- .slide: class="with-code"-->

# Enforcing data type on models

_models/\_\_models.yml_

```yaml
models:
  - name: contract_test
    description: 'Model to test contract enforcement'
    config:
      contract:
        enforced: true
    columns:
      - name: id
        data_type: int
      - name: name
        data_type: string
```

_models/contract_test.sql_

```sql
-- Valid request for this contract
SELECT 1 AS id, "Sophie" AS name

-- Invalid request for this contract
SELECT "1" AS id, "Sophie" AS name
```

##==##

<!-- .slide: class="with-code max-height"-->

# Enforcing data type on models

```bash
16:03:03 1 of 1 START sql table model SFEIR_INSTITUTE.DEMO_CONTRACT ................................ [RUN]
16:03:05 1 of 1 ERROR creating sql table model SFEIR_INSTITUTE.DEMO_CONTRACT ....................... [ERROR in 1.73s]
16:03:05
16:03:05 Finished running 1 table model in 0 hours 0 minutes and 4.45 seconds (4.45s).
16:03:05
16:03:05 Completed with 1 error and 0 warnings:
16:03:05
16:03:05 Compilation Error in model DEMO_CONTRACT (models/DEMO_CONTRACT.sql)
This model has an enforced contract that failed.
Please ensure the name, data_type, and number of columns in your contract match the columns in your model's definition.

| column_name | definition_type | contract_type | mismatch_reason    |
| ----------- | --------------- | ------------- | ------------------ |
| __source  | STRING          | INT64         | data type mismatch |

> in macro assert_columns_equivalent (macros/materializations/models/table/columns_spec_ddl.sql)
```
