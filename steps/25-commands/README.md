# Task

Create and configure your first dbt project with the Postgres adapter.

# Tips

* Make sure you have Postgres running locally, or have access to a shared Postgres instance
* Unless specified otherwise, dbt creates or updates your profile in your home directory, in `/.dbt`
* If you use a shared Postgres instance, edit your profile to change the database name with your firstname as suffix

# TP

* Install dbt with the postgres adapter
  * Look at the [official documentation](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup) to match procedure for your OS
* Create and go to a new directory on your local environment
* Initiate a new dbt project with name "sfeir_school"
* Edit your dbt_project and profile files with the correct credentials
* Create a sample model named "test" with a very simple SELECT query
* Test the different commands
  * list
  * parse
  * compile
  * run
  * build
