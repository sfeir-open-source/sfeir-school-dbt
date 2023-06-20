<!-- .slide: class="with-code"-->
# Singular tests

A singular test is a custom SQL query that returns failing rows.

* dbt runs a `count(*)` on the query
  * If there is at least 1 result, the test fails
  * If there is 0 result, the test pass


You write a SQL file with your custom query

`tests/assert_total_payment_amount_is_positive.sql`
```sql[]
SELECT
    order_id,
    SUM(amount) AS total_amount
FROM {{ ref('fct_payments' )}}
GROUP BY 1
HAVING NOT(total_amount >= 0)
```

Notes:
* If you want to test that no order has more than 10 articles, then write a request to find orders that actually have more than 10 articles

##==##
<!-- .slide: class="with-code"-->
# Test macros with singular tests

Singular tests are good candidates to test your custom macros.

Simply write asserts that would fail if your macros changes or breaks.

`tests/assert_macro_turnover_ok.sql`
```sql[]
SELECT
  'case1' AS case_name,
  10 AS base_price,
  2 AS quantity,
  5 AS rebate,
  {{ turnover(true) }} AS turnover
EXCEPT DISTINCT
-- Write your expectation here
SELECT
  'case1', 10, 2, 5, 15
```
