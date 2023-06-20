<!-- .slide: class="two-column" -->
# Materialization strategies

## table 

![sfeir-icons](file-plus) Creates a physical table that holds the results of the data transformation

![sfeir-icons](database) It is suitable for scenarios where you want to persist the transformed data for further analysis or reporting.

##--##  
<!-- .slide: data-background="var(--black)" -->
# &nbsp;

## view

![sfeir-icons](file-plus) Creates a logical view that represents the result of the data transformation.

![sfeir-icons](cpu)  Unlike table materialization, views do not store the data physically; they are computed on the fly when queried.

![sfeir-icons](codesandbox) View materialization are useful when you want to abstract the underlying complexity of the data transformation process.

##==##
<!-- .slide: class="two-column" -->
# Materialization strategies

## incremental

![sfeir-icons](plus) Allows you to track changes to source data and update only relevant records.

![sfeir-icons](maximize) Incremental materialization are efficient when working with large datasets, as they avoid recomputing the entire transformation.

![sfeir-icons](watch) They are commonly used for data pipelines that require frequent updates or near real-time data availability.

##--##
<!-- .slide: data-background="var(--black)" -->
# &nbsp;
## ephemeral

![sfeir-icons](clock) Creates temporary tables in the data warehouse for the duration of a single dbt run or query.

![sfeir-icons](percent) Used for intermediate calculations or as intermediate areas in complex data transformations.

![sfeir-icons](repeat) Offers a flexible and efficient way to manage temporary data transformations and calculations within your dbt workflows.
