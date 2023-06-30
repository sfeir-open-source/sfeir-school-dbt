<!-- .slide -->

# The `ref()` macro

References are how _dbt_ handle dependencies between models and build the DAG at runtime.

It's handled by _dbt_ with the `ref()` function, and it should be the only way for you to reference other models in a `.sql` file.

Seeds can be referenced directly with `ref()` using the seed name.

Notes:

- If you don't use the ref() macro, then you're doing it wrong.

##==##

<!-- .slide: class="with-code"-->

# Using the `ref()` macro

`/models/companies.sql`

```sql
SELECT company_id
     , company_name
     , is_customer
FROM companies
WHERE enabled = 1
```

<br/>

<!-- {% raw %} -->

`/models/customers.sql`

```sql[|2]
SELECT *
FROM {{ ref('companies') }}
WHERE is_customer = 1
```

<!-- {% endraw %} -->

Notes:

- DAG = Directed Acyclic Graph
- There is a 2 arguments version of ref(), with the package name as first argument
