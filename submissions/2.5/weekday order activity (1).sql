SELECT 
  d.weekday,
  COUNT(o.order_id) AS order_count
FROM `olist-etl-pipeline.staging_dimensional.fact_orders` o
JOIN `olist-etl-pipeline.staging_dimensional.dim_date` d
  ON o.order_purchase_date_sk = d.date_sk
GROUP BY d.weekday
ORDER BY order_count DESC;