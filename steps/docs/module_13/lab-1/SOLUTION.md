# Solution

## 0. Time Spine (prerequisite)

`models/marts/time_spine_daily.sql`
```sql
{{ config(materialized='table') }}

with base_dates as (
  {{
    dbt.date_spine(
      'day',
      "cast('2020-01-01' as date)",
      "cast('2030-01-01' as date)"
    )
  }}
),

final as (
  select
    cast(date_day as date) as date_day
  from base_dates
)

select * from final
```

`models/semantic_models/time_spine_daily.yml`
```yaml
models:
  - name: time_spine_daily
    description: "A time spine with one row per day, from 2020 to 2030."
    time_spine:
      standard_granularity_column: date_day
    columns:
      - name: date_day
        description: "The base date column for daily granularity."
        granularity: day
```

Materialize the time spine before proceeding:
```shell
dbt run --select time_spine_daily
```

## 1. Model Preparation (Marts)

`models/marts/fct_order_items.sql`
```sql
SELECT
  order_id,
  order_line_id AS order_item_id,
  product_id,
  customer_id,
  CAST(order_datetime AS DATE) AS order_date,
  order_status AS status,
  base_price,
  quantity,
  rebate,
  currency,
  (base_price * quantity) AS line_revenue,
  (base_price * quantity) - rebate AS net_revenue
FROM {{ ref('stg__orders') }}
```

`models/marts/dim_customers.sql`
```sql
SELECT
  customer_id,
  customer_name,
  customer_gender,
  customer_country
FROM {{ ref('stg__customers') }}
```

## 2. Semantic Models

`models/semantic_models/order_items.yml`
```yaml
semantic_models:
  - name: semantic_order_items
    model: ref('fct_order_items')
    defaults:
      agg_time_dimension: order_date
    entities:
      - name: order_item
        type: primary
        expr: order_item_id
      - name: customer
        type: foreign
        expr: customer_id
    dimensions:
      - name: order_date
        type: time
        type_params:
          time_granularity: day
      - name: status
        type: categorical
    measures:
      - name: revenue
        agg: sum
        expr: line_revenue
      - name: net_revenue
        agg: sum
        expr: net_revenue
      - name: order_count
        agg: count_distinct
        expr: order_id
```

`models/semantic_models/customers.yml`
```yaml
semantic_models:
  - name: semantic_customers
    model: ref('dim_customers')
    entities:
      - name: customer
        type: primary
        expr: customer_id
    dimensions:
      - name: customer_gender
        type: categorical
      - name: customer_country
        type: categorical
```

## 3. Metrics

`models/metrics/revenue_metrics.yml`
```yaml
metrics:
  - name: total_revenue
    label: "Total Revenue"
    type: simple
    type_params:
      measure: revenue

  - name: order_count
    label: "Number of Orders"
    type: simple
    type_params:
      measure: order_count

  - name: average_order_value
    label: "Average Order Value"
    type: derived
    type_params:
      expr: total_revenue / order_count
      metrics:
        - name: total_revenue
        - name: order_count
```

## 4. Validation

Validate the graph:
```shell
mf validate-configs
```

Revenue by customer gender (MetricFlow automatically joins `fct_order_items` to `dim_customers` via `customer_id`):
```shell
mf query --metrics total_revenue --group-by customer__customer_gender
```

Revenue by country:
```shell
mf query --metrics total_revenue --group-by customer__customer_country
```

Revenue over time (monthly):
```shell
mf query --metrics total_revenue --group-by metric_time__month --order metric_time__month
```

Explain the generated SQL for the derived metric:
```shell
mf query --metrics average_order_value --explain
```
