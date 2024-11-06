<!-- .slide: class="transition"-->

# Snapshots to manage historical data

## Executing and managing snapshots

##==##

# Snapshot orchestration

**When should you run snapshots ?**

- At the beginning of your DAG
  - Create a snapshot of your sources
  - Use ref() to read from your snapshots instead of your source
- At the end of your DAG
  - Create snapshots of your data products / mart models
- Snapshots are included in the `dbt build` process

<br>

dbt try to handle columns addition itself, but you may want to not track all columns changed in your snapshots strategy.

##==##

<!-- .slide: class="with-code"-->

# Running and using snapshots

```bash
# Create / update all declared snapshots
$ dbt snapshot

# Create / update a single snapshot only
$ dbt snapshot -s orders_snapshot
```

<br>

You can use snapshot ids in the **ref()** macro.

```sql
SELECT
  *
FROM {{ ref(‘orders_snapshot’) }}
WHERE
  dbt_valid_to IS NULL
```
