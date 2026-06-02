<!-- .slide: class="transition"-->

# _dbt_ Sources and References

## Introduction to _dbt_ sources


##==##


# Sources

**Sources** are how you declare tables and views from outside your project to use as your starting point.

It's handled by dbt with the `source()` macro, and via a source declaration file, in YAML.

Sources must already be in your data lake or in data products of your organization, and you point to them in your dbt project.

Sources are readonly, and you should not be allowed to alter them anyway.


##==##


<!-- .slide: class="transition"-->

# _dbt_ Sources and References

## Configuring _dbt_ sources


##==##


<!-- .slide: class="with-code"-->

# Defining sources

## Simple declaration

`/models/__sources.yml`

```yaml
sources:
  - name: 'SAP' # A source has a name
    description: 'SAP source for all sales'
    database: "acme-sap-{{ env_var('ENV', 'dev') }}"
    schema: 'sap'
    tables: # A source has one or many tables
      - name: 'MCMPY'
      - name: 'KMEAN'
      - name: 'ZORGZ'
  - name: 'SALESFORCE'
    description: 'Replication of Salesforce tables'
    database: "acme-sfcc-{{ env_var('ENV', 'dev') }}"
    schema: 'sfcc'
    tables:
      - name: 'accounts'
```


##==##


<!-- .slide: class="with-code max-height"-->

# Defining sources

## Enriching sources

`/models/__sources.yml`

```yaml
sources:
  - name: 'SAP'
    description: 'SAP source for all sales'
    database: "acme-sap-{{ env_var('ENV', 'dev') }}"
    schema: 'sap'
    tables:
      - name: 'MCMPY'
        columns:
          - name: 'URZEJ'
            description: 'Company ID - Primary key'
          - name: 'FLDSR'
            description: 'Company name'
          - name: 'FLDXR'
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

Sources support additional properties like:

- **tests**
  - generic, singular and custom tests
- **freshness**
  - to trigger warnings and/or errors
  - based on a `loaded_at` column or tables metadata
- **tags**


##==##


<!-- .slide: class="with-code"-->

# Source identifier

Use the `identifier` property to rename your source table in something more explicit.

`/models/__sources.yml`

```yaml[8]
sources:
  - name: "SAP"
    database: "acme-sap-{{ env_var('ENV', 'dev') }}"
    description: "SAP source"
    schema: "sap"
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

`/models/staging/sap/companies.sql`

```sql[5]
SELECT
  URZEJ AS company_id,
  FLDSR AS company_name,
  FLDXR AS is_customer
FROM {{ source('SAP', ’MCMPY’) }}
WHERE FFDSE = 1
```

<br/>

`/models/staging/sap/companies-with-identifier.sql`

```sql[5]
SELECT
  URZEJ AS company_id,
  FLDSR AS company_name,
  FLDXR AS is_customer
FROM {{ source('SAP', ‘companies’) }}
WHERE FFDSE = 1
```
