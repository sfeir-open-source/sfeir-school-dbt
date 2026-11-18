## Module 3 - Lab 1

#### Task

Create a "products" model with the provided sample SQL file, and apply different options to test dbt features.

SQL File : [products.sql](products.sql)

#### Preparation

* Remove the models/example folder if you have one
* Remove the configuration related to the example models in your dbt_project.yml file.
  * This configuration should be at the bottom of the file
* Disable partial_parsing in your project configuration
  * This could lead to issues when updating documentation in future labs

```yaml
# dbt_project.yml
name: "sfeir_institute"
version: "1.0.0"

flags:
  partial_parse: false
  use_colors: true
  printer_width: 120
  send_anonymous_usage_stats: false
...
```

#### Todo

* Use the SQL provided to create a simple "products" model, in the models/institute subdirectory.
* Execute `dbt run` command and see what happens
  * Check the logs, fix the problem and run dbt again
* Copy this file with the exact same name in another subdirectory of models and execute `dbt run` again
  * What happens ?
  * Remove this copy
* Create a model YAML property file (`__models.yml`) next to your sql file
  * Add the products model in this file
* Rename the model file (the SQL file) and execute `dbt run` again
  * Look carefuly at the execution log
  * Undo your change and rollback to products name for your model
* Change the destination schema to "lab" using your dbt_project.yml file, and use "table" as materialization
  * Look at the logs and your database to locate the new created table. Is this what you were expecting ?

#### Cleanup

* Remove the model in your dbt code and run dbt again
  * Is your database clean ?
