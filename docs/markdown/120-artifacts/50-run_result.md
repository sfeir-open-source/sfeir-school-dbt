<!-- .slide: class="transition"-->

# Leveraging generated artifacts

## Introduction of run_result.json

##==##

<!-- .slide:-->

# Understanding run_results.json

`run_results.json` is produced by each completed execution of dbt commands.

It contains timing and status information about all nodes that were executed during the execution (models, seeds, tests, etc.).

It is completely refreshed at each run and can include partial information about the project because of selectors.

It can be incrementally stored in a project storage and combined to monitor execution stats and errors.
