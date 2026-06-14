{{
    config (
        materialized='incremental',
        schema='STAGING',
        unique_key='LISTING_ID'
    )
}}

SELECT 
    LISTING_ID,
    HOST_ID,
    PROPERTY_TYPE, 
    ROOM_TYPE,
    COALESCE(TRIM(CITY), 'unknown') AS CITY,
    COALESCE(TRIM(COUNTRY), 'unknown') AS COUNTRY,
    ACCOMMODATES,
    BEDROOMS,
    BATHROOMS,
    PRICE_PER_NIGHT,
    CREATED_AT

FROM {{ref('raw_listings')}}

{% if is_incremental()%}
    WHERE CREATED_AT > (SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{this}})
{% endif %}