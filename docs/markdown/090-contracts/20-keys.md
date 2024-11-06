<!-- .slide: class="transition"-->

# Contracts

## Declaring keys and constraints

##==##

# Declaring keys and constraints

Alongside data types for columns, dbt lets you define additional constraints:

- Primary and Foreign keys
- Uniqueness and not null requirement
- Value check

All constraints are not available for all adapters, and will produce either an error or a warning if they can’t be enforced.

You can add constraints without enforcing contract.

Constraints are enforced in **tables only** and not on views or ephemeral models.

<!-- .element: class="admonition warning" -->

##==##

<!-- .slide: class="with-code max-height"-->

# Declaring keys and constraints

_models/\_\_models.yml_

```yaml
models:
- name: contract_test
  description: "Model to test contract enforcement"
  config:
    contract:
      enforced: true
  constraints: # Model level constraints
  - type: primary_key
    columns: ['id']
    columns:
  - name: id
    data_type: int
    constraints: # Column level constraints
    - type: check
      expression: 'id > 1000000'
  - name: name
    data_type: string
    constraints:
    - type: not_null
```
