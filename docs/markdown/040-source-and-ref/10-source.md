<!-- .slide: class="transition"-->

# _dbt_ Sources and References

## Introduction to _dbt_ sources

##==##

# Sources

**Sources** are how you declare tables and views from outside your project to use as your starting point.

It's handled by dbt with the `source()` macro, and via a source declaration yaml file.

Sources are already in your data lake or in data products of your organization, and you point to them in your dbt project.

##==##

<!-- .slide: class="transition"-->

# _dbt_ Sources and References

## Configuring _dbt_ sources

##==##

<!-- .slide: class="with-code"-->

# Defining sources

## Simple declaration

`/staging/__sources.yaml`

```yaml
sources:
  - name: 'SAP'
    project: "ssd-{{ env_var('ENV', 'dev') }}"
    description: 'SAP source'
    dataset: 'sap'
    tables:
      - name: 'MCMPY'
      - name: 'KMEAN'
      - name: 'ZORGZ'
```

##==##

<!-- .slide: class="with-code max-height"-->

# Defining sources

## Enriching sources

`/staging/__sources.yaml`

```yaml
sources:
  - name: 'SAP'
    project: "ssd-{{ env_var('ENV', 'dev') }}"
    description: 'SAP source'
    dataset: 'sap'
    tables:
      - name: 'MCMPY'
        columns:
          - name: 'URZEJ'
            description: 'Company ID - Primary key'
          - name: 'FLDSR'
            description: 'Company name'
          - name: 'FLDSR'
            description: 'Enabled yes/no'
          - name: 'FFDSE'
            description: 'Is customer yes/no'
```

Notes:

- You don't have to declare sources unless you want to use the "source()" macro
- You don't need to add columns unless you want to add options on them and generate documentation
- Column list is not used to generate the model : you still have to create a SQL file with the source name

##==##

# Source properties

Sources support additionnal properties like:

- **tests** on columns
  - generic, singular and custom tests
- **freshness** configuration
  - to trigger warnings and/or errors
  - with filters and loaded_at column
- **tags**

##==##

<!-- .slide: class="with-code"-->

# Source identifier

Use the `identifier` property to rename your source table in something more explicit if needed.

`/staging/__sources.yaml`

```yaml[8]
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
```

Notes:

- This can be used to reference sharded tables in BigQuery, like "events\_\*" which is not a valid model name

##==##

<!-- .slide: class="with-code"-->

# Using the `source()` macro

`/models/companies.sql`

```sql[5]
SELECT
  URZEJ AS company_id,
  FLDSR AS company_name,
  FLDSR AS is_customer
FROM {{ source('SAP', ’MCMPY’) }}
WHERE FFDSE = 1
```

<br/>

`/models/companies-with-identifier.sql`

```sql[5]
SELECT
  URZEJ AS company_id,
  FLDSR AS company_name,
  FLDSR AS is_customer
FROM {{ source('SAP', ‘companies’) }}
WHERE FFDSE = 1
```
