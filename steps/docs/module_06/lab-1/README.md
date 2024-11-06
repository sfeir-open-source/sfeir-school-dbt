# Task

Declare and run snapshots using both strategies

# Tips

* Use the following query to update orders and test your snapshot logic once it's done.
* Don't forget to refresh your stg__models after the update / delete operations

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
* Create a snapshot on your int__orders model
  * Keep track of changes to order_status only based on order_datetime value
  * use order_id as unique_key
* Run dbt and compare the snapshot tables created
* Update your orders sources using the provided query and run snapshots again
* Looking at the numbers, there seems to be a problem with the change detection
  * Fix the problem and recreate the snapshots
* Add support for hard deletes in your snapshots
  * Delete a few lines in your source to test the feature
  * Refresh your stg__orders models
  * Run snapshots again