<!-- .slide: class="with-code"-->
# References

References are how dbt handle dependencies between models and build the DAG at runtime.

It's handled by dbt with the `ref()` macro and it should be the only way for you to reference other models in a `.sql` file.

`/models/companies.sql`
```sql
SELECT company_id, company_name, is_customer
FROM companies
WHERE enabled = 1
```

<br/>

`/models/customers.sql`
```sql
SELECT *
FROM {{ ref('companies') }}
WHERE is_customer = 1
```

Notes:
* DAG = Directed Acyclic Graph
