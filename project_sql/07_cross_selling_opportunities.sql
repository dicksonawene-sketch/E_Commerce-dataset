/*Complex Query: Cross-Selling Opportunities
Identify customers who bought Category A but never bought Category B. Estimate potential
revenue if they purchase Category B.

Focus: Upsell / cross-sell strategy.*/



--Calculating customers who bought Category A
WITH category_A_customers AS (
SELECT DISTINCT
customers_clean.customer_id
FROM
orders_clean
JOIN order_items_clean
ON orders_clean.order_id = order_items_clean.order_id
JOIN products
ON order_items_clean.product_id = products.product_id
JOIN product_category_name_translation
ON products.product_category_name = product_category_name_translation.product_category_name
JOIN customers_clean
ON orders_clean.customer_id = customers_clean.customer_id
WHERE product_category_name_translation.product_category_name_english LIKE '%construction%' AND customers_clean.customer_id IS NOT NULL
)

--Calculating customers who bought Category B
category_B_customers AS (
SELECT DISTINCT
customers_clean.customer_id
FROM
orders_clean
JOIN order_items_clean
ON orders_clean.order_id = order_items_clean.order_id
JOIN products
ON order_items_clean.product_id = products.product_id
JOIN product_category_name_translation
ON products.product_category_name = product_category_name_translation.product_category_name
JOIN customers_clean
ON orders_clean.customer_id = customers_clean.customer_id
WHERE product_category_name_translation.product_category_name_english = 'electronics' AND customers_clean.customer_id IS NOT  NULL
)

--Calcuating customers who bought A but NOT B

SELECT customer_id
FROM category_A_customers
WHERE NOT EXISTS (
 SELECT 1
 FROM category_B_customers
 WHERE category_A_customers.customer_id = category_B_customers.customer_id
);
