{{ config(materialized='table') }}

select
    product_id                  as product_sk,
    coalesce(category_en, category_pt)  as category_en,
    photos_qty,
    weight_g,
    length_cm,
    height_cm,
    width_cm,
    volume_cm3,
    is_hazardously_heavy
from {{ ref('stg_products') }}
