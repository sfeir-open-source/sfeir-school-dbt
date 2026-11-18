# Task

Implement the dbt Semantic Layer (MetricFlow) to centralize business logic and interact with it using the MetricFlow CLI to answer complex business questions across multiple models.

# Todo

## 0. Time Spine (prerequisite)

MetricFlow requires a physical time spine table — a model that generates one contiguous row per day, declared in YAML so MetricFlow can use it as the foundation for all time-based joins and aggregations.

* Create `models/marts/time_spine_daily.sql` using the `dbt.date_spine()` cross-adapter macro:
  * Generate daily dates from `2020-01-01` to `2030-01-01`
  * The output column must be named `date_day`, cast to `DATE`
  * Materialize as a `table`
* Declare it in `models/semantic_models/time_spine_daily.yml` using the `time_spine` key:
  * Set `standard_granularity_column` to `date_day`
  * Set the column granularity to `day`
* Materialize it before proceeding: `dbt run --select time_spine_daily`

## 1. Model Preparation (Marts)

To provide a clean and robust semantic layer, create two new models in a `models/marts/` folder:

* `fct_order_items`: A model at the order line grain (from `stg__orders`).
  * Retain the following fields: `order_id`, `order_line_id` (aliased as `order_item_id`), `product_id`, `customer_id`, `base_price`, `quantity`, `rebate`, `currency`
  * Cast `order_datetime` to a `DATE` column named `order_date`
  * Rename `order_status` as `status`
  * Calculate `line_revenue` as `base_price * quantity` and `net_revenue` as `(base_price * quantity) - rebate`
* `dim_customers`: A dimension model built on `stg__customers`.
  * Expose all analytics-relevant fields: `customer_id`, `customer_name`, `customer_gender`, `customer_country`

## 2. Semantic Models

Create your semantic models inside a new folder `models/semantic_models/`.

* `order_items`: Built on `fct_order_items`.
  * Define `order_item` as primary entity and `customer_id` as foreign entity
  * Define `order_date` as a time dimension (granularity: `day`)
  * Define `status` as a categorical dimension
  * Create measures: `revenue` (sum of `line_revenue`) and `order_count` (count distinct of `order_id`)
* `customers`: Built on `dim_customers`.
  * Define `customer` as primary entity
  * Define `customer_gender` and `customer_country` as categorical dimensions

## 3. Metrics

Define the final business metrics in `models/metrics/` or within your semantic YAML files.

* `total_revenue`: A simple metric based on the `revenue` measure
* `average_order_value`: A derived metric calculating `total_revenue / order_count`

## 4. Validation

* Validate your semantic graph using `mf validate-configs`
* Use the MetricFlow CLI to query `total_revenue` grouped by `customer__customer_gender`
  * Note: Observe how MetricFlow automatically resolves the join between `fct_order_items` and `dim_customers` via the `customer_id` foreign key — no manual JOIN needed!
* Run a second query grouping by `customer__customer_country` to see revenue by country
* Check the generated SQL for the `average_order_value` metric using the `--explain` flag
