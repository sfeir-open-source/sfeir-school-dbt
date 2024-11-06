# Task

Create a simple package structure and move your macro

# Todo

* Create a new folder at the same level of your current project to hold your custom dbt package
* In this folder, copy your dbt_project.yml files, and create a macros directory
* Edit the dbt_project file to remove vars, models and seed configuration and change the project name to the name of the package
* Import this package in your dbt project
* Edit your model to use the macro from your package

# Bonus

* Move the seeds to the package
* Check your seeds configuration to make sure they are written in the correct dataset