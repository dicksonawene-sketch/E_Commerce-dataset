/*Delivery Timeliness vs Customer Satisfaction
Analyze if delivery delays (before/on-time/late) affect customer review scores.

Focus: Delivery/logistics impact on customer satisfaction.*/


SELECT 
CASE 
WHEN orders_clean.order_delivered_carrier_date < orders_clean.order_estimated_delivery_date 
THEN 'Early'
WHEN orders_clean.order_delivered_carrier_date = orders_clean.order_estimated_delivery_date 
THEN 'On-time'
WHEN orders_clean.order_delivered_carrier_date > orders_clean.order_estimated_delivery_date 
THEN 'Late'
ELSE 'Not Delivered' 
END AS delivery_status,
COUNT(order_reviews_clean.review_id) AS total_reviews,
ROUND(AVG(order_reviews_clean.review_score), 2) AS avg_review_score
FROM
orders_clean
JOIN order_reviews_clean
ON orders_clean.order_id = order_reviews_clean.order_id
GROUP BY delivery_status


