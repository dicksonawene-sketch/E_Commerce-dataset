/* Identify High-Value Customers and Their Preferred Categories

 Identify customers whose total spending is above the 75th percentile,
 and list their top 1–2 most purchased product categories. 
 
 Focus: Customer segmentation and targeting */


WITH customer_total_spending AS (
--calculating total spending per customer
SELECT
orders_clean.customer_id,
SUM(order_items_clean.price) AS total_spent
FROM orders_clean
JOIN order_items_clean
ON orders_clean.order_id = order_items_clean.order_id
GROUP BY orders_clean.customer_id
),

high_value_customers AS (
--calculating customers whose spending is above the 75th percentile
SELECT
customer_total_spending.customer_id,
customer_total_spending.total_spent
FROM customer_total_spending
WHERE customer_total_spending.total_spent >= (
SELECT
PERCENTILE_CONT(0.75)
WITHIN GROUP (ORDER BY total_spent)
FROM customer_total_spending)
),

customer_category_spending AS (
--calculating category-level spending for high-value customers
SELECT
high_value_customers.customer_id,
product_category_name_translation.product_category_name_english AS product_category,
SUM(order_items_clean.price) AS category_spent
FROM high_value_customers
JOIN orders_clean
ON high_value_customers.customer_id = orders_clean.customer_id
JOIN order_items_clean
ON orders_clean.order_id = order_items_clean.order_id
JOIN products
ON order_items_clean.product_id = products.product_id
LEFT JOIN product_category_name_translation
ON products.product_category_name =
product_category_name_translation.product_category_name
GROUP BY
high_value_customers.customer_id,
product_category_name_translation.product_category_name_english
)


SELECT
customer_id,
product_category,
category_spent
FROM customer_category_spending
WHERE product_category IS NOT NULL
ORDER BY category_spent DESC;