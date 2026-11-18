<!-- .slide: class="transition"-->

# Snapshots to manage historical data

## Configuring and defining snapshots


##==##


<!-- .slide: class="with-code"-->

# Timestamp strategy

Detect data changes with `update_at` field, that map a timestamp column

_snapshots/snapshots.yml_

```yaml
snapshots:
  - name: 'timestamp_strategy'
    description: 'A snapshot of orders table using snapshot strategy'
    relation: ref('orders')
    config:
      schema: 'snapshots'
      strategy: timestamp
      updated_at: update_at
      unique_key: 'order_id'
```


##==##
<!-- .slide: class="tc-multiple-columns"-->

##++##

# Timestamp strategy execution workflow

![](./assets/images/docs/markdown/50-historical-data/snapshots-timestamp-strategy.svg)
##++##
##++##

&nbsp;
&nbsp;
&nbsp;

dbt will create table with SELECT statement

- add dbt_valid_from column with updated_at value
- add dbt_valid_to column with null value

<br>
<br>
<br>

for previous record

- set dbt_valid_to with new updated_at value

<br>
<br>

for new record

- set dbt_valid_from column with updated_at value
- set dbt_valid_to column with null value
##++##

##==##


<!-- .slide: class="with-code"-->

# Check strategy

Detect data changes with the `check_cols` field, that list columns required to identify changes

_snapshots/snapshots.yml_

```yaml
snapshots:
  - name: 'check_strategy'
    description: 'A snapshot of orders table using snapshot strategy'
    relation: ref('orders')
    config:
      schema: 'snapshots'
      strategy: check
      check_cols: ['order_status', 'order_step']
      unique_key: 'order_id'
```

Notes:
The SQL request must include the check_cols and unique key if any

To check changes on all column, use the string “all” instead of an array


##==##
<!-- .slide: class="tc-multiple-columns"-->

##++##

# Check strategy execution workflow

![](./assets/images/docs/markdown/50-historical-data/snapshots-timestamp-strategy.svg)
##++##
##++##

&nbsp;
&nbsp;
&nbsp;

dbt will create table with SELECT statement

- set dbt_valid_from column with CURRENT_TIMESTAMP()
- set dbt_valid_to to null

<br>
<br>
<br>

for previous record

- set dbt_valid_to to CURRENT_TIMESTAMP()

<br>
<br>

for new record

- set dbt_valid_from with CURRENT_TIMESTAMP()
- set dbt_valid_to with null value
##++##
