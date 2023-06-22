<!-- .slide -->

# Analyses

_dbt_ analyses provide a convenient way to perform exploratory data analysis, data validation, and data
profiling tasks within the context of your dbt project.

All models placed in `analyses` directory can refer to other models or macro but will only be compiled and never run
against your data warehouse.

Notes:

In dbt (data build tool), analyses are a feature that allows you to write and execute ad-hoc SQL queries directly
within your dbt project. Analyses provide a convenient way to perform exploratory data analysis, data validation, and
data profiling tasks within the context of your dbt project.

Here's a brief overview of how dbt analyses work:

Defining an Analysis: In your dbt project, you define an analysis by creating a model with the analysis materialization.
You write SQL code within the model's SQL block, specifying the queries you want to run.

Analysis Execution: When you run dbt, it identifies the models with the analysis materialization and executes the SQL
queries defined in the respective models.

Query Results: The results of the analysis queries are displayed in the dbt console or logged to the console output,
depending on how you execute dbt.

Exploratory Data Analysis: With dbt analyses, you can perform exploratory data analysis tasks on your data. This may
include querying, filtering, aggregating, and joining tables to gain insights into the data and validate its quality.

Data Validation: You can use analyses to perform data validation checks against your datasets. This may involve writing
queries to identify missing values, outliers, inconsistencies, or other data quality issues.

Data Profiling: Analyses are useful for data profiling, where you generate summary statistics or calculate metrics on
your datasets. This can help you understand the distribution of values, identify patterns, and uncover potential issues
in the data.

By leveraging dbt analyses, you can bring your SQL-based analysis tasks directly into your dbt project, aligning them
with your other data modeling and transformation workflows. This allows you to maintain a single source of truth for
your data pipeline and facilitates collaboration among team members.

It's worth noting that dbt analyses are typically executed on demand and may not be included as part of your regular dbt
runs. They provide flexibility for running ad-hoc queries and exploring data interactively within the dbt environment.

Overall, dbt analyses empower you to perform exploratory data analysis, data validation, and data profiling tasks
seamlessly within your dbt project, enhancing the overall data development and data management experience.
