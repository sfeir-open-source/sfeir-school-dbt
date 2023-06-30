<!-- .slide: class="with-code"-->

# Sources

Sources are how you declared models outside your project to use as a source, mostly in the middle part of your project.

It's handled by _dbt_ with the `source()` macro, and via a source declaration yaml file.

Sources are not seeds, they are models in your datalake or in data products of your organization.

##==##

<!-- .slide: class="with-code"-->

# Defining sources

## Simple declaration

<!-- {% raw %} -->

`/staging/__sources.yaml`

```yaml[]
version: 2

sources:
  - name: "SAP"
    project: "ssd-{{ env_var('ENV', 'dev') }}"
    description: "SAP source"
    dataset: "sap"
    tables:
      - name: "MCMPY"
      - name: "KMEAN"
      - name: "ZORGZ"
```

<!-- {% endraw %} -->

##==##

<!-- .slide: class="with-code"-->

# Defining sources

## Enriching sources

<!-- {% raw %} -->

`/staging/__sources.yaml`

```yaml[]
sources:
  - name: "SAP"
    project: "ssd-{{ env_var('ENV', 'dev') }}"
    description: "SAP source"
    dataset: "sap"
    tables:
      - name: "MCMPY"
        columns:
          - name: "URZEJ"
            description: "Company ID - Primary key"
          - name: "FLDSR"
            description: "Company name"
          - name: "FLDSR"
            description: "Enabled yes/no"
          - name: "FFDSE"
            description: "Is customer yes/no"
```

<!-- {% endraw %} -->

Notes:

- You don't have to declare sources unless you want to use the "source()" macro
- You don't need to add columns unless you want to add options on them and generate documentation
- Column list is not used to generate the model : you still have to create a SQL file with the source name

##==##

<!-- .slide: class="with-code"-->

# Source properties

Sources support additionnal properties like:

- tests on columns
  - generic, singular and custom tests
- freshness configuration
  - to trigger warnings and/or errors
  - with filters and loaded_at column
- tags

##==##

<!-- .slide: class="with-code"-->

# Source identifier

Use the `identifier` property to rename your source table in something more explicit if needed.

<!-- {% raw %} -->

`/staging/__sources.yaml`

```yaml[|9]
...
sources:
  - name: "SAP"
    project: "ssd-{{ env_var('ENV', 'dev') }}"
    description: "SAP source"
    dataset: "sap"
    tables:
      - name: "companies"
        identifier: "MCMPY"
        columns:
          - name: "URZEJ"
...
```

<!-- {% endraw %} -->

Notes:

- This can be used to reference sharded tables in BigQuery, like "events\_\*" which is not a valid model name

##==##

<!-- .slide: class="with-code"-->

# Using the `source()` macro

<!-- {% raw %} -->

`/models/companies.sql`

```sql[|5]
SELECT
  URZEJ AS company_id,
  FLDSR AS company_name,
  FLDSR AS is_customer
FROM {{ source('SAP', 'companies') }}
WHERE FFDSE = 1
```

<!-- {% endraw %} -->

<br/>

<!-- {% raw %} -->

`/models/customers.sql`

```sql[]
SELECT *
FROM {{ ref('companies') }}
WHERE is_customer = 1
```

<!-- {% endraw %} -->

##==##

<!-- .slide: class="with-code"-->

# Declaring source freshness requirement

Updating your models if your sources are up-to-date only makes sense.

Implementing source freshness control will save you compute and brain power.

<!-- {% raw %} -->

`/staging/__sources.yaml`

```yaml[]
sources:
  - name: "SAP"
    project: "ssd-{{ env_var('ENV', 'dev') }}"
    description: "SAP source"
    dataset: "sap"
    freshness: # default freshness for all tables in source
      warn_after: {count: 12, period: hour}
      error_after: {count: 24, period: hour}
      loaded_at_field: __timestamp
    tables:
      - name: "companies"
        freshness: # default freshness
          warn_after: {count: 7, period: day}
          error_after: {count: 30, period: day}
```

<!-- {% endraw %} -->

Notes:

- It's possible to add filters to fresshness config

##==##

<!-- .slide: class="with-code"-->

# Checking source freshness

Checking your sources freshness is pretty straigforward:

```bash[]
# Check for all sources with freshness configuration
$ dbt source freshness

# Check only for sources tagged "shes-so-fresh"
$ dbt source freshness --select tag:shes-so-fresh
```
