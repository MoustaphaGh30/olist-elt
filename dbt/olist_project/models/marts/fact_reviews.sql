{{config(
    unique_key = ('review_id')
)}}

SELECT
  review_id,
  order_id,
  review_score,
  review_comment_title,
  review_comment_message,
  review_creation_date,
  review_answer_timestamp
FROM {{ source('staging', 'olist_order_reviews_dataset') }}

{% if is_incremental() %}
  where review_creation_date > (
    select max(review_creation_date) from {{ this }}
  )
{% endif %}
