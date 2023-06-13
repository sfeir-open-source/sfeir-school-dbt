<!-- .slide -->
# Tagging your ressources

dbt includes the option to tag your models to regroup / filter them.

<br/>
<div>
Tags can be defined...<br/>

* In your `dbt_project.yml` file
* In models property file
* In models configuration blocks
</div>
<!-- .element: class="fragment" -->

<br/>
<div>
Tags accumulate hierarchically:

&nbsp;&nbsp;&nbsp;&nbsp;dbt_project file < Model property file < Model file config block
</div>
<!-- .element: class="fragment" -->

Notes:
- Tags are not labels in BigQuery -- there is special syntax (dict) in config blocks for that

##==##
<!-- .slide: class="with-code"-->

# Tagging example

`dbt_project.yml`
```yaml[]
...
models:
  dbt_school:
    +tags: ["sfeir", "school"]
    staging:
      +tags: "staging-models"
    intermediate:
      +tags:
        - "intermediate-models"
```


`models/staging/__models.yml`
```yaml[]
models:
  - name: customers
    config: # Don't forget the "config" block
      tags: ["staging", "dimensions"]
```

##==##
<!-- .slide: class="with-code"-->

# Tagging example 2

`models/staging/customers.sql`
```sql[4]
{{ config(
    materialized="table",
    schema="school",
    tags=["staging", "dimensions"]
) }}

SELECT
    id,
    area,
    CONCAT(firstname, ' ', UPPER(lastname)) AS `name`
FROM
    customers
```

