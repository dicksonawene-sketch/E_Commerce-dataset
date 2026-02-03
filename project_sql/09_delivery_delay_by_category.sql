/* Delivery Delay vs Product Category
Identify which product categories experience the longest average delivery delays and how it affects customer reviews.

Focus: Logistics optimization and product-level operational insight.*/

SELECT 
product_category_name_translation.product_category_name_english AS product_category,
ROUND(AVG(EXTRACT(DAY FROM (orders_clean.order_delivered_carrier_date - orders_clean.order_estimated_delivery_date))), 2) AS avg_delivery_delay_days,
ROUND(AVG(order_reviews_clean.review_score), 2) AS avg_review_score,
COUNT(DISTINCT orders_clean.order_id) AS total_orders
FROM
orders_clean
JOIN order_items_clean
ON orders_clean.order_id = order_items_clean.order_id
JOIN products
ON order_items_clean.product_id = products.product_id
JOIN product_category_name_translation
ON products.product_category_name = product_category_name_translation.product_category_name
JOIN order_reviews_clean
ON orders_clean.order_id = order_reviews_clean.order_id
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY avg_delivery_delay_days DESC;