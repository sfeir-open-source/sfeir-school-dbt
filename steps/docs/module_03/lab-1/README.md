## Module 3 - Lab 1

#### Task

Create a "products" model with the provided sample SQL file, and apply different options to test dbt features.

SQL File : [products.sql](products.sql)

#### Tips

* Disable partial_parsing in your profile configuration
* The sample provided is compatible with Postgres. If you use another adapter, you may have to edit it.

#### Todo

* Use the SQL provided to create a simple "products" model, in the "models/institute" subdirectory.
* Execute `dbt run` command and see what happens
  * Fix the problem and run dbt again
* Copy this file with the exact same name in another subdirectory within models and run dbt again
  * What happens ?
* Create a model property file, referencing this new model
* Rename the model file only and execute `dbt run`
  * What happens ? Look carefuly at the execution log
  * Undo your change and rollback to products name for your model
* Change the destination schema to "lab" using your dbt_project file, and use "table" as materialization
  * In what schema will dbt materialize your model ?
* Add tags "institute" and "static" to your model using 3 different methods
  * Try filtering your run command using tags 

#### Cleanup

* Remove the model in your dbt code, and optionnaly the table / view also
