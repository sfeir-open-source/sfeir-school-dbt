# Solution

## Documentation

### Add inline documentation to your project

You can easily add inline documentation in the yaml property files:

`models/institute/__sources.yml`
```yaml
sources:
  - name: sales
    schema: sales
    tables:
      - name: orders
        columns:
          - name: order_id
            description: "ID of order in SAP"
          - name: order_line_id
            description: "Line ID of in SAP"
          - name: base_price
            description: "Raw selling price in EUR"
          - name: order_status
            description: "|
              Status of order.
              Allowed values: COMPLETED, CANCELLED, PROCESSING, WAITING_PAYMENT, SHIPPED"
```

### Replace the inline documenation with doc blocks

Use a markdown file replace your inline block with a call with the doc() macro.

`models/institute/__doc.md`
```md
% docs column__orders__order_status %}
Status of order. 
_Allowed values_: COMPLETED, CANCELLED, PROCESSING, WAITING_PAYMENT, SHIPPED
{% enddocs %}
```

`models/institute/__sources.yml`
```yaml
sources:
  - name: sales
    schema: sales
    tables:
      - name: orders
        columns:
          - name: order_id
            description: "ID of order in SAP"
          - name: order_line_id
            description: "Line ID of in SAP"
          - name: base_price
            description: "Raw selling price in EUR"
          - name: order_status
            description: '{{ doc("column__orders__order_status") }}'
```

### Generate and browse your documentation

```bash
dbt docs generate && dbt docs serve
```