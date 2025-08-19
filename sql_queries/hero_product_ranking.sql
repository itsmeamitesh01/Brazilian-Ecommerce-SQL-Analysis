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