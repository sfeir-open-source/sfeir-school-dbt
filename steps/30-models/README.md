# Task

Create a "products" model with the provided sample SQL file, and apply different options to test dbt features.

# Tips

* Make sure you disable partial_parsing in your profile configuration
* The sample provided is compatible with Postgres SQL. If you use another adapter, you may have to edit it.

# TP

* Use the SQL provided to create a simple "products" model, in the "models/school" subdirectory.
* Create a model definition file, referencing this new model
* Execute `dbt run` command and see what happens
  * Fix the problem
* Rename the model file only and execute `dbt run` --> what happens ?
  * Undo your change and rollback to products name for your model
* Change the destination schema to "lab" using your dbt_project file, and use "table" as materialization
* Add tags "school" and "static" to your model using 3 different methods
  * Try filtering your run command using tags 
* Add a description and the column list in the definition file 

# Cleanup

* Remove the duplicate model if it was created successfully, and the table as well
