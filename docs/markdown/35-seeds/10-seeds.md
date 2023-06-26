<!-- .slide -->
# What are _seeds_ in _dbt_?

Seeds are useful for small data that doesn't change frequently, such as:

* reference tables
  * country codes
  * static categorization
* static configuration
<br/>
<br/>

![sfeir-icons big](alert-octagon) <span style="vertical-align:top">Seeds are not considered as `sources` in the scope of _dbt_.</span> 

##==##
<!-- .slide -->
# Benefits of using seeds

* Centralization and consistency
  * Keep all seeds in the same place

* Versioning
  * Your seeds are versioned like your code and models

* Documentation and lineage

##==##
<!-- .slide: class="with-code"-->
# Creating seeds

_Seeds_ are `CSV` files **only**.

Options are set through the project's global configuration or a seed definition file.

All seeds are kept in the `seeds` directory and subdirectories.

<br/>

```shell[]
seeds
├── __seeds.yml
├── seed_companies.csv
├── seed_countries.csv
└── seed_customers.csv

1 directory, 4 files
```

Notes:
* You can't define seeds in SQL format
* As always, organize your folders with subfolder
* dbt will output a warning if you defined a seed option for an inexisting seed file

##==##
<!-- .slide: class="with-code"-->
# Sample CSV seed file

`seed_countries.csv`
```csv[]
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
<!-- .slide: class="with-code"-->
# Seeds options

Using options, you can:

* Ask _dbt_ to generate seed tables in a specific schema
* Define aliases to handle naming conflicts
* Override default CSV reader options
* Override the `full_refresh` option

Notes:
* Explain that target schema is a concatenation of default schema + custom schema

##==##
<!-- .slide: class="with-code"-->
# Sample seeds definition file

```yaml[]
version: 2

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
<br/>
<br/>

![sfeir-icons big](alert-octagon) <span style="vertical-align:top">Seeds options can also be set in the global `dbt_project.yml` file</span>

Notes:
* If your options are not working, it's probably because it's in "config" and not at root level
