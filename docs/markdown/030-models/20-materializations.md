<!-- .slide: class="transition"-->

# Working with _dbt_ models

## Materialization options

##==##

<!-- .slide: class="tc-multiple-columns" -->

##++##

# Materialization strategies

## view

![](plus-circle 'tc-icons feather tc-big') Default materialization in dbt. Good choice for low compute models like renaming or recasting.

![](cpu 'tc-icons feather tc-big') Does not use storage in your warehouse, but uses compute time every time you read from it. Beware of stacking too many views on top of each others.

![](watch 'tc-icons feather tc-big') Very fast to create at build time. Data may vary each time you read from a view.
##++##
##++## data-background="var(--black)" class="contrast-opposite"

# &nbsp;

## table

![](clock 'tc-icons feather tc-big') Very fast to query, but can be long to (re)create at each run.

![](git-commit 'tc-icons feather tc-big') Must be refreshed to include updates to underlying sources.

![](refresh-cw 'tc-icons feather tc-big') Preferred choice for models exposed as data products or use cases, and models used as reference by many other models.
##++##

##==##

<!-- .slide: class="tc-multiple-columns" -->

##++##

# Materialization strategies

## ephemeral

![](plus-circle 'tc-icons feather tc-big') Creates a CTE that is replaced in the models querying this table.

![](cpu 'tc-icons feather tc-big') Used for intermediate calculations or as intermediate areas in complex data transformations.

![](watch 'tc-icons feather tc-big') Offers a flexible and efficient way to manage temporary data transformations and calculations within your dbt workflows.
##++##
##++## data-background="var(--black)" class="contrast-opposite"

# &nbsp;

## Advanced materializations

- Incremental

- Materialized views

##++##
