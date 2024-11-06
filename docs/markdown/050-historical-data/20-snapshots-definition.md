<!-- .slide: class="transition"-->

# Snapshots to manage historical data

## Configuring and defining snapshots

##==##

<!-- .slide: class="with-code"-->

# Timestamp strategy

Detect data changes with update_at field, that map a timestamp column

_snapshots/institute.sql_

<!-- {% raw %} -->

```sql
{% snapshot institute_snapshot %}
{{
  config(
    target_schema='snapshots',
    unique_key='id',

    strategy='timestamp',
    updated_at='__timestamp'
  )

}}
SELECT * FROM {{ source(‘sfeir’, ‘institute’) }}
{% endsnapshot %}
```

<!-- {% endraw %} -->

##==##

<!-- .slide: class="two-column"-->

# Timestamp strategy execution workflow

![](./assets/images/docs/markdown/50-historical-data/snapshots-timestamp-strategy.svg)

##--##

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

##==##

<!-- .slide: class="with-code"-->

# Check strategy

Detect data changes with the check_cols field, that list columns required to identify changes

_snapshots/institute.sql_

<!-- {% raw %} -->

```sql[|3-9]
{% snapshot institute_snapshot %}
{{
  config(
      target_schema=’snapshots’,
      unique_key=’id’,

      strategy=’check’,
      check_cols=[‘name’, ‘status’]
    )
}}
SELECT * FROM {{ source(‘sfeir’, ‘institute’) }}
{% endsnapshot %}
```

<!-- {% endraw %} -->

Notes:
The SQL request must include the check_cols and unique key if any

To check changes on all column, use the string “all” instead of an array

##==##

<!-- .slide: class="two-column"-->

# TODO - Check strategy execution workflow

![](./assets/images/docs/markdown/50-historical-data/snapshots-timestamp-strategy.svg)

##--##

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
