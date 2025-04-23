{{ config(materialized='table', partition_by={'field': 'date', 'data_type': 'date'}) }}

with calendar as (
  select
    date                                    as date,          -- raw date
    cast(format_date('%Y%m%d', date) as int64) as date_sk,
    extract(year  from date)                as year,
    extract(quarter from date)              as quarter,
    extract(month from date)                as month,
    extract(dayofweek from date)            as weekday
  from unnest(generate_date_array('2016-01-01','2018-12-31', interval 1 day)) as date
)

select *,
       weekday in (1,7) as is_weekend        -- ← now weekday is visible
from calendar
