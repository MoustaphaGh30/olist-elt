{{ config(materialized='view') }}

with src as (

    select
        order_id,
        customer_id,

        lower(trim(order_status))                             as order_status,

        -- Original timestamps (UTC)
        timestamp(order_purchase_timestamp)                   as order_purchase_ts,
        timestamp(order_approved_at)                          as order_approved_ts,
        timestamp(order_delivered_carrier_date)               as order_delivered_carrier_ts,
        timestamp(order_delivered_customer_date)              as order_delivered_customer_ts,
        timestamp(order_estimated_delivery_date)              as order_estimated_delivery_ts,

        -- Date parts (handy for partitioning & joins)
        date(order_purchase_timestamp)                        as order_purchase_date,
        date(order_estimated_delivery_date)                   as order_estimated_delivery_date,

        -- Derived service‑level metrics
        date_diff(order_estimated_delivery_date,
                  order_purchase_timestamp, day)              as days_estimated_delivery,

        date_diff(order_delivered_customer_date,
                  order_purchase_timestamp, day)              as days_actual_delivery,

        case
            when order_delivered_customer_date is null
                 or order_estimated_delivery_date is null
            then null
            when order_delivered_customer_date <= order_estimated_delivery_date
            then true
            else false
        end                                                   as delivered_on_time

    from {{ source('staging', 'olist_orders') }}

)

select *
from src
