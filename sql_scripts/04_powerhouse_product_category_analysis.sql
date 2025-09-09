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
