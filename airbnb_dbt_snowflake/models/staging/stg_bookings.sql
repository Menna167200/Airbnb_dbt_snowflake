{{
    config (
        materialized='incremental',
        schema='STAGING',
        unique_key='BOOKING_ID'
    )
}}

SELECT 
    BOOKING_ID,
    LISTING_ID, 
    BOOKING_DATE, 
    NIGHTS_BOOKED, 
    BOOKING_AMOUNT, 
    COALESCE(CLEANING_FEE, 0) AS CLEANING_FEE, 
    SERVICE_FEE, 
    BOOKING_AMOUNT + COALESCE(CLEANING_FEE, 0) + SERVICE_FEE AS TOTAL_AMOUNT,
    COALESCE(TRIM(BOOKING_STATUS), 'unknown') AS BOOKING_STATUS,
    CREATED_AT
    
FROM {{ref('raw_bookings')}}

-- SERVICE_FEE is expected to be positive when present.
-- NULL values are allowed for listings without a SERVICE_FEE(as some don't include it).
WHERE (SERVICE_FEE > 0 OR SERVICE_FEE IS NULL)
{% if is_incremental() %}
    AND CREATED_AT > (SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{this}})
{% endif %}