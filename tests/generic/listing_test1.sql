{% test listing_test_1(model, column_name) %}
    SELECT {{column_name}} 
    FROM {{model}}
    WHERE {{column_name}} NOT IN ('House', 'Apartment', 'Condo')

{% endtest %}

