{{ config(materialized='table', cluster_by=['seller_state']) }}

select
    seller_id                       as seller_sk,
    zip_prefix,
    seller_city,
    seller_state,
    g.lat,
    g.lng
from {{ ref('stg_sellers') }}
left join {{ ref('int_geolocation_zip_centroids') }} g
       using (zip_prefix)
