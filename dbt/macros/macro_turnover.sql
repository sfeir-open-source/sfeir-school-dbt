{% macro turnover(_include_rebate) %}
    (
      base_price * quantity
      {% if _include_rebate %}
      - rebate
      {% endif %}
    )
{% endmacro %}
