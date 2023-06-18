<!-- .slide -->
# Generic tests

## The easiest part

Generic tests are very simple tests you declare in your models configuration files.

There are four generic tests that are available out of the box:

* unique
* not_null
* relationships
* accepted_values

##==##
<!-- .slide: class="with-code"-->
# Using a generic test

Tests are declared in models configuration files, at the column or model level:

`models/__models.yml`
```yaml[]
models:
  - name: int__sales
    columns:
      - name: order_id
        tests:
          - unique
      - name: order_status
        tests:
          - not_null
          - accepted_values:
              values: ['COMPLETED', 'CANCELLED', 'PROCESSING', 'WAITING_PAYMENT', 'SHIPPED']
```

