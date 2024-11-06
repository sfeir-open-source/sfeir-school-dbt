<!-- .slide: class="transition" -->

# Seeding your data models

## Introduction to seeds in dbt

##==##

# What are _seeds_ in _dbt_?

Seeds are useful for small data that doesn't change frequently, such as:

- reference tables
  - country codes
  - static categorization
- static configuration
  <br/>
  <br/>

Seeds are not considered as sources in the scope of dbt. You use them with the ref() macro

<!-- .element: class="admonition important" -->

##==##

<!-- .slide: class="transition"-->

# Seeding your data models

## Creating and populating seed data

##==##

<!-- .slide: class="with-code"-->

# Sample direct configuration

Seeds are CSV files only, but they are configurable.

Options are set through the project's global configuration or a seed definition file.

All seeds are kept in the seeds directory and subdirectories and will bear the name of the csv file once materialized in the database.

```bash
seeds
├── __seeds.yml
├── seed_companies.csv
├── seed_countries.csv
└── seed_customers.csv

1 directory, 4 files
```

##==##

<!-- .slide: class="with-code max-height"-->

# Sample CSV seed file

## /seeds/seed_countries.csv

```csv
country_code,country_name
AW,Aruba
AF,Afghanistan
AO,Angola
AI,Anguilla
AX,"Åland Islands"
AL,Albania
AD,Andorra
AE,United Arab Emirates
AR,Argentina
AM,Armenia
AS,American Samoa
AQ,Antarctica
```

##==##

<!-- .slide: class="transition"-->

# Seeding your data models

## Advantages of using seeds for data initialization

##==##

# Benefits of using seeds

**Centralization and consistency**

- Keep all seeds in one place
- Clearly identify the seeds and do not use static sql ingestion
- Tags

**Code versioning**

- Your seeds are versioned like your code and models

**Documentation**

- Seeds are included in the generated documentation and lineage

##==##

<!-- .slide: class="transition"-->

# Seeding your data models

## Integrating seeds with your dbt models

##==##

# Seeds options

Using options, you can:

- Ask dbt to generate seed tables in a specific schema
- Define aliases to handle naming conflicts
- Override default CSV reader options
- Override the `full_refresh` option

Notes:
full_refresh can be disabled on seeds to prevent DROP CASCADE in specific adapters (Redshift, Snowflake)

##==##

<!-- .slide: class="with-code"-->

# Sample seeds definition file

## seeds/\_\_seeds.yml

```yaml
seeds:
  - name: seed_companies
    config:
    enabled: false
    alias: companies
  - name: seed_countries
    config:
    schema: seed_data
    alias: countries
```

<br>

Seeds options can also be set in the global dbt_project.yml file

<!-- .element: class="admonition important" -->
