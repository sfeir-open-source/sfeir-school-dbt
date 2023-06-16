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

dbt will look for entities in configured directories:

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
