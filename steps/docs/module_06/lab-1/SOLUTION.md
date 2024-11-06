# Solution

### Create a snapshot on your stg__orders model

```sql
{% snapshot orders_1 %}
{{
    config(
        target_schema='snapshots',
        unique_key='order_id',

        strategy='check',
        check_cols='all'
    )
}}
SELECT * FROM {{ ref('stg__orders') }}
{% endsnapshot %}
```

### Create a second snapshot on your stg__orders model

```sql
{% snapshot orders_2 %}
{{
    config(
        target_schema='snapshots',
        unique_key='order_id',

        strategy='timestamp',
        updated_at='order_datetime'
    )
}}
SELECT order_id, order_status, order_datetime FROM {{ ref('stg__orders') }}
{% endsnapshot %}

```

### Run dbt and compare the snapshot tables created

dbt adds 4 fields to support the snapshot stragegy and comparison mechanism.

You can use dbt_valid_from and dbt_valid_to to query the snapshots for historical data.

### Update your orders sources using the provided query and run snapshots again

Use this query to update your source.

```sql
UPDATE "sales"."orders"
SET order_datetime = NOW(), order_status = 'COMPLETED'
WHERE random() < 0.1 AND order_status != 'COMPLETED';
```

Update your stg__orders model to reflect changes in the source (dbt run -s stg__orders).

Run the snapshots and look for rows with not null dbt_valid_to fields.

### Looking at the numbers, there seems to be a problem with the change detection

The orders model has a compound unique key (order_id and order_line_id) and you can't define an array of keys in snapshots.

However, you can put valid SQL in the unique_key parameter.

```sql
{% snapshot orders_1 %}
{{
    config(
        target_schema='snapshots',
        unique_key='CONCAT(order_id, order_line_id)',

        strategy='check',
        check_cols='all'
    )
}}
SELECT * FROM {{ ref('stg__orders') }}
{% endsnapshot %}
```

### Add support for hard deletes in your snapshots

Use this SQL to delete lines from your source and refresh your dbt model afterwards.

```sql
DELETE FROM "sales"."orders"
WHERE random() < 0.05;
```

Add the `invalidate_hard_deletes` option to your snapshots.

```sql
{% snapshot orders_1 %}
{{
    config(
        target_schema='snapshots',
        unique_key='CONCAT(order_id, order_line_id)',

        strategy='check',
        check_cols='all',

        invalidate_hard_deletes=True
    )
}}
SELECT * FROM {{ ref('stg__orders') }}
{% endsnapshot %}
```

Run the snapshot again and look for rows with dbt_valid_to set to your snapshot execution date, and no other row with the same unique keys and dbt_valid_to set to null.

