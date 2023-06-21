# Task

Use variables and macros to make your code more efficient and maintainable

# TP

* Create and use 2 variables to replace COMPLETED and CANCELLED filter in your stg__sales model
* Change the values at run time using "--vars" to alter models output
* Create another variable to filter orders in int__sales
  * If the variable is empty, don't filter
  * If the variable is set, keep only orders placed after the date
* Create and use a macro to compute the turnover of orders in the int__sales model
  * The turnover formula should be:
    * base_price * quantity - rebate
    * converted in EUR
      * consider that 1 EUR = 1.1 USD
