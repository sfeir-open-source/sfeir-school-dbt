<!-- .slide: class="two-column" -->
# Materialization strategies

## table 

![sfeir-icons big](file-plus) <span style="vertical-align:top">Creates a physical table that holds the results of the data transformation</span>

![sfeir-icons big](database) <span style="vertical-align:top">It is suitable for scenarios where you want to persist the transformed data for further analysis or reporting.</span>

##--##  
<!-- .slide: data-background="var(--black)" -->
# &nbsp;

## view

![sfeir-icons big](file-plus) <span style="vertical-align:top">Creates a logical view that represents the result of the data transformation.</span>

![sfeir-icons big](cpu) <span style="vertical-align:top">Unlike table materialization, views do not store the data physically; they are computed on the fly when queried.</span>

![sfeir-icons big](codesandbox) <span style="vertical-align:top">View materialization are useful when you want to abstract the underlying complexity of the data transformation process.</span>

##==##
<!-- .slide: class="two-column" -->
# Materialization strategies

## incremental

![sfeir-icons big](plus) <span style="vertical-align:top">Allows you to track changes to source data and update only relevant records.</span>

![sfeir-icons big](maximize) <span style="vertical-align:top">Incremental materialization are efficient when working with large datasets, as they avoid recomputing the entire transformation.</span>

![sfeir-icons big](watch) <span style="vertical-align:top">They are commonly used for data pipelines that require frequent updates or near real-time data availability.</span>

##--##
<!-- .slide: data-background="var(--black)" -->
# &nbsp;
## ephemeral

![sfeir-icons big](clock) <span style="vertical-align:top">Creates temporary tables in the data warehouse for the duration of a single dbt run or query.</span>

![sfeir-icons big](percent) <span style="vertical-align:top">Used for intermediate calculations or as intermediate areas in complex data transformations.</span>

![sfeir-icons big](repeat) <span style="vertical-align:top">Offers a flexible and efficient way to manage temporary data transformations and calculations within your dbt workflows.</span>
