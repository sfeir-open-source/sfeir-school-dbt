SELECT
  _customers.*,
  _countries.country_name
FROM {{ ref("seed_customers") }} AS _customers
  INNER JOIN {{ ref("seed_countries") }} AS _countries ON _countries.country_code = _customers.customer_country
WHERE
  _countries.country_code = ANY(ARRAY{{ var('countries') }})
