<!-- .slide: class="transition"-->

# Leveraging generated artifacts

## Understanding catalog.json

##==##

<!-- .slide:-->

# Understanding catalog.json

dbt catalog is produced exclusively by the `dbt docs generate` command.

It stores the metadata of tables and views produced by the project, including descriptions and types of columns.

Depending on the adapter, dbt also stores statistics of models like row count, byte count, etc.

`catalog.json` is only used and required by the generated documentation.
