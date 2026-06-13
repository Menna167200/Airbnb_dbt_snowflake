{{  
    config (
      materialized='incremental',
      schema='RAW'
    )
}}

SELECT * FROM {{source('NODE', 'HOSTS')}}
{% if is_incremental() %}
  WHERE CREATED_AT > (SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{this}}) 
{% endif %}