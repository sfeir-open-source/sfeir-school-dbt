# Task

Use source() and ref() functions to create dependencies between models.

# Tips

* Your trainer will give you access to an existing database with a few tables.

# Todo

* Create a sources definition file with the provided tables
* Create a "stg__orders" model using the sales source, with completed and cancelled orders only.
* Use this model and join with customers and countries to create "int__orders", and add the following fields only:
  * Customer name
  * Customer country name
* Run a single model, then all the depending models, or the dependencies of this model 
* Add column list to your "int_orders model"
  * Add a new column to the model
    * What happens ?
  * Add a new column to the property file
    * What happens ?
* Create 2 new models referencing each others respectively
  * Try to run dbt with these 2 new models

Bonus:
* Add freshness configuration to the orders table in the sales source
  * Warning after 1 week, error after 1 month
  * Try to make the freshness command warn and/or fail
* Try avoiding the effective creation of the "stg__orders" model in your database
