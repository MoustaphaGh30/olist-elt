{% macro normalize_category(col) %}
    -- trim + lowercase; accents left intact so the join still matches
    lower(trim({{ col }}))
{% endmacro %}
