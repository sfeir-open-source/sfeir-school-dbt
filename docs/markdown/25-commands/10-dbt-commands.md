<!-- .slide: class="with-code"-->
# `dbt run`

Compile SQL and execute against the current target database.

<br/><br/>
```bash[]
# Compile and run all models against default target, with default profile
dbt run

# Import all seeds in your prd target with the default profile
dbt run --target prd
```

##==##
<!-- .slide: class="with-code"-->
# `dbt seed`

Load data from csv files into your data warehouse.

<br/><br/>
```bash[]
# Import all seeds in default target
dbt seed

# Import all seeds in your dev "target", read from your "local" profile
dbt seed --profile local --target dev
```

##==##
<!-- .slide: class="with-code"-->
# `dbt test`

Runs tests on data / unit-tests
<br><br>

```bash[]
# Run all tests
dbt test

# Run test on model "CUSTOMERS" only
dbt test --select CUSTOMERS

# Run test tagged "unit-test" only
dbt test --select tag:unit-test
```

##==##
<!-- .slide: class="with-code"-->
# `dbt build`

Run all Seeds, Models, Snapshots, and tests in DAG order

<br/><br/>
```bash[]
# Will only build and tests models in the staging directory
dbt build --select staging --target prd
```

##==##
<!-- .slide: class="with-code"-->
# `dbt docs`

Generate or serve the documentation website for your project.

<br/><br/>
```bash[]
# Generate docs in the "docs" folder
dbt docs generate

# Start a webserver and serve generated doc (default port is port 8080)
dbt docs serve --port 2828 --no-browser
```

##==##
<!-- .slide: class="with-code"-->
# See also...

Additionnal useful commands:

* `dbt list`
  * List models, seeds, sources, etc. optionaly with filters
* `dbt deps`
  * Install dbt packages declared in `packages.yml`
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
