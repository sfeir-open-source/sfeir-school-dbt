<!-- .slide: class="with-code"-->
# What about testing models?

What can we do so far:

* test data quality in sources and models
* test structure of sources and models
* test the freshness of data using `dbt source freshness`

What can we also do?

* test your _dbt_ code and models generation
  * by implementing unit-tests in _dbt_
  * that will help you not break anything

Notes:
* For now, we're just testing data in our output models (our sources)
* TDDDD anyone ? Test-Driven-Data-Driven-Decsions ?

##==##
<!-- .slide -->
# How does unit-testing work?

It's based on the assumption that you know:

* What data do you have as input --> **mocks**
* What data do you want as output --> **expects**

If the **expected** output of your _dbt_ models does not match the input, then something is broken.

##==##
<!-- .slide: class="with-code"-->
# Example of unit-test

`tests/int__sales.sql`
```sql[]
{{ config(tags=["unit-test"]) }}
{% call dbt_unit_testing.test("int__sales", "should include total turnover with and without rebate") %}
    {% call dbt_unit_testing.mock_source("sap", "sales") %}
        SELECT
          unnest(ARRAY['case1', 'case2', 'case3']) AS case_name,
          unnest(ARRAY[10, 20, 30]) AS base_price,
          unnest(ARRAY[2, -1, 9]) AS quantity,
          unnest(ARRAY[5, 9, 0]) AS rebate
    {% endcall %}
    {% call dbt_unit_testing.expect() %}
      SELECT
            unnest(ARRAY['case1', 'case2', 'case3']) AS case_name,
            unnest(ARRAY[15, -11, 270]) AS turnover, -- With rebate
            unnest(ARRAY[20, -20, 270]) AS turnover2 -- Without rebate
    {% endcall %}
{% endcall %}

```
