/*************************************************************************************************
-- PROJECT: Brazilian E-commerce SQL Analysis
-- SCRIPT: 03_hero_product_ranking.sql
-- DESCRIPTION: This advanced script identifies the top 3 "hero products" within each of the
--              top 5 highest-revenue product categories. The output is a prioritized list
--              of 15 items perfect for targeted marketing and inventory management.
-- BUSINESS QUESTIONS:
--    - Within our most valuable product categories, which specific products are the best-sellers?
-- METHODOLOGY:
--    1.  [CTE: top_category]: First, identifies the top 5 product categories by total net revenue
--        from successfully 'delivered' orders.
--    2.  [CTE: top_product]: Calculates the total sales volume for every product.
--    3.  [CTE: ranking]: Uses the ROW_NUMBER() window function to rank products by sales volume,
--        partitioned by their category, but only for categories identified in the first step.
--    4.  The final query filters these results to show only the top 3 ranked products per category.
-- AUTHOR: Amitesh Kumar Singh
-- DATE: September 10, 2025
*************************************************************************************************/


WITH top_category AS (
SELECT 
    p.product_category_name, 
    SUM(oi.price + oi.freight_value) net_revenue
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
    net_revenue DESC
LIMIT 5
),
top_product AS (
SELECT 
    p.product_id, 
    p.product_category_name, 
    count(*) total_sold_prod
FROM 
    e-com-469109.olist_project.products p
JOIN 
    e-com-469109.olist_project.order_items oi
USING (product_id)
JOIN 
    e-com-469109.olist_project.orders o
USING (order_id)
WHERE 
    o.order_status = 'delivered'
AND 
    p.product_category_name IS NOT NULL 
AND 
    p.product_category_name <> ''
GROUP BY 
    p.product_id, p.product_category_name
),
ranking AS (
SELECT 
    tp.product_category_name, 
    tp.product_id, 
    tp.total_sold_prod,
    ROW_NUMBER() OVER(PARTITION BY tp.product_category_name ORDER BY tp.total_sold_prod DESC) ranks
FROM 
    top_product tp
WHERE 
    tp.product_category_name IN (SELECT product_category_name FROM top_category)
)
SELECT 
    product_category_name, 
    product_id, 
    total_sold_prod,
    ranks
FROM 
    ranking
WHERE 
    ranks <= 3
ORDER BY 
    product_category_name, ranks;
