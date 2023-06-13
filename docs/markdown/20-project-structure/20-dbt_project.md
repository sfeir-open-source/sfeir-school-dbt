<!-- .slide -->
# The dbt_project.yml file

## What is this file ?

`dbt_project.yml` provides configuration settings and metadata for the project

Project files tell dbt **WHAT** to run.

* Project name and version
* Directories with models, seeds, macros, etc.
* Global configuration for models, seeds, tests, etc.
* variables to use in your models / macros

Notes:
- version is not required anymore
- use explicit names for project

##==##
# Directories

dbt will look for entities in configured directories

* models
* macros
* seeds
* tests

You can also change default directories for:

* logs
* target (compiled) files
* packages

Notes:
- Use subdirectories to organize models, macros, seeds, etc.

##==##
# Global configuration

dbt config directives accumulate hierarchically:

<br>

&nbsp;&nbsp;&nbsp;&nbsp;dbt_project file **<** Model property file **<** Model file config block

<br><br>

`dbt_project.yml` is used set project-wide default values, and to set variables used later in the models and macros.

##==##
<!-- .slide: class="with-code"-->
# The "+" sign in dbt yaml files

The "+" sign is used for ambiguous situations:

```yaml[]
...
models:
  sfeir_school_dbt:
    staging:
      +tags: "contains_pii" # Actual tags
      tags:  # A folder name / path within "staging" path
        +tags:
          - "daily"
...
```

Notes:
- Important clarification to avoid errors when reading dbt yaml files

##==##
<!-- .slide: class="with-code"-->
# Global configuration

## Models

`dbt_project.yml`
```yaml[]
...
models:
  sfeir_school_dbt:
    staging: # Directives below apply to all models in "staging" subdirectory of "models"
      +materialized: "table"  # ALL models in the staging directory will be tables
      +enabled: false
      +persist_docs:
        relation: true # Adds "description" to relations (models / views) upon creation
        columns: true # Add "description" to fields in models
```

##==##
<!-- .slide: class="with-code"-->
# Global configuration

## Seeds

`dbt_project.yml`
```yaml[]
...
seeds:
  +schema: seeds # Default schema for all seeds including ones in packages
  sfeir_school_dbt:
    +schema: school_seeds # Default schema for all seeds in project except ones from packages
    country_codes: # This configures seeds/country_codes.csv
      # Override column types
      +schema: dimension_seeds
      +column_types:
        country_code: varchar(2)
        country_name: varchar(32)
```

##==##
# Variables

## Variables in dbt

Variables provide a powerful way to make your dbt projects more...

* Flexible

* Maintainable

* Reusable

Notes:
* Flexible : it's easy to change a variable value
* Maintainable : it makes your code more readable and dry
* Reusable : use them in code not specific to your project and provide this code to your organization

##==##
# Variables

## Variables in dbt

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
# Variables

## Declaring variables

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
# Variables

## Using variables

To use a variable anywhere in your models or macros, use the `{{ var('...') }}` function.

`models/dimensions/countries.sql`
```sql
  SELECT countryCode, countryName
  FROM countries
  WHERE country_area = "{{ var('countries-europe') }}"
```

##==##
<!-- .slide: class="with-code"-->
# Variables

## Nesting

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
```sql
  SELECT countryCode, countryName
  FROM countries
  WHERE country_area = "{{ var('countries')['europe'] }}"
```

##==##
<!-- .slide: class="with-code"-->
# Variables

## Override values at runtime

You can override values using the `--vars` argument of dbt commands.

Variables at runtime use a `yaml` dictionnary format.

```shell[]
$ dbt run --vars '{"name": "Fonfec", "date": 20180101}'
$ dbt run --vars '{name: Fonfec, date: 20180101}'
```

Variables defined with the `--vars` command line argument override variables defined in the `dbt_project.yml` file.

They are globally scoped and will be accessible to all packages included in the project.
