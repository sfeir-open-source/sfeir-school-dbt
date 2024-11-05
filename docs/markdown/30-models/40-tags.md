<!-- .slide: class="transition"-->

# Working with dbt models

## Introducing tagging feature for metadata organization

##==##

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

Tags can also be applied to seeds, sources, exposures and even columns.

<!-- .element: class="fragment" -->

Notes:

- Tags are not labels in BigQuery -- there is special syntax (dict) in config blocks for that
  Adding tags to columns is used to run a subset of tests on specific columns.

##==##

<!-- .slide: class="with-code"-->

# Tagging example

_models/staging/\_\_models.yml_

```yaml
models:
  - name: customers
    config: # Don't forget the "config" block
      tags: ['staging', 'dimensions']
```

_models/staging/customers.sql_

```sql
{{ config(
    tags=["staging", "dimensions"]
) }}
{{ config(
    tags=["staging", "dimensions"]
) }}

SELECT
    id
    , area
    , CONCAT(firstname, ' ', UPPER(lastname)) AS `name`
FROM
    erp.customers
```

##==##

<!-- .slide: class="with-code"-->

# Use tags at run time

You can use dbt command line arguments to run specific models with tags:

```bash
# Run models with tag “dimension” only
$ dbt test --select tag:dimension

# Run models with tag “dimension” and the underlying models too
$ dbt test --select +tag:dimension

# Run models with tag “dimension” and the underlying models too
# Except models with tag “int”
$ dbt test --select +tag:dimension --exclude tag:int

# Run seeds with tag “reference” only
$ dbt seed -s tag:reference
```
