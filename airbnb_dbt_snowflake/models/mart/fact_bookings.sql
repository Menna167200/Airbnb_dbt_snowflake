{{
    config(
        materialized='incremental',
        schema='MART',
        unique_key='BOOKING_ID'
    )
}}

SELECT 
    b.BOOKING_ID,
    l.DBT_SCD_ID  AS LISTING_KEY,
    h.DBT_SCD_ID  AS HOST_KEY,
    b.BOOKING_DATE, 
    b.NIGHTS_BOOKED, 
    b.BOOKING_AMOUNT,
    b.CLEANING_FEE, 
    b.SERVICE_FEE, 
    b.TOTAL_AMOUNT,
    b.BOOKING_STATUS,
    b.CREATED_AT

FROM {{ref('stg_bookings')}} AS b
LEFT JOIN {{ref('dim_listings')}} AS l
    ON b.LISTING_ID = l.LISTING_ID
LEFT JOIN {{ref('dim_hosts')}} AS h
    ON l.HOST_ID = h.HOST_ID
    

{% if is_incremental() %}
    WHERE b.CREATED_AT > (SELECT MAX(CREATED_AT) FROM {{this}})
{% endif %}
 