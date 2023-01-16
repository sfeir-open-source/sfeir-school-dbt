SELECT * FROM {{ source('seeds', 'country_codes') }} ORDER BY country_code
