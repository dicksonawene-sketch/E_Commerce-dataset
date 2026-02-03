/* Monthly Revenue Trend by Product Category
Calculate monthly revenue per product category and identify which categories
are trending upwards or downwards.
Focus: Business growth and trend detection.*/

SELECT
DATE_TRUNC('month', orders_clean.order_purchase_timestamp) AS order_month,
product_category_name_translation.product_category_name_english AS product_category,
SUM(order_items_clean.price) AS total_monthly_revenue
FROM 
orders_clean
JOIN order_items_clean
ON orders_clean.order_id = order_items_clean.order_id
JOIN products
ON order_items_clean.product_id = products.product_id
JOIN product_category_name_translation
ON products.product_category_name = product_category_name_translation.product_category_name
WHERE orders_clean.order_status = 'delivered'
GROUP BY
order_month,
product_category
ORDER BY
order_month DESC;


