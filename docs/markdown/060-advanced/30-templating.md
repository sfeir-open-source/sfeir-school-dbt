<!-- .slide: class="transition"-->

# Advanced data transformation and control

## Jinja, a templating language

##==##

<!-- .slide: class="with-code"-->

# Conditional statements

Conditional statements allow you to execute different code blocks based on certain conditions.

In dbt, you can use code if / else / endif blocks to define conditional statements.

<!-- {% raw %} -->

```sql
{% if var('new_customers_only') %} -- SQL code to execute when 'new*customers_only' is true
  SELECT *
  FROM {{ ref("customers") }}
  WHERE date*in >= CURRENT_DATE - INTERVAL '7 days'
{% else %}
  SELECT *
  FROM {{ ref("customers") }}
{% endif %}
```

<!-- {% raw %} -->

##==##

<!-- .slide: class="with-code"-->

# Conditional statements

Use conditional blocks anywhere in your SQL code to implement logic based on variables.

<!-- {% raw %} -->

```sql[|4-9|12-14]
SELECT
  customer_id,
  COALESCE(
    {%- if var("use_nickname") -%}
      customer_nickname
    {%- else -%}
      customer_firstname
    {%- endif -%}
    , customer_lastname) AS customer_name,
  customer_company
FROM {{ ref("seed_customers") }}
{% if var("pagesize", 0) > 0 -%}
LIMIT {{ var("pagesize") }}
{%- endif %}
```

<!-- {% endraw %} -->

##==##

<!-- .slide: class="with-code"-->

# Control flow

You can use loops to iterate over lists or perform repetitive tasks.

<!-- {% raw %} -->

```sql[|4-6]
SELECT
  customer_id,
  COALESCE(
    {% for field in ["customer_nickname", "customer_surname", "customer_firstname"] -%}
      {{ field }},
    {% endfor %} '{{ var("missing_value_placeholder") }}') AS customer_name,
  customer_company
FROM {{ ref("seed_customers") }}
```

<!-- {% endraw %} -->

##==##

<!-- .slide: class="with-code"-->

# Jinja functions and filters

Various Jinja filters and functions are available to operate on variables.

```sql
SELECT
  customer_id
  , customer_name
FROM {{ ref("seed_customers") }}
WHERE
  TRUE
  AND enabled = '{{ var("customer_enabled", "yes") | upper }}'
```

Available filters and functions: https://docs.getdbt.com/reference/dbt-jinja-functions

<!-- .element: class="admonition custom" data-admonition-icon="🔗 Link" -->
