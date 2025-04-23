{{ config(materialized='view') }}


with src as (

    select
        product_id,

        -- raw Portuguese category string, coalesced to 'unknown'
        coalesce({{ normalize_category("product_category_name") }}, 'unknown')
                                                            as category_pt,

        -- numeric clean‑ups: 0 ➜ NULL, cast to NUMERIC for precision
        nullif(cast(product_name_lenght          as int64), 0)        as name_len,
        nullif(cast(product_description_lenght   as int64), 0)        as description_len,
        nullif(cast(product_photos_qty           as int64), 0)        as photos_qty,

        nullif(cast(product_weight_g             as numeric), 0)      as weight_g,
        nullif(cast(product_length_cm            as numeric), 0)      as length_cm,
        nullif(cast(product_height_cm            as numeric), 0)      as height_cm,
        nullif(cast(product_width_cm             as numeric), 0)      as width_cm

    from {{ source('staging', 'olist_products') }}

), joined as (

    select
        src.*,
        -- bring the English translation (may be NULL if not found)
        cat.product_category_name_english          as category_en
    from src
    left join {{ source('staging', 'category_names') }} cat
           on cat.product_category_name = src.category_pt

), derived as (

    select
        *,
        case
            when length_cm is null
              or height_cm is null
              or width_cm  is null
            then null
            else length_cm * height_cm * width_cm
        end                                           as volume_cm3,

        weight_g > 25000                              as is_hazardously_heavy

    from joined

)

select *
from derived
