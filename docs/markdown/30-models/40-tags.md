<!-- .slide -->

# Tagging your ressources

_dbt_ includes the option to tag your models to regroup/filter them.

<br/>
<div>
_tags_ can be defined in:<br/> <br/>

- your `dbt_project.yml` file
- models property file
- models configuration blocks
</div>
<!-- .element: class="fragment" -->

<br/>
<div>
_tags_ accumulate hierarchically:

![center hm-200](./assets/images/docs/markdown/20-project-structure/dbt_configuration_directives.svg)

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

<!-- {% raw %} -->

`models/staging/__models.yml`

```yaml[]
models:
  - name: customers
    config: # Don't forget the "config" block
      tags: ["staging", "dimensions"]
```

<!-- {% endraw %} -->

##==##

<!-- .slide: class="with-code"-->

# Tagging example

`models/staging/customers.sql`

<!-- {% raw %} -->

```sql[4]
{{ config(
    materialized="table",
    schema="school",
    tags=["staging", "dimensions"]
) }}

SELECT
    id
    , area
    , CONCAT(firstname, ' ', UPPER(lastname)) AS `name`
FROM
    customers
```

<!-- {% endraw %} -->
