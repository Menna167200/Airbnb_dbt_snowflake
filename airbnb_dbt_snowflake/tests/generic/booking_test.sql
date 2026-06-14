{% test booking_test(model, column_name) %}

    SELECT {{column_name}} 
    FROM {{model}}
    WHERE {{column_name}} NOT IN ('confirmed', 'cancelled', 'unknown') --RETURNS FALSE IF ANY OTHER VALUE IS PRESENT IN THE COLUMN

{% endtest %}