<!-- .slide -->

# Statement blocks

Statement blocks in _dbt_ models are SQL queries that interact with the database and provide data results to the Jinja
context. 

<br/>

```sql []
{%- call statement('company_names', fetch_result=True) -%}
    select distinct name from {{ ref('companies') }}
{%- endcall -%}

{%- set company_names = load_result('company_names') -%}
{%- set company_names_data = company_names['data'] -%}
  
```

<br/>

The results of these queries can be used to perform calculations, transformations, or reference data in subsequent parts of
the dbt model file.

##==##

# but prefer `run_query`

Statement block wrapper, `run_query` offer a flexible and customizable way to complete transformation capabilities provided by dbt's core features.

<br/>

```sql
{% set query %}
select distinct name from {{ ref('companies') }}
{% endset %}

{% set results = run_query(query) %}
{% do results.print_table() %}

-- do something with `results` here...
```

<br/>

This method should be used wisely. When you execute `run_query`, you should ensure that queries follow best practices,
comply with security guidelines, and are properly tested.
