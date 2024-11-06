<!-- .slide: class="transition"-->

# Analyses, Exposures and Hooks

## Declaring exposures

##==##

# Exposures

Used in dbt to declare usages of the data produced by your project.

They also generate a dedicated page in the generated documentation, and are visible in the lineage.

Use exposures as dbt selectors, to run, test and list ressources associated with them:

```bash
# Run all models on the path to the exposure
$ dbt run --select +exposure:my_dashboard
```

##==##

# Declaring exposures

Exposures have 3 required properties:

- **Name**
  - More like an id
  - Unique
  - snake_case
- **Owner**
  - With name and/or email
- **Type**
  - Dashboard
  - Notebook
  - Analysis
  - ML
  - Application

##==##

# Declaring exposures

Because documentation is important, exposures also support the following properties:

- **Label**
  - A human readable name for the exposure
- **Url**
  - If applicable to the type of exposure
- **Description**

Exposures also rely on the **depends_on** property for lineage, as a list of reference to sources, models, etc.

##==##

<!-- .slide: class="with-code max-height"-->

# Declaring exposures

_models/\_\_exposures.yml_

```yaml
exposures:
  - name: monitoring_rsp
    label: 'Recommended Selling Price Monitoring'
    type: dashboard
    maturity: high
    url: https://app.powerbi.com/thisisnotarealurl
    description: '{{ doc("exposures__monitoring_rsp") }}'
    depends_on:
      - ref('PRICING')
      - ref('PRODUCTS')
      - ref('PIVOT')
      - source('GOALS', 'RSP')
    owner:
      name: Sophie Fonfec
      email: sophie@fonfec.com
```
