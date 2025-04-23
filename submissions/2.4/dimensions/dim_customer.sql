{{ config(materialized='view') }}

with src as (

    select
        customer_id,
        customer_unique_id,
        zip_prefix_int                          as zip_prefix_int,
        lpad(cast(zip_prefix as string), 5, '0')
                                                        as zip_prefix,
        initcap(trim(customer_city))                     as customer_city,
        upper(trim(customer_state))                      as customer_state
    from {{ ref('stg_customers') }}

)

select * from src
