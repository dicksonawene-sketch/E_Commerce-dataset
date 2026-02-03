/*  Payment Method Performance

 For each payment method, calculate total revenue, average order value, and number of orders.
 Rank the methods by revenue.

Focus: Optimize payment methods for revenue.*/

SELECT
order_payments.payment_type,
COUNT(DISTINCT orders_clean.order_id) AS number_of_orders,
SUM(order_payments.payment_value) AS total_revenue,
AVG(order_payments.payment_value) AS average_order_value
FROM orders_clean
JOIN order_payments
ON orders_clean.order_id = order_payments.order_id
GROUP BY
order_payments.payment_type
ORDER BY
total_revenue DESC;
