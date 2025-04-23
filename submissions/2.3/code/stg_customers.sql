{{ config(materialized='view') }}

with src as (

    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix                          as zip_prefix_int,
        lpad(cast(customer_zip_code_prefix as string), 5, '0')
                                                        as zip_prefix,
        initcap(trim(customer_city))                     as customer_city,
        upper(trim(customer_state))                      as customer_state
    from {{ source('staging', 'customers') }}

)

select * from src
