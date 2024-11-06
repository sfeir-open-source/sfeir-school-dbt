# Solution

## Analysis

### Add a simple request of your choice in the analysis direction using ref() or source()

`analysis/total_base_price.sql`
```sql
SELECT count(*), SUM(base_price) FROM {{int__orders}}
```

## Exposures

### Declare a fake exposure in your project, with a few dependencies

`models/__exposures.yml`
```yaml
- name: monitoring_rsp
  label: "Recommended Selling Price Monitoring"
  type: dashboard
  maturity: low
  url: https://app.powerbi.com/thisisnotarealurl
  description: "A great dashboard to follow RSP"
  depends_on:
    - ref('int__orders')
    - source('categories')
  owner:
    name: Sophie Fonfec
    email: sophie@fonfec.com
```

### Use this exposures to run dbt and materialize all the dependencies

```bash
dbt run --select +exposure:monitoring_rsp
```

## Hooks

## Create an index on stg__orders.customer_id using a post-hook

Add a post_hook to your model like this:
```sql
{{ config(
  post_hook = "CREATE INDEX IF NOT EXISTS customer_idx ON {{ this }} (customer_id);"
) }}

SELECT
  *
FROM {{ source("sales", "orders") }}
```

Look in the logs to effectively see dbt ran the query to create the index.