{{
    config (
        materialized='incremental',
        schema='STAGING',
        unique_key='HOST_ID'
    )
}}

SELECT 
    HOST_ID,
    TRIM(HOST_NAME) AS HOST_NAME,
    HOST_SINCE,
    IS_SUPERHOST,
    RESPONSE_RATE,
    CASE 
        WHEN RESPONSE_RATE > 80 THEN 'high'
        WHEN RESPONSE_RATE > 50 THEN 'medium'
        ELSE 'low'
    END AS RESPONSE_RATE_CATEGORY,
    CREATED_AT
    
FROM {{ref('raw_hosts')}}

{% if is_incremental()%}
    WHERE CREATED_AT > (SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{this}})
{% endif %}