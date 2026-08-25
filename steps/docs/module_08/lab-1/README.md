# Task

Create a simple package structure and move your macro in the package

# Todo

* Create a new folder at the same level of your current project to hold your custom dbt package
  * Be careful not to create the new dbt project in your current dbt folder
  * It's common practice to name your folder after your package name, for instance "my_package"
* In this folder, create a `dbt_project.yml` and simply add a name and a version
  * Do not add anything else in the dbt_project.yml file
* Create a macros folder and move the macro file from your main project into this folder
* Import this package in your dbt project using the `packages.yml` file
  * You'll have to use the "local" method to import your package
* Edit your model to use the macro from your package

# Bonus

* Move the seeds to the package
* Check your seeds configuration to make sure they are written in the correct dataset