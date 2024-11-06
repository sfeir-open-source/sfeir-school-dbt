<!-- .slide: class="transition"-->

# _dbt_ Sources and References

## Filtering execution

##==##

# Filtering execution

Node selection syntax makes it possible to run only specific resources in a given invocation of dbt.

Using a combination of --select and --exclude arguments, dbt users can filter precisely what to execute or not.

Even if the syntax is straightforward, it offers a lot of options to select nodes using names, tags, path, types and even state of last run.

##==##

<!-- .slide: class="with-code max-height"-->

# Most commonly used node selectors

```bash
# Run a single model using its name
$ dbt run --select stg__orders
$ dbt run -s “stg__orders”
$ dbt run -s institute.stg__orders

# Run a single model using its complete file path (using slashes)
$ dbt run -s models/institute/stg__orders.sql

# Run all models in a directory
$ dbt run -s models/institute
$ dbt run -s "institute.*"

# Run all models from a directory, with the tag "static"
# No space after the comma
$ dbt run -s "institute.*,tag:static"

# Run two distinct models (use space as separator)
dbt run -s stg__orders stg__customers
```

Notes:
Recommendation : use quotes around the selectors

##==##

<!-- .slide: class="with-code max-height"-->

# Selectors with children and parents

```bash
# Run a single model and all its parent models
$ dbt run -s +int__orders

# Run a single model and all its child models
$ dbt run -s int__orders+

# Run a single model and both its parent and child models
$ dbt run -s +int__orders+

# Run a single model and both its parent and child models up to 2 levels
$ dbt run -s 2+int__orders+2

# Run a single model with its children, and the parents of its children
$ dbt run -s @int__orders
```
