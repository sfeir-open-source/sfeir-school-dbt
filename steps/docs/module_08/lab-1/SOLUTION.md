# Solution

### Create a new folder at the same level of your current project to hold your custom dbt package
### In this folder, copy your dbt_project.yml files, and create a macros directory

You can put the folder wherever you want on your workstation, but remember the path to include it in the dependencies.yml file.

### Edit the dbt_project

Your dbt_project.yml can be as little as that:

```yml
name: 'mypackage'
version: '1.0.0'
macro-paths: ["macros"]
```

You don't need to import a profile or anything else in the project structure.

### Import this package in your dbt project

In your dependencies.yml or packages.yml file, just add your package as a local one using the relative or absolute path of your package.

```yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
  - package: calogica/dbt_expectations
    version: 0.10.1
  - local: ../mypackage
```

### Edit your model to use the macro from your package

Anywhere you are using your macro, just prefix the call with the name of your package separated with a dot.

```sql
SELECT *, {{ mypackage.turnover() }} FROM {{ ref("stg__orders") }}
```

## Bonus

### Move the seeds to the package

Edit the package dbt_project.yml file to include the seeds directory.

Move the seeds to this directory, and remove them from your current project.

Update your dependencies with `dbt deps` and check the seeds part your current project dbt_project.yml file. Make sure the target schema applies to all seeds, including the ones in packages.

Run `dbt seed` to make sure your seeds are insert correctly.