<!-- .slide: class="transition"-->

# Advanced data transformation and control

## Jinja

##==##

# Jinja templating

dbt uses _Jinja_ templating extensively to write SQL code with dynamic and reusable elements.

Alongside SQL and YAML, understanding Jinja templating is key to mastering dbt .

In _dbt, Jinja_ is used for:

- Variables substitution
- Control flow and conditional statements
- Macro expansion

##==##

<!-- .slide: class="transition"-->

# Advanced data transformation and control

## Variables

##==##

# Variables in dbt

Variables provide a powerful way to make your dbt projects more:

- Flexible
- Maintainable
- Reusable

dbt includes several predefined and system variables, for instance:

- project_name
- model
- target
- this

##==##

<!-- .slide:-->

# Key benefits of variables in dbt

- Flexibility

  - Define values that can be easily modified without changing the underlying code or models

- Environment-specific settings

  - Enable environment-specific configurations to change behavior

- Reusable code

  - Write reusable code that can adapt to different scenarios

- Testing and debugging

  - Provide variables at runtime to test specific scenarios

- Managing secrets and sensitive data
  - Use environment variables to fill in local variables

Notes:
dbt can read env variables using the env() macro

##==##

<!-- .slide: class="with-code"-->

# Declaring variables

_dbt_project.yml_

```yaml
---
vars:
  # The `start_date` variable will be accessible in all resources (including packages)
  start_date: '2023-01-01'

  # The `colors` variable is only accessible to resources in the sfeir_institute project
  sfeir_institute:
    colors: ['data', 'cloud', 'front', 'back']

  # The `currency` variable is only accessible to resources in the dbt_expectations package
  dbt_expectations:
    currency: ['USD', 'EUR', 'DJF']
```

##==##

<!-- .slide: class="with-code"-->

# Using variables

To use a variable anywhere in your models or macros, use the {{ var(‘...’) }} function.

_models/dimensions/countries.sql_

```sql
SELECT countryCode, countryName
  FROM {{ ref('countries') }}
  WHERE country_area = "{{ var('countries-europe', ‘XXX’) }}"
```

You can also use environment variables with use the {{ env_var(‘...’) }} jinja function.

_models/dimensions/countries_env.sql_

```sql
SELECT countryCode, countryName
  FROM {{ ref('countries') }}
  WHERE country_area = "{{ env_var('countries-europe', ‘XXX’) }}"
```

Notes:
var() and env_var() have an optional second parameter to add a default value in case variable is missing

default value is not always a good choice : sometimes it’s better to crash if a variable is not defined

##==##

<!-- .slide: class="with-code"-->

# Nesting variables

Or more nesting-look-a-like…

_dbt_project.yml_

```yaml
vars:
  sfeir_institute:
    countries:
      europe: 'EU'
      asia: 'AP'
```

_models/dimensions/countries2.sql_

```sql
SELECT countryCode, countryName
  FROM {{ ref('countries') }}
  WHERE country_area = "{{ var('countries')['europe'] }}"
```

Notes:
Beware of default values handling when using nested variables.

##==##

<!-- .slide: class="with-code"-->

# Override values at runtime

You can override values using the --vars argument of dbt commands.

Variables at runtime use a yaml dictionary.

```bash
$ dbt run --vars '{"firstname": "Sophie", "lastname": "Fonfec", "date": 20180101}'

# With only 1 variable, brackets are optional
$ dbt run --vars 'name: Fonfec'
```

Variables defined with the --vars command line argument override variables defined in the **dbt_project.yml** file.

They are globally scoped and will be accessible to all packages included in the project.

Notes:
Value in –vars argument is actually a one line YAML
