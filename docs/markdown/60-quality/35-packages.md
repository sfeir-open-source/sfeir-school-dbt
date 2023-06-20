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

##==##
<!-- .slide: class="with-code"-->
# What about testing models ?

What can we do so far:

* test data quality in sources and models
* test structure of sources and models
* test the freshness of data using `dbt source freshness`

What can we also do ?

* test your dbt code and models generation
  * by implementing unit-tests in dbt
  * that will help you not break anything

Notes:
* For now, we're just testing data in our output models (our sources)
* TDDDD anyone ? Test-Driven-Data-Driven-Decsions ?

##==##
<!-- .slide: class="with-code"-->
# How does unit-testing work ?

It's based on the assumption that you know:

* What data do you have as input --> **mocks**
* What data do you want as output --> **expects**

If the **expected** output of your dbt models does not match the input, then something is broken.

