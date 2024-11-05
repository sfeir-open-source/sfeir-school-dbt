<!-- .slide: class="transition"-->

# Packages and dependencies

## Introduction to dbt packages

##==##

# Packages

dbt packages are pre-built and reusable set of code designed to accelerate and simplify your workflows.

Packages contains SQL macros and models tailored for specific tasks.

It is the best way to share common macros and models between dbt projects in your organization.

##==##

# Common community dbt packages

Generic packages

- dbt_utils
- dbt_codegen
- dbt_artifacts

Testing packages

- dbt_expectations
- dbt_unit_testing

Adapter specific packages

- Redshift (utilities, external tables)
- BigQuery (billing, external tables)
- Postgres (indexing)
