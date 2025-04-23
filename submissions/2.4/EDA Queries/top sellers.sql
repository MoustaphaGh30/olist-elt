SELECT 
  s.seller_sk,
  any_value(s.seller_state) as seller_state,
  any_value(s.seller_city) as seller_city,
  ROUND(SUM(oi.item_price), 2) AS total_sales
FROM `olist-etl-pipeline.staging_dimensional.fact_order_items` AS oi
JOIN `olist-etl-pipeline.staging_dimensional.dim_seller` AS s
  ON oi.seller_sk = s.seller_sk
GROUP BY s.seller_sk
ORDER BY total_sales DESC
LIMIT 10;
