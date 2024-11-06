<!-- .slide: class="transition"-->

# Documentation

## Generate and maintain accessible up-to-date model documentation

##==##

<!-- .slide: class="with-code"-->

# Documenting sources

_models/\_\_sources.yml_

```yaml
sources:
  - name: SAP
    project: "sap-{{ env_var('ENV', 'dev') }}"
    description: 'Replication of SAP tables'
    dataset: 'SAP'
    tables:
      - name: 'TNWWR'
        description: 'Custom taxes on specific materials'
        columns:
          - name: 'flatr'
            description: 'Flat tax rate'
          - name: 'startdate'
            description: 'Starting date of application of this rate'
```

##==##

<!-- .slide: class="with-code"-->

# Documenting models

_models/\_\_models.yml_

```yaml
models:
  - name: FORECAST_YEARLY
    description: 'Yearly forecast for all eBusiness, grouped by country'
    columns:
      - name: country
        description: 'Country'
      - name: forecast_value
        description: 'Forecast for EBusiness'
      - name: forecast_confidence
        description: 'Level of confidence in the forecast, from 0 to 100'
      - name: forecast_date
        description: 'Date of forecast evaluation'
```

##==##

<!-- .slide: class="with-code"-->

# Documenting seeds

_seeds/\_\_seeds.yml_

```yaml
seeds:
  - name: SEED_COUNTRY_CODES
    description: 'Mapping between custom country codes and ISO 3166-1 ones'
    config:
      column_types:
        country_code: string
        iso_country_code_2: string
        iso_country_code_3: string
    columns:
      - name: country_code
        description: 'The country code in the finance referential'
      - name: iso_country_code_2
        description: '2-alpha country code in the ISO 3166 format'
      - name: iso_country_code_3
        description: '3-alpha country code in the ISO 3166 format'
```

##==##

<!-- .slide: class="with-code"-->

# Documenting macros

_macros/\_\_macros.yml_

```yaml
macros:
  - name: i18n_compatible_name
    description: 'Compute a international-compatible name from a list of fields.
      Fallback to a default field value in case all field contains invalid string.
      Note: This macro consider numeric-only values as falsy'
    arguments:
      - name: \_fields
        type: list
        description: 'The fields to search for an i18n compatible value'
      - name: \_default_field
        type: string
        description: 'The field to take the default value from in case of zero match'
```

##==##

# Leverage doc() macro for better documentation

Instead of writing documentation inline, use Markdown files to :

- Store all documentation in the same place
- Make property files easier to read
- Produce styled documentation with markdown and not just text
- Don’t Repeat Yourself
  - Use the same documentation for fields repeated along the path

Then, simply use the `doc()` macro in your property files.

##==##

<!-- .slide: class="with-code"-->

# Using the doc() macro

macros/\_doc.md

```django
{% docs macro__i18n_compatible_name %}
Compute a international-compatible name from a list of fields.
Fallback to a default field value in case all field contains invalid string.

_Note: This macro consider numeric-only values as falsy_
{% enddocs %}

{% docs macro__i18n_compatible_name___fields %}
The fields to search for an i18n compatible value
{% enddocs %}

{% docs macro__i18n_compatible_name___default_field %}
The field to take the default value from in case of zero match
{% enddocs %}
```

##==##

<!-- .slide: class="with-code"-->

# Using the doc() macro

_macros/\_\_macros.yml_

```yaml
macros:
  - name: i18n_compatible_name
    description: '{{ doc("macro__i18n_compatible_name") }}'
    arguments:
      - name: \_fields
        type: list
        description: '{{ doc("macro__i18n_compatible_name___fields") }}'
      - name: \_default_field
        type: string
        description: '{{ doc("macro__i18n_compatible_name___default_field") }}'
```

Notes:
Don’t forget the single quote around the {{ doc() }}

##==##

# Persist documentation in your database

Depending on the adapter, documentation can be persisted in the database.

When dbt creates the tables or view, it replicates the documentation from the yaml files in the `create table` or `create view` statement.

In the `dbt_project.yml` file, simply add the `persist_doc` directive in the models section.

```yaml
models:
  +persist_docs:
    relation: true
    columns: true
  sfeir_institute:
    staging:
    ...
```

##==##

# Generating documentation

Generate documentation using a single command.

This command will:

- Compile your code to include it in the manifest.json file
- Run queries against your database to gather metrics on the existing models
- Copy the index.html file in the target directory

Use this in your CI to update your documentation after each deployment.

You can use filters, ask to skip compilation and to skip queries.

```bash
# Default command will compilation and catalog metrics
$ dbt docs generate

# Do not query database and do not compile code
$ dbt docs generate --no-compile --empty-catalog
```

Notes:
--no-compile

--empty-catalog

##==##

# Serving documentation

Use this second command to serve the documentation on your workstation directly using a simple HTTP server, **after** you generated the doc first.

```bash
# Will serve the documentation and open the browser automatically
$ dbt docs serve

# Skip opening the browser automatically
$ dbt docs serve --no-browser
```

To deploy and serve the documentation online, simply copy the following files to your webserver:

- target/index.html
- target/catalog.json
- target/manifest.json

Notes:
--no-compile

--empty-catalog
