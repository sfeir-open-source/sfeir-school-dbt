# Task

Using what you've leaned so far, create incremental model.

# Tips

* Use the following query to update orders and test your incremental logic once it's done.

```
UPDATE "sales"."orders"
SET order_datetime = NOW(), order_status = 'COMPLETED'
WHERE random() < 0.1 AND order_status != 'COMPLETED';
```

# Todo

* Update your stg__orders model to remove the filter on order status.
* In a new folder, create a model in your project with the following specifications
  * Use a date or datetime field for incremental logic
* Create a second model with the same specs but with a unique key on:
  * order_id
  * order_line_id
* Run dbt twice on the new models and their dependencies
  * What happens ?
* Update the source orders table with the query provided and run your models again
  * Compare the 2 new models
* Run the models again with the full_refresh option
  * Did you lose any data ?
  * Can you prevent this loss ?
