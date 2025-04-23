SELECT 
  o.order_status,
  ROUND(AVG(p.payment_value), 2) AS avg_payment
FROM `olist-etl-pipeline.staging_dimensional.fact_orders` AS o
JOIN `olist-etl-pipeline.staging_dimensional.fact_payments` AS p
  ON o.order_id = p.order_id
GROUP BY o.order_status
ORDER BY avg_payment DESC;
