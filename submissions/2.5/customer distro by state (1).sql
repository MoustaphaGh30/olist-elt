SELECT 
  customer_state,
  COUNT(*) AS customer_count
FROM `olist-etl-pipeline.staging_dimensional.dim_customer`
GROUP BY customer_state
ORDER BY customer_count DESC;
