<!-- .slide: class="transition"-->

# Working with _dbt_ models

## Materialization options

##==##

<!-- .slide: class="two-column" -->

# Materialization strategies

## view

![sfeir-icons big](plus-circle) Default materialization in dbt. Good choice for low compute models like renaming or recasting.

![sfeir-icons big](cpu) Does not use storage in your warehouse, but uses compute time every time you read from it. Beware of stacking too many views on top of each others.

![sfeir-icons big](watch) Very fast to create at build time. Data may vary each time you read from a view.

##--##

<!-- .slide: data-background="var(--black)" -->

# &nbsp;

## table

![sfeir-icons big](clock) Very fast to query, but can be long to (re)create at each run.

![sfeir-icons big](git-commit) Must be refreshed to include updates to underlying sources.

![sfeir-icons big](refresh-cw) Preferred choice for models exposed as data products or use cases, and models used as reference by many other models.

##==##

<!-- .slide: class="two-column" -->

# Materialization strategies

## ephemeral

![sfeir-icons big](plus-circle) Creates temporary tables in the data warehouse for the duration of a single dbt run or query.

![sfeir-icons big](cpu) Used for intermediate calculations or as intermediate areas in complex data transformations.

![sfeir-icons big](watch) Offers a flexible and efficient way to manage temporary data transformations and calculations within your dbt workflows.

##--##

<!-- .slide: data-background="var(--black)" -->

# &nbsp;

## Advanced materializations

- Incremental

- Materialized views
