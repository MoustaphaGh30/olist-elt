{{ config(materialized='table', partition_by={'field': 'zip_prefix', 'data_type': 'string'}) }}

select
    zip_prefix,
    approx_quantiles(geolocation_lat , 2)[offset(1)] as lat,
    approx_quantiles(geolocation_lng , 2)[offset(1)] as lng
from {{ ref('stg_geolocation') }}
group by zip_prefix
