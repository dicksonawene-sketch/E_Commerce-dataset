/*Identify At-Risk Sellers

Identify sellers with average product review scores below 4 and whose monthly sales are 
declining for 3 consecutive months.
Focus: Operational risk & seller performance.*/



--monthly revenue per seller
WITH monthly_seller_revenue AS (
SELECT
order_items_clean.seller_id,
DATE_TRUNC('month', orders_clean.order_purchase_timestamp) AS month,
SUM(order_items_clean.price) AS monthly_revenue
FROM
orders_clean
JOIN order_items_clean
ON orders_clean.order_id = order_items_clean.order_id
GROUP BY
order_items_clean.seller_id,
DATE_TRUNC('month', orders_clean.order_purchase_timestamp)
),

-- Detecting consecutive monthly declines
revenue_trend AS (
SELECT
seller_id,
month,
monthly_revenue,
LAG(monthly_revenue, 1) OVER (PARTITION BY seller_id ORDER BY month) AS previous_month_revenue,
CASE 
WHEN LAG(monthly_revenue, 1) OVER (PARTITION BY seller_id ORDER BY month) > monthly_revenue
 THEN 1
ELSE 0
END AS is_decline
FROM
 monthly_seller_revenue
),

--calculatng count of consecutive declines per seller
declining_sellers AS (
SELECT
seller_id,
SUM(is_decline) AS consecutive_declines
FROM revenue_trend
GROUP BY seller_id
HAVING SUM(is_decline) >= 3
),

--calculating  average review score per seller
seller_reviews AS (
SELECT
order_items_clean.seller_id,
AVG(order_reviews_clean.review_score) AS average_review_score
FROM 
order_items_clean
JOIN order_reviews_clean
ON order_items_clean.order_id = order_reviews_clean.order_id
GROUP BY
order_items_clean.seller_id
)

-- Combining sellers with low review AND declining sales
SELECT
sellers.seller_id,
sellers.seller_city,
sellers.seller_state,
seller_reviews.average_review_score,
declining_sellers.consecutive_declines
FROM 
sellers
JOIN seller_reviews
ON sellers.seller_id = seller_reviews.seller_id
JOIN declining_sellers
ON sellers.seller_id = declining_sellers.seller_id
WHERE seller_reviews.average_review_score < 4
ORDER BY declining_sellers.consecutive_declines DESC;





