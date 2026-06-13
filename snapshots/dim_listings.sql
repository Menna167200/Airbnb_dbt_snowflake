{% snapshot dim_listings %}

    {{
        config (
            target_schema='MART',
            unique_key='LISTING_ID',
            strategy='timestamp',
            updated_at='CREATED_AT'

        )
    }}

    SELECT 
        LISTING_ID,
        HOST_ID,
        PROPERTY_TYPE, 
        ROOM_TYPE,
        CITY,
        COUNTRY,
        ACCOMMODATES,
        BEDROOMS,
        BATHROOMS,
        PRICE_PER_NIGHT,
        CREATED_AT

    FROM {{ref('stg_listings')}}

{% endsnapshot %}