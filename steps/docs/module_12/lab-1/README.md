# Task

Add analysis and exposures in your project 

# Todo

## Analysis

* Add a simple request of your choice in the analysis direction using ref() or source()
  * Use dbt compile to generate the code and run request in you database

## Exposures

* Declare a fake exposure in your project, with a few dependencies
  * Use this exposures to run dbt and materialize all the dependencies

## Hooks

* Create an index on stg__orders.customer_id using a pre-hook
