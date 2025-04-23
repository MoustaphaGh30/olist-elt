{{ config(materialized='table', partition_by={'field': 'order_purchase_date_ts', 'data_type': 'date'}) }}

with agg_items as (
    select
        order_id,
        sum(price)         as gross_item_value,
        sum(freight_value) as total_freight,
        count(*)           as n_items
    from {{ ref('stg_order_items') }}
    group by order_id
),

agg_payments as (
    select
        order_id,
        sum(payment_value) as total_paid
    from {{ ref('stg_order_payments') }}
    group by order_id
),
agg_reviews as (
    select
      order_id,
      avg(review_score)        as review_score,
      avg(response_time_days)  as response_time_days
    from {{ ref('stg_order_reviews') }}
    group by order_id
  ),

fact as (
    select
      o.order_id,
      c.customer_id,
      o.order_purchase_date        as order_purchase_date_ts,
      d.date_sk                    as order_purchase_date_sk,
      o.order_status,
      o.delivered_on_time,

      ai.gross_item_value,
      ai.total_freight,
      ap.total_paid,
      ai.n_items,

      ar.review_score,
      ar.response_time_days
    from {{ ref('stg_orders') }} o
    left join agg_items    ai  using(order_id)
    left join agg_payments ap  using(order_id)
    left join agg_reviews  ar  using(order_id)
    join {{ ref('dim_customer') }}          c  on o.customer_id = c.customer_id
    join {{ ref('dim_date') }}              d  on o.order_purchase_date = d.date
)

select * from fact
