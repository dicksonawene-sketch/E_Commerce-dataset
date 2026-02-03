/*Cohort Analysis: Customer Retention
Segment customers by first purchase month and calculate how many make additional purchases in the next 3 months.
Focus: Retention strategy and growth analysis.*/

--calculating first purchase month
WITH first_purchase AS (
SELECT
customers_clean.customer_id,
DATE_TRUNC('month', MIN(orders_clean.order_purchase_timestamp)) AS cohort_month
FROM
orders_clean
JOIN customers_clean
ON orders_clean.customer_id = customers_clean.customer_id
GROUP BY customers_clean.customer_id
),
--calculating all purchase months for each customer
customer_activity AS (
SELECT
customers_clean.customer_id,
DATE_TRUNC('month', orders_clean.order_purchase_timestamp) AS order_month
FROM orders_clean
JOIN customers_clean
ON orders_clean.customer_id = customers_clean.customer_id
)

SELECT
first_purchase.cohort_month,
customer_activity.order_month,
COUNT(DISTINCT customer_activity.customer_id) AS active_customers
FROM first_purchase
JOIN customer_activity
ON first_purchase.customer_id = customer_activity.customer_id
GROUP BY
first_purchase.cohort_month,
customer_activity.order_month
ORDER BY
first_purchase.cohort_month,
customer_activity.order_month;

