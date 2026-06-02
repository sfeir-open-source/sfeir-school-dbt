<!-- .slide: class="tc-multiple-columns" -->

##++##

# Advanced materializations

## incremental

![](plus-circle 'tc-icons feather tc-big') Allows you to track changes to source data and update only relevant records.

![](cpu 'tc-icons feather tc-big') Incremental materialization are efficient when working with large datasets, as they avoid recomputing the entire transformation.

![](watch 'tc-icons feather tc-big') They are commonly used for data pipelines that require frequent updates or near real-time data availability.
##++##
##++## data-background="var(--black)" class="contrast-opposite"

# &nbsp;

## materialized view

![](clock 'tc-icons feather tc-big') Incremental logic but managed by the database rather than inside dbt. Support starting in dbt 1.6, availability and features depends on the adapter

![](git-commit 'tc-icons feather tc-big') Combine query performance and the data freshness in a single object.

![](refresh-cw 'tc-icons feather tc-big') Materialized views may or may not be the good choice for your models, depending on the latency and how often you need to update your data
##++##

Notes:
Mviews do not support all features depending on the platform : joins, aggregations, window functions, etc.
MViews support for BigQuery : dbt 1.7+
