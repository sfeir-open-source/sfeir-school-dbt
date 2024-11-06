{% macro turnover() %}
  (
  (base_price * quantity - rebate)
  * CASE currency
        WHEN 'EUR' THEN 1
        WHEN 'USD' THEN 1.1
    END
  )
{% endmacro %}