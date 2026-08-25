# Task

Using what you've leaned so far, create an incremental model.

# Tips

Use the following query to update `sales.orders` table and test your incremental logic once it's done.

```sql
UPDATE "sales"."orders"
SET order_datetime = NOW(), order_status = 'COMPLETED'
WHERE random() < 0.1 AND order_status != 'COMPLETED';
```

# Todo

* In a new folder (`models/incremental` for instance), create a model in your project with the following specifications:
  * Incremental model name: `int__orders_inc`
  * Use a date or datetime field for incremental logic
* Create a second model with the same specs but with a unique key on:
  * `order_id`
  * `order_line_id`
* Run dbt twice on the new models and look carefully at the logs
  * What happens at the first run ?
  * What happens at the second run ?
* Update the source orders table with the query provided and run your incremental models again
* Compare the logs once again
* Count the number of rows in each materialized tables and see how the volumes differ
* Run the models again with the `full_refresh` option
  * Did you lose any data in any of the tables ?
  * Can you prevent this loss ?
