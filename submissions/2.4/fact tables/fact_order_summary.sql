{{ config(materialized='table') }}

select
  o.order_id,
  o.order_purchase_date_sk,
  o.customer_id,
  any_value(o.delivered_on_time)    as delivered_on_time,
  sum(i.item_price)     as merchandise_value,
  sum(i.freight_value)  as freight_value,
  sum(pay.payment_value) as paid_value,
  any_value(r.review_score)         as review_score
from {{ ref('fact_orders') }}        o
left join {{ ref('fact_order_items') }} i   using (order_id)
left join {{ ref('fact_payments') }}   pay using (order_id)
left join {{ ref('fact_reviews') }}    r   using (order_id)
group by
  o.order_id,
  o.order_purchase_date_sk,
  o.customer_id
