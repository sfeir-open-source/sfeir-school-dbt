<!-- .slide -->

# Snapshots

_dbt_ snapshots provide a powerful capability for tracking and analyzing changes in your data over time, enabling
historical reporting, trend analysis, and audit trail functionality. It allows to maintain point-in-time snapshots of
tables.

<div>

| id | status  | updated_at |
|----|---------|------------|
| 1  | pending | 2023-06-20 |
| 1  | shipped | 2023-06-22 |

</div>
<!-- .element: class="w-800 center" -->

<br/>

With snapshots model, _dbt_ will produce this kind of table:
<!-- .element: class="full-width" -->

<div>

| id | status  | updated_at | dbt_valid_from | dbt_valid_to |
|----|---------|------------|----------------|--------------|
| 1  | pending | 2023-06-20 | 2023-04-26     | 2023-06-22   |
| 1  | shipped | 2023-06-22 | 2023-06-22     | `null`       |

</div>

<!-- .element: class="w-500" -->


Notes:
In dbt (data build tool), snapshots are a feature that allows you to capture and track changes in your data over time.
They provide a way to create and maintain point-in-time snapshots of your data tables, enabling historical analysis and
trend analysis.

When you define a snapshot in dbt, you specify the source table and the columns you want to include in the snapshot. Dbt
then generates SQL code that queries the source table and inserts the snapshot data into a separate snapshot table.

Here's a brief overview of how dbt snapshots work:

Defining a Snapshot: In your dbt project, you define a snapshot by creating a model with the snapshot materialization.
You specify the source table, the columns to include, and any other configuration parameters.

Snapshot Table Creation: When you run dbt, it generates SQL code to create a separate snapshot table. The snapshot table
has the same structure as the source table, with additional metadata columns such as a snapshot timestamp and a primary
key column.

Snapshot Data Extraction: Dbt generates SQL code that queries the source table and extracts the data you specified in
the snapshot definition. It may apply filters or transformations as needed to capture the desired data state.

Snapshot Insertion: The extracted snapshot data is then inserted into the snapshot table. Each time the snapshot runs, a
new row is inserted, capturing a point-in-time snapshot of the data.

Historical Analysis: With the snapshot table populated, you can perform historical analysis by querying the snapshot
table at different points in time. You can compare data across snapshots, track changes, calculate metrics over time,
and gain insights into trends and patterns.

By utilizing dbt snapshots, you can easily capture and manage historical data in a structured and automated manner. This
allows you to perform historical analysis without relying on manual data extraction or maintaining separate versions of
tables.

It's important to note that dbt snapshots are incremental, meaning they only capture changes in the data since the last
snapshot. This ensures efficiency and minimizes the amount of data that needs to be stored for each snapshot.

Overall, dbt snapshots provide a powerful capability for tracking and analyzing changes in your data, enabling
historical reporting, trend analysis, and audit trail functionality.
