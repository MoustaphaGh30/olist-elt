{{ config(materialized='view') }}

with src as (

    select
        geolocation_zip_code_prefix                              as zip_prefix_int,
        lpad(cast(geolocation_zip_code_prefix as string), 5, '0') as zip_prefix,

        -- keep raw coords as‑is
        geolocation_lat,
        geolocation_lng,

        initcap(trim(geolocation_city))                           as geolocation_city,
        upper(trim(geolocation_state))                            as geolocation_state

    from {{ source('staging', 'geolocation') }}

)

select *
from src
