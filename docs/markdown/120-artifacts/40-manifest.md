<!-- .slide: class="transition"-->

# Leveraging generated artifacts

## Understanding manifest.json

##==##

# Understanding manifest.json

`manifest.json` is produced by all dbt commands that parse the project.

It contains a **full representation** of dbt project's resources, including configurations and properties, unless a resource is disabled.

`manifest.json` is used and required by the generated documentation, and is where the state of last execution is stored.

It is used to compute metrics on execution, tests or documentation coverage, and is the perfect entry point to extend dbt usage metrics.
