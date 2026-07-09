<!-- .slide: class="transition" -->

# Semantic Layer

## How define Semantic Layer


##==##


<!-- .slide: class="with-code max-height"-->

# Declaring Semantic Layer

_models/semantic_models/products.yml_

```yaml
semantic_models:
  - name: semantic_products
    model: ref('products')
    defaults:
      agg_time_dimension: last_restock_date
    entities:
      - name: product
        type: primary
        expr: product_id
    dimensions:
      - name: last_restock_date
        type: time
        type_params:
          time_granularity: day
      - name: product_category
        type: categorical
    measures:
      - name: total_price
        agg: sum
        expr: product_price
      - name: order_count
        agg: sum
        expr: 1
```


##==##


<!-- .slide: class="with-code max-height"-->

# Declaring Semantic Layer

_models/semantic_models/products.yml_

```yaml
semantic_models:
  - name: semantic_products
    …

metrics:
  - name: total_revenue
    type: simple
    label: "Total Revenue"
    type_params:
      measure: total_price

  - name: average_basket
    type: derived
    label: "Average Basket Value"
    type_params:
      expr: total_revenue / order_count
      metrics:
        - name: total_revenue
        - name: order_count
```


##==##


<!-- .slide: class="with-code max-height"-->

# Declaring Semantic Layer

_models/semantic_models/products.yml_

```yaml
semantic_models:
  - name: semantic_products
    …

metrics:
  - name: revenue_ytd
    type: cumulative
    label: "Revenue Year-to-Date"
    type_params:
      measure: total_price
      window: unbounded
      grain_to_date: year
```
