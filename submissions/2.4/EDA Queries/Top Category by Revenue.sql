SELECT 
  p.category_en,
  ROUND(SUM(oi.item_price), 2) AS total_revenue
FROM `olist-etl-pipeline.staging_dimensional.fact_order_items` AS oi
JOIN `olist-etl-pipeline.staging_dimensional.dim_product` AS p
  ON oi.product_sk = p.product_sk
GROUP BY p.category_en
ORDER BY total_revenue DESC
LIMIT 10;
