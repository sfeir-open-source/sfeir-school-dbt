# Task

Add tests in your dbt code to make your life easier

# TP

* Add a test to make sure that customer_id is unique in your source
* Add another test to make sure that order_status is in the list of accepted values:
  * COMPLETED
  * CANCELLED
  * PROCESSING
  * WAITING_PAYMENT
  * SHIPPED
* Create a singular test to make sure there are always at least 100 rows in the int__sales model
* Install the dbt-utils and dbt-expectations packages
* Use one of this package to make sure that int__sales always has the "turnover" column
  * and that customer_name is never an empty string
* Replace your singular test with a generic test from one of the installed packages
