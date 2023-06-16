SELECT * FROM {{ ref("seed_customers") }} WHERE enabled = '{{ var("customer_enabled", "yes") | upper }}'
