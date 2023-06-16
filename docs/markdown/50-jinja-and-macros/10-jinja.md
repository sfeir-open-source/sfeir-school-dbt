<!-- .slide -->
# Jinja templating

dbt uses Jinja templating extensively to write SQL code with dynamic and reusable elements.

Alongside SQL and YAML, understanding Jinja templating is key to dbt mastering.

In dbt, Jinja is used for:
* Variables substitution
* Control flow and conditionnal statements
* Macro expansion

Notes:
* Jinja and variables are available in config files too !
* Jinja support is not complete in dbt but it supports the main features
* Macros are reusable pieces of code that can be defined and invoked within your dbt projec
* Jinja provides control flow structures such as loops and conditional statements, allowing you to apply logic and iterate over data dynamically.

##==##
# Variables in dbt

Variables provide a powerful way to make your dbt projects more...

* Flexible
* Maintainable
* Reusable

Notes:
* Flexible : it's easy to change a variable value
* Maintainable : it makes your code more readable and dry
* Reusable : use them in code not specific to your project and provide this code to your organization

##==##
# Key benefits of variables in dbt

* Flexibility
  * Define values that can be easily modified without changing the underlying code
* Environment-specific settings:
  * Enable environment-specific configurations to change behavior
* Reusable code
  * Write reusable code that can adapt to different scenarios
* Testing and debugging
  * Provide variables at runtime to test specific scenarios
* Managing secrets and sensitive data
  * Use environment variables to fill in local variables

##==##
<!-- .slide: class="with-code"-->
# Declaring variables

`dbt_project.yml`
```yaml[]
...
vars:
  # The `start_date` variable will be accessible in all resources (including packages)
  start_date: '2023-01-01'

  # The `colors` variable is only accessible to resources in the sfeir_school_dbt project
  sfeir_school_dbt:
    colors: ['data', 'cloud', 'front', 'back']

  # The `currency` variable is only accessible to resources in the dbt_expectations package
  dbt_expectations:
    currency: ['USD', 'EUR', 'DJF']
...
```

##==##
<!-- .slide: class="with-code"-->
# Using variables

To use a variable anywhere in your models or macros, use the `{{ var('...') }}` function.

`models/dimensions/countries.sql`
```sql[]
  SELECT countryCode, countryName
  FROM countries
  WHERE country_area = "{{ var('countries-europe') }}"
```

##==##
<!-- .slide: class="with-code"-->
# Nesting variables

Or more like _nesting-look-a-like_...

`dbt_project.yml`
```yaml[]
...
vars:
  sfeir_school_dbt:
    countries:
      europe: "EU"
      asia: "AP"
...
```

`models/dimensions/countries2.sql`
```sql[]
  SELECT countryCode, countryName
  FROM countries
  WHERE country_area = "{{ var('countries')['europe'] }}"
```

##==##
<!-- .slide: class="with-code"-->
# Override values at runtime

You can override values using the `--vars` argument of dbt commands.

Variables at runtime use a `yaml` dictionnary format.

```shell[]
$ dbt run --vars '{"name": "Fonfec", "date": 20180101}'
$ dbt run --vars '{name: Fonfec, date: 20180101}'
```

Variables defined with the `--vars` command line argument override variables defined in the `dbt_project.yml` file.

They are globally scoped and will be accessible to all packages included in the project.


##==##
<!-- .slide: class="with-code"-->
# Conditional statements

Conditional statements allow you to execute different code blocks based on certain conditions.

In dbt, you can use `{% if %}` and `{% endif %}` to define conditional statements.

<br/>

```sql[]
{% if new_customers_only %}
    -- SQL code to execute when 'new_customers_only' is true
    SELECT * FROM {{ ref("customers") }} WHERE date_in >= CURRENT_DATE - INTERVAL '7 days'
{% else %}
    SELECT * FROM {{ ref("customers") }}
{% endif %}
```

##==##
<!-- .slide: class="with-code"-->
# Conditional statements

Use conditional blocks anywhere in your SQL code to implement logic based on variables.

<br/>

```sql[]
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

Notes:
* It's called Dynamic Query Generation

##==##
<!-- .slide: class="with-code"-->
# Control flow

You can use loops to iterate over lists or perform repetitive tasks.

<br/>

```sql[]
SELECT
  customer_id,
  COALESCE(
      {% for field in ["customer_nickname", "customer_surname", "customer_firstname"] -%}
        {{ field }},
      {% endfor %} '{{ var("missing_value_placeholder") }}') AS customer_name,
  customer_company
FROM {{ ref("seed_customers") }}
  
```


##==##
<!-- .slide: class="with-code"-->
# Jinja functions and filters

Various Jinja filters and functions are available to operate on variables.

<br/>

```sql[]
SELECT 
  customer_id
  , customer_name
FROM {{ ref("seed_customers") }}
WHERE
  TRUE
  AND enabled = '{{ var("customer_enabled", "yes") | upper }}'
```

<br/>

👉 Available filters and functions: https://docs.getdbt.com/reference/dbt-jinja-functions
