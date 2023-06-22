<!-- .slide -->
# The dbt_project.yml file

## What is this file?

`dbt_project.yml` provides configuration settings and metadata for the project.

Project files tell dbt **WHAT** to run.

* Project name and version,
* _models_, _seeds_ or _macros_ directories,
* Global configuration for _models_, _seeds_, _tests_, etc.
* Variables to use in your _models_ and _macros_

Notes:
- version is not required anymore
- use explicit names for project

##==##
# Directories

_dbt_ will look for entities in configured paths:

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

_dbt_ configuration directives accumulate hierarchically like this:

![center hm-200](./assets/images/docs/markdown/20-project-structure/dbt_configuration_directives.svg)

`dbt_project.yml` is used to set project-wide default values, and variables used later in the models and macros.

##==##
<!-- .slide: class="center with-code"-->
# Small digression: understand the _"+"_ sign 

The _"+"_ sign is used, in dbt YAML files, for ambiguous situations:

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
