# Task

Create a "products" model with the provided sample SQL file, and apply different options to test dbt features.

# Tips

* The sample provided is compatible with Postgres SQL. If you use another adapter, you may have to edit it.

# TP

* Use the SQL provided to create a simple "products" model, in the school directory.
* Create a model definition file, referencing this new model
* Rename the model file only and re-run `dbt run` --> what happens ?
* Change the destination schema to "lab" using your dbt_project file
* Add tags "school" and "static" to your model using 3 different methods
* Add a description and the column list in the definition file 
