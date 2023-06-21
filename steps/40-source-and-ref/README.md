# Task

Use source() and ref() macros to create dependencies between models.

# Tips

* You don't have to create sources from seeds, but we will in this Lab to learn about sources
  * When declaring sources, the schema name does not inherit of project schema

# TP

* Create a "stg__sales" model using the sales seed, with completed and cancelled orders only.
* Use this model and join with customers and countries to create "int__sales" add the following fields:
  * Customer name
  * Customer country name
* Create sources with the 5 seed tables, as if they were in another database
* Replace your 2 models with sources instead of reference to seeds
* Generate and serve documentation
  * Navigate in your documentation and play with the lineage

Bonus:
* Add freshness configuration to the sales source
  * Warning after 1 week, error after 1 month
  * Try to make the freshness command warn and/or fail
* Try avoiding the creation of the "stg__sales" model in your database
