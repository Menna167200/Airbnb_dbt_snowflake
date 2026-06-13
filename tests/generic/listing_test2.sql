{% test listing_test_2(model, column_name) %}
    SELECT {{column_name}} 
    FROM {{model}}
    WHERE {{column_name}} NOT IN ('Entire home', 'Private room') 

{% endtest %}
