{{ config(materialized='view') }}

with src as (

    select
        seller_id,

        -- keep numeric for joins, plus padded string for readability
        seller_zip_code_prefix                               as zip_prefix_int,
        lpad(cast(seller_zip_code_prefix as string), 5, '0') as zip_prefix,

        -- clean city:
        --  • keep substring before first '/' if present
        --  • strip " sp" or " sp " suffixes
        --  • initcap for display
        initcap(
            regexp_replace(
                trim(split(seller_city, '/')[SAFE_ORDINAL(1)]),
                r'\s*sp\s*$',        -- remove trailing 'sp'
                ''
            )
        ) as seller_city,

        upper(trim(seller_state))                           as seller_state

    from {{ source('staging', 'olist_sellers') }}

)

select *
from src
