# Task

Add tests in your dbt code to make your life easier

# Todo

* Add a test to make sure that customer_id is unique in your source
* Add another test to make sure that order_status is in the list of accepted values:
  * COMPLETED
  * CANCELLED
  * PROCESSING
  * WAITING_PAYMENT
  * SHIPPED
* Remove one of the accepted value and run dbt
* Rename this test for better readability in the log
* Create a singular test to make sure there are always at least 2 rows in the int__orders model
* Using dbt-hub, install the dbt-utils and dbt-expectations packages
* Use one of this package to make sure that int__orders always has the "turnover" column  and that customer_name is never an empty string
* Replace your singular test with a generic test from one of the installed packages
