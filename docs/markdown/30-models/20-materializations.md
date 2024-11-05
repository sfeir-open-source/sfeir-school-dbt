<!-- .slide: class="transition"-->

# Working with _dbt_ models

## Materialization options

##==##

<!-- .slide: class="two-column" -->

# Materialization strategies

## view

![sfeir-icons big](plus-circle) <span style="vertical-align:top">Default materialization in dbt. Good choice for low compute models like renaming or recasting.</span>

![sfeir-icons big](cpu) <span style="vertical-align:top">Does not use storage in your warehouse, but uses compute time every time you read from it. Beware of stacking too many views on top of each others.</span>

![sfeir-icons big](watch) <span style="vertical-align:top">Very fast to create at build time. Data may vary each time you read from a view.</span>

##--##

<!-- .slide: data-background="var(--black)" -->

# &nbsp;

## table

![sfeir-icons big](clock) <span style="vertical-align:top">Very fast to query, but can be long to (re)create at each run.</span>

![sfeir-icons big](git-commit) <span style="vertical-align:top">Must be refreshed to include updates to underlying sources.</span>

![sfeir-icons big](refresh-cw) <span style="vertical-align:top">Preferred choice for models exposed as data products or use cases, and models used as reference by many other models.</span>

##==##

<!-- .slide: class="two-column" -->

# Materialization strategies

## ephemeral

![sfeir-icons big](plus-circle) <span style="vertical-align:top">Creates temporary tables in the data warehouse for the duration of a single dbt run or query.</span>

![sfeir-icons big](cpu) <span style="vertical-align:top">Used for intermediate calculations or as intermediate areas in complex data transformations.</span>

![sfeir-icons big](watch) <span style="vertical-align:top">Offers a flexible and efficient way to manage temporary data transformations and calculations within your dbt workflows.</span>

##--##

<!-- .slide: data-background="var(--black)" -->

# &nbsp;

## Advanced materializations

- Incremental

- Materialized views
