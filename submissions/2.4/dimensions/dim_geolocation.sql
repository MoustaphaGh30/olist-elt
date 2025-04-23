{{ config(materialized='table', cluster_by='geolocation_zip_code_prefix') }}

with
  centroid as (
    select
      zip_prefix,
      lat,
      lng
    from {{ ref('int_geolocation_zip_centroids') }}
  ),
  any_city as (
    select
      zip_prefix_int,
      any_value(geolocation_city)  as city,
      any_value(geolocation_state) as state
    from {{ ref('stg_geolocation') }}
    group by zip_prefix_int
  )

select
  c.zip_prefix    as geolocation_zip_code_prefix,
  c.lat               as geolocation_lat,
  c.lng               as geolocation_lng,
  ac.city             as geolocation_city,
  ac.state            as geolocation_state
from centroid c
left join any_city ac
  on c.zip_prefix = CAST(ac.zip_prefix_int AS STRING)
