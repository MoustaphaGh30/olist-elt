{{ config(materialized='view') }}

with src as (

    select
        order_id,
        payment_sequential,

        lower(trim(payment_type))                    as payment_type,

        cast(payment_installments as int64)          as payment_installments,
        cast(payment_value        as numeric)        as payment_value,

        payment_value = 0                            as is_free

    from {{ source('staging', 'order_payments') }}

)

select *
from src
