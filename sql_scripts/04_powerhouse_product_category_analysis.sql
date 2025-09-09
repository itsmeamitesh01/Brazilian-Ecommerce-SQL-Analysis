/*************************************************************************************************
-- PROJECT: Brazilian E-commerce SQL Analysis
-- SCRIPT: powerhouse_product_category_analysis.sql
-- DESCRIPTION: This script identifies the top 5 highest-revenue "powerhouse" product categories
--              from the Olist dataset to inform strategic business decisions.
-- BUSINESS QUESTION:
--    - Which 5 product categories generate the most total revenue from completed sales?
-- METHODOLOGY:
--    - Revenue is calculated as the sum of product price and freight value.
--    - Analysis is restricted to orders with a 'delivered' status to ensure only
--      successful transactions are counted.
--    - Excludes products without a valid category name.
-- AUTHOR: Amitesh Kumar Singh
-- DATE: September 10, 2025
*************************************************************************************************/


SELECT
    p.product_category_name, 
    ROUND(SUM(oi.price + oi.freight_value), 2) total_payment
FROM 
    e-com-469109.olist_project.order_items oi
JOIN 
    e-com-469109.olist_project.products p
USING (product_id)
JOIN 
    e-com-469109.olist_project.orders o
USING (order_id)
WHERE 
    p.product_category_name IS NOT NULL 
AND 
    p.product_category_name <> ''
AND 
    o.order_status = 'delivered'
GROUP BY 
    p.product_category_name
ORDER BY 
    total_payment DESC
LIMIT 5;
