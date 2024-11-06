<!-- .slide: class="transition"-->

# Analyses, Exposures and Hooks

## Generating analysis requests

##==##

# Generating analyses requests

In dbt, analyses are compiled SQL queries that are not run against your database.

They are used to leverage dbt reference and macro mechanisms to generate a library of SQL queries available for external tools or for manual, unscheduled execution.

```bash
# Use dbt compile to generate the SQL queries in the analysis directory
$ dbt compile
```

Compiled SQL code will output in the target directory, under your project name and analyses folder.

Analyses are compiled only using dbt compile and not dbt run nor dbt build.

<!-- .element: class="admonition important" -->
