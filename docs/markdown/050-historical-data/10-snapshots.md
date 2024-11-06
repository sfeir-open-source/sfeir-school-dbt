<!-- .slide: class="transition"-->

# Snapshots to manage historical data

## Understanding snapshots in dbt

##==##

# Snapshots

Snapshots are a key concept in _dbt_ that allow you to manage historical data effectively.

A snapshot captures a **point-in-time representation** of your data model. It’s a frozen copy of you data, allowing you to query and analyze data at a specific moment.

Snapshots are important for:

- historical reporting
- auditing data changes
- compliance requirements
- data analysis at specific points in time

Notes:
Snapshots create SCD Type 2

##==##

# Snapshots

Let’s say that we track our training assets this way:

| id  | name | status             | updated_at |
| --- | ---- | ------------------ | ---------- |
| DBT | dbt  | under_construction | 2023-10-24 |

Now, slides and labs are done, we can update status:

| id  | name | status | updated_at |
| --- | ---- | ------ | ---------- |
| DBT | dbt  | ready  | 2023-10-28 |

<br>

We lost information about course lifecycle…

<!-- .element: class="admonition important" -->

##==##

# Snapshots

With snapshots, we can track row change over time:

| id  | name | status             | updated_at | dbt_valid_from | dbt_valid_to |
| --- | ---- | ------------------ | ---------- | -------------- | ------------ |
| DBT | dbt  | under_construction | 2023-10-24 | 2023-10-24     | 2023-10-28   |
| DBT | dbt  | ready              | 2023-10-28 | 2023-10-28     | null         |

Notes:
dbt creates Type 2 SCD (Slowly Changing Dimensions) to store snapshots.

##==##

# Snapshots strategy

**Timestamp strategy**

- Utilizes an `updated_at` field to detect changes in a row.
- If the `updated_at` column is more recent than the last snapshot run, changes are recorded.
- Unchanged timestamps result in no action by _dbt_.

**Check strategy**

- Suitable for tables lacking a usable timestamp column.
- Compares a list of columns between current and historical values.
- Records changes if any columns differ; otherwise, no action is taken by dbt.

By default, dbt does not invalidate rows deleted from the source query. Using the configuration option `invalidate_hard_deletes` , dbt can monitor and manage rows that have been removed from the source data.

<!-- .element: class="admonition important" -->
