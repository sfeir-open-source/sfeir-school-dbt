# Task

Use source() and ref() macros to create dependencies between models.

# Tips

* Your trainer will give you access to an existing database with a few tables.
* The tables are located in the sales schema within your own database (remember your seat number) (dbt_XX).
* Organize your models right away, using the staging/intermediate/mart scheme

# Todo

* Create a sources definition file (`__sources.yml`) with the provided tables
* Create a staging model `stg__orders` using the sales.orders source table
  * Add a condition to only keep orders with the COMPLETED or CANCELLED status
* Use this model and join with customers and countries to create an intermediate model `int__orders`, and add the following fields only:
  * Customer name
  * Customer country name
* Run a single model, then all the depending models, or the dependencies of this model
  * Try the unique and + selectors
* Add column list to your `int_orders` model in a model definition YAML file (`__models.yml` for instance)
  * Add a new column to the model file (the SQL file)
    * What happens ?
  * Add a new column to the property file (the YAML file)
    * What happens ?
* Create 2 new models referencing each others respectively
  * Try to run dbt with these 2 new models. What happens ?

# Bonus

* Add freshness configuration to the orders table in the sales source
  * Warning after 2 weeks, error after 1 month
  * Tables provided in the labs may be very old. Feel free to add 1 year or 2 to these freshness thresholds
* Try to make the freshness command warn and/or fail
