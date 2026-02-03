/* Analysis: Identifying Top Revenue-Generating Products, Categories & Sellers
Goal: Identify the top-performing products, product categories, and sellers contributing 
the most to revenue.
Examine which customers are high-value and understand their preferred product categories.

Find the top 10 products generating the highest total revenue, including category,
 seller, and average price per product.
 
 Focus: Profit and revenue insight.*/


SELECT
product_category_name_translation.product_category_name_english AS product_category,
order_items_clean.seller_id AS seller_id,
ROUND(AVG(order_items_clean.price), 2) AS average_price,
COUNT(*) AS total_units_sold,
SUM(order_items_clean.price) AS total_revenue
FROM 
order_items_clean
INNER JOIN products
ON order_items_clean.product_id = products.product_id
LEFT JOIN product_category_name_translation
ON products.product_category_name = product_category_name_translation.product_category_name
INNER JOIN sellers
ON order_items_clean.seller_id = sellers.seller_id
GROUP BY
product_category_name_translation.product_category_name_english,
order_items_clean.seller_id
ORDER BY
total_revenue DESC
LIMIT 10;

