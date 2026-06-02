<!-- .slide: class="transition"-->

# _dbt_ Sources and References

## Working with _dbt_ references


##==##


# The `ref()` macro

References are how dbt handle dependencies between models and build the DAG at runtime.

It's handled by dbt with the `ref()` function, and it must be the only way to reference other models in a `.sql` file.

Never, ever, reference a model without using the `ref()` macro

<!-- .element: class="admonition warning" -->

Notes:

- If you don't use the ref() macro, then you're doing it wrong.


##==##


<!-- .slide: class="with-code"-->

# Using the `ref()` macro

`/models/staging/sap/stg__companies.sql`

```sql
SELECT
      company_id
      , company_name
      , is_customer
FROM {{ source('SAP', 'MCMPY') }}
WHERE enabled = 1
```

<br/>

`/models/intermediate/int__customers.sql`

```sql[2]
SELECT *
FROM {{ ref('stg__companies') }}
WHERE is_customer = 1
```

Notes:

- DAG = Directed Acyclic Graph
- There is a 2 arguments version of ref(), with the package name as first argument
