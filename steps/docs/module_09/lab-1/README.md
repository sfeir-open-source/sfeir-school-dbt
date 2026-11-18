# Task

Add data tests in your dbt code to make your life easier

# Todo

* Add a data test to make sure that customer_id is unique in your source (not your staging model)
* Add another data test to make sure that order_status is in the list of accepted values:
  * COMPLETED
  * CANCELLED
  * PROCESSING
  * WAITING_PAYMENT
  * SHIPPED
* Remove one of the accepted value and run your test using `dbt test`
* Give this last test a name for better readability in the logs
* Create a singular test to make sure there are always at least 2 rows in the int__orders model
* Using dbt package hub, install the dbt-utils and dbt-expectations packages
* Use one of this package to make sure that int__orders always has the "turnover" column and that customer_name is never an empty string
* Replace your singular test with a generic test from one of the installed packages
