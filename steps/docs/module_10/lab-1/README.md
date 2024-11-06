# Task

Add contracts and versions to existing models from your warehouse

# Todo

## Contracts

* Add a contract with data types to the stg__orders model
  * Run dbt to make sure your contract is valid
* Add / Remove a colum definition in your contract and see what happens
* Add a compound primary key to this model
* Add contraints to columns following the specs below:
  * customer_id cannot be null
  * order_id must be > 0


## Versions

* Refactor your property file to include a first version if your int__orders model
* Add a new version of int__orders
  * Add a new total_price computed field, without rebate
  * Remove the country_name field
  * Do not make this new version the default one
* Create a mart model and point to the default version of int__orders
* Update your mart model to pin the new, not yet official version of int__orders
* Add a closed or overdue deprecation date to the first version if your model
  * Run dbt and look at the recommendations in the log