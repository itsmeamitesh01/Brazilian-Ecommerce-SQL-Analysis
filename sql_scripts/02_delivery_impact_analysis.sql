/*************************************************************************************************
-- PROJECT: Brazilian E-commerce SQL Analysis
-- SCRIPT: 02_delivery_impact_analysis.sql
-- DESCRIPTION: This script analyzes the impact of shipping delays on customer satisfaction.
--              It calculates the difference between estimated and actual delivery dates
--              and correlates these delays with customer review scores.
-- BUSINESS QUESTION:
--    - How much do shipping delays affect customer review scores?
-- METHODOLOGY:
--    1.  [CTE: time_diff]: Calculates the shipping delay in days for each delivered order.
--    2.  [CTE: delay_segments]: Categorizes each order into segments ('On Time or Early',
--        'Slightly Late', 'Very Late') based on the delay.
--    3.  The final query joins with the reviews table and calculates the average review score
--        for each delay segment, proving the relationship between timeliness and satisfaction.
-- AUTHOR: Amitesh Kumar Singh
-- DATE: September 10, 2025
*************************************************************************************************/


WITH time_diff AS (
SELECT 
    order_id, 
    DATE_DIFF(
        CAST(order_delivered_customer_date AS TIMESTAMP),
        CAST(order_estimated_delivery_date AS TIMESTAMP),
        DAY
    ) AS ship_delay
FROM 
    e-com-469109.olist_project.orders
WHERE 
    order_estimated_delivery_date IS NOT NULL 
AND 
    order_delivered_customer_date IS NOT NULL
),
delay_segments AS (
SELECT 
    order_id, 
    ship_delay,
    CASE 
        WHEN ship_delay <= 0 THEN 'On Time or Early'
        WHEN ship_delay BETWEEN 1 AND 7 THEN 'Slightly Late'
        ELSE 'Very Late'
    END AS delay_segment
FROM 
    time_diff
)
SELECT 
    ds.delay_segment, 
    ROUND(AVG(r.review_score), 2) AS avg_delay_review_score
FROM 
    delay_segments ds
JOIN 
    e-com-469109.olist_project.order_reviews r
USING (order_id)
GROUP BY 
    ds.delay_segment
ORDER BY 
    avg_delay_review_score DESC;
