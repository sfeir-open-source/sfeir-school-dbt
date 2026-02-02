-- Welcome to your first dbt model!
-- This is an example model that you can use as a starting point

{{ config(materialized='view') }}

select
    1 as id,
    'Example' as name,
    current_timestamp as created_at
