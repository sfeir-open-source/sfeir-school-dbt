{% macro order_completed() %}
    AND order_status IN ("COMPLETED", "PROCESSING")
    AND order_date < CURRENT_DATE - INTERVAL '2 days'
{% endmacro %}
