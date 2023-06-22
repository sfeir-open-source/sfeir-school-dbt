# Task

Import data from CSV files in your warehouse.


# TP

* Copy and rename the sample seed files to import them in your warehouse.
  * See how dbt names object from the filenames and think about potential issues
* Using your dbt_project.yml file, change the destination schema of all your seeds
* Look in the [dbt documentation](https://docs.getdbt.com/reference/seed-configs) to remove the "seed_" part of the destination seed tables
* Update the "categories" seeds to explicitely define column types:
  * category_code AS varchar(8)
  * category_name AS varchar(32)
  * enabled AS boolean
  * date_in AS timestamp

# Cleanup

* Remove all the seeds from outside of the good schema, and with the "wrong names"
