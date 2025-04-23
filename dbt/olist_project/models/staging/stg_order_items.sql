{{ config(materialized='view') }}

with src as (

    select
        order_id,
        order_item_id,

        product_id,
        seller_id,

        timestamp(shipping_limit_date)              as shipping_limit_ts,
        date(timestamp(shipping_limit_date))        as shipping_limit_date,

        cast(price         as numeric)              as price,
        cast(freight_value as numeric)              as freight_value

    from {{ source('staging', 'order_items') }}

)

select *
from src
