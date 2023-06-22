<!-- .slide: class="with-code"-->
# `dbt run`

Compile SQL and execute against the current target database.

<br/><br/>
```bash[]
# Compile and run all models against `default` target, with default profile
dbt run

# Compile and run all models against `prd` target, with the default profile
dbt run --target prd
```

##==##
<!-- .slide: class="with-code"-->
# `dbt seed`

Load data from CSV files into your data warehouse.

<br/><br/>
```bash[]
# Import all seeds in `default target
dbt seed

# Import all seeds in your `dev` target, read from your `localù profile
dbt seed --profile local --target dev
```

##==##
<!-- .slide: class="with-code"-->
# `dbt test`

Runs tests or unit tests for models on data
<br><br>

```bash[]
# Run all tests
dbt test

# Run test related to "CUSTOMERS" model only
dbt test --select CUSTOMERS

# Run test tagged "unit-test" only
dbt test --select tag:unit-test
```

##==##
<!-- .slide: class="with-code"-->
# `dbt build`

Run _seeds_, _models_, _snapshots_ and _test_ in DAG order

<br/><br/>
```bash[]
# Build and tests models in the staging directory only
dbt build --select staging --target prd
```

##==##
<!-- .slide: class="with-code"-->
# `dbt docs`

Generate and serve _dbt_ generated documentation as website for your project.

<br/><br/>
```bash[]
# Generate documentation in the "docs" folder
dbt docs generate

# Start a webserver and serve generated documentation (default port is port 8080)
dbt docs serve --port 2828 --no-browser
```

##==##
<!-- .slide: class="with-code"-->
# Additionnal useful commands

* `dbt list`
  * List _models_, _seeds_, _sources_, etc. optionally with filters
* `dbt deps`
  * Install _dbt_ packages declared in `packages.yml`
* `dbt parse`
  * Simply parse your code and check for errors
* `dbt compile`
  * Compile the code locally if you want to check generated requests
* `dbt clean`
  * Remove everything the target and logs directories
* `dbt source`
  * Used to check sources freshness and create snapshots

Notes:
- All commands have a `--help` argument
