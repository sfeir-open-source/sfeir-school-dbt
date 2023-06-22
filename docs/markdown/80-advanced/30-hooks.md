<!-- .slide -->

# Hooks 

_dbt_ hooks provide a way to extend the functionality of dbt by incorporating custom logic, database administration or
integrating with external systems or services.

_dbt_ supports several hook types:
* `pre-hook` and `post-hook`: executed before/after a model, seed or snapshot is built.
* `on-run-start` and `on-run-start`: executed at the start/end of `dbt run`, `bt test`, `dbt seed` or `dbt snapshot`

<br/>
<br/>

```sql[]
{{ config(
    post_hook=[
      "alter table {{ this }} ..."
    ]
) }}
```
