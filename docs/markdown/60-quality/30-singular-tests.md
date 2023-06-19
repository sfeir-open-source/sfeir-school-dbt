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
