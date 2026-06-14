-- u can check that here https://docs.getdbt.com/reference/resource-configs/snapshots-jinja-legacy?version=1.13
{% snapshot dim_hosts %}

    {{
        config (
            target_schema='MART',
            unique_key='HOST_ID',
            strategy='timestamp',
            updated_at='CREATED_AT'
        )
    }}

    SELECT 
        HOST_ID,
        HOST_NAME,
        HOST_SINCE,
        IS_SUPERHOST,
        RESPONSE_RATE,
        RESPONSE_RATE_CATEGORY,
        CREATED_AT
    FROM {{ref('stg_hosts')}}

{% endsnapshot %}