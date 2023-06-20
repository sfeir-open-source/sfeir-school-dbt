<!-- .slide -->
# Packages

Packages are reusable collections of pre-built dbt code with:

* models
* macros
* tests
* etc.

There a different kind of packages:

* official dbt packages provided by dbt
* packages from dbt hub but not provided by dbt
* packages for git code repositories
* your own packages !

Grab all the packages you want from : https://hub.getdbt.com/


##==##
<!-- .slide: class="with-code"-->
# Packages for tests

Rather than rebuilding your own tests, you should use ones provided in packages:

* dbt-labs/dbt_utils (official !)
* calogica/dbt_expectations (community)
* EqualExperts/dbt_unit_testing (community)

`models/__models.yml`
```yaml[]
models:
  - name: int__sales
    columns:
      - name: order_id
        tests:
          - dbt_utils.not_empty_string
          - dbt_utils.accepted_range:
              min_value: 0
              max_value: 999999999
              inclusive: false
```

Notes:
* There are A LOT of test included both in dbt_utils and dbt_expectations
* You can test data but also table structure using dbt_expectations
