{{ config(
    materialized='table',
    partition_by={'field': 'order_purchase_date_ts', 'data_type': 'date'},
    cluster_by=['customer_id','seller_sk']
) }}

with base as (

    select
        oi.order_id,
        oi.order_item_id,

        -- foreign keys
        c.customer_id,
        s.seller_sk,
        p.product_sk,
        d.date_sk                     as order_purchase_date_sk,
        o.order_purchase_date        as order_purchase_date_ts,
        -- metrics
        oi.price                      as item_price,
        oi.freight_value,
        p.is_hazardously_heavy,

        -- snapshot of order‑level dims
        o.order_status,
        o.delivered_on_time

    from {{ ref('stg_order_items') }}                  oi
    join {{ ref('stg_orders') }}                       o  using (order_id)
    join {{ ref('dim_customer') }}                     c  on o.customer_id = c.customer_id
    join {{ ref('dim_seller') }}                       s  on oi.seller_id   = s.seller_sk
    join {{ ref('dim_product') }}                      p  on oi.product_id  = p.product_sk
    join {{ ref('dim_date') }}                         d  on o.order_purchase_date = d.date
)

select * from base
