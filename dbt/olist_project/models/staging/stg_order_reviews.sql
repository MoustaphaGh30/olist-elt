{{ config(materialized='view') }}

with ranked as (
    select
        *,
        row_number() over (partition by review_id
                           order by review_answer_timestamp desc) as rn
    from {{ source('staging', 'olist_order_reviews_dataset') }}
),

de_duplicated as (
    select * from ranked where rn = 1
),

cleaned as (
    select
        review_id,
        order_id,
        cast(review_score as int64)                                   as review_score,

            regexp_replace(
            trim(review_comment_title),
            r"[^-0-9A-Za-zÀ-ÖØ-öø-ÿ.,;:!?()'/%& ]",
            ''
        ) as title_pt,

        regexp_replace(
            trim(review_comment_message),
            r"[^-0-9A-Za-zÀ-ÖØ-öø-ÿ.,;:!?()'/%& ]",
            ''
        ) as message_pt,


        timestamp(review_creation_date)               as review_creation_ts,
        timestamp(review_answer_timestamp)            as review_answer_ts,

        date_diff(review_answer_timestamp,
                  review_creation_date, day)          as response_time_days
    from de_duplicated
)

select *
from cleaned
