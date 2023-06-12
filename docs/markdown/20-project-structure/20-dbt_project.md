<!-- .slide -->
# The dbt_project.yml file

## What is this file ?

**dbt_project.yml** provides configuration settings and metadata for the project

* Project name and version
* Directories with models, seeds, macros, etc.
* Global configuration for models, seeds, tests, etc.
* variables to use in your models / macros

Notes:
- version is not required anymore
- use explicit names for project

##==##
<!-- .slide: class="with-code"-->
# The "+" sign in yaml files

The "+" sign is used for ambiguous situations:

```yaml
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
- Important clarification to avoid errors when reading dvbt yaml files

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
- Use subdirectories to organize models, macros and such


##==##
# Global configuration

dbt config directives accumulate hierarchically:

&nbsp;&nbsp;&nbsp;&nbsp;dbt_project file < Model property file < Model file config block

**Directives in dbt_project are considered default values, unless overwritten.**


##==##
<!-- .slide: class="with-code"-->
# Global configuration

## Models

```yaml
models:
  sfeir_school_dbt:
    staging:
      +materialized: "table"  # ALL models in the staging directory will be tables
```
