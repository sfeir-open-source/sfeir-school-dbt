# Task

Declare and run snapshots using both strategies

# Preparation

* Don't forget you may have changed materialization of your staging models
* Make sure your staging models are materialized as views, or use dbt with the + selector to refresh your staging tables
* Use the following queries to update orders and test your snapshot logic when needed.

```sql
UPDATE "sales"."orders"
SET order_datetime = NOW(), order_status = 'COMPLETED'
WHERE random() < 0.1 AND order_status != 'COMPLETED';
```

To delete lines in your orders table, run the following query:

```sql
DELETE FROM "sales"."orders"
WHERE random() < 0.05;
```

# Todo

* Create a snapshot on your stg__orders model
  * keep track of changes in all fields as if there was no order_datetime field
  * use order_id as unique_key
* Create another snapshot on your stg__orders model
  * keep track of changes based on order_datetime modification
  * use order_id as unique_key
* Run dbt and compare the snapshot tables created
* Update your orders sources using the provided queries and run snapshots again
* Looking at the numbers, there seems to be a problem with the change detection
  * Fix the problem and recreate the snapshots
  * This may be related to the unique key
* Add support for hard deletes in your snapshots
  * Delete a few lines in your source to test the feature
  * Refresh your stg__orders models and run the snapshots again
