WITH customer_segments AS (
SELECT
    c.customer_unique_id, 
	CASE
      WHEN count(o.order_id) > 1 THEN 'Repeat Customer'
      ELSE 'Single-Purchase Customer'
	END customer_segment
FROM
    e-com-469109.olist_project.customers c
JOIN
    e-com-469109.olist_project.orders o
	    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
)
SELECT
    cs.customer_segment,
    COUNT(DISTINCT cs.customer_unique_id) total_customer,
    ROUND(SUM(p.payment_value),2) total_revenue,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT cs.customer_unique_id),2) avg_revenue_per_customer
FROM
    customer_segments cs
JOIN
    e-com-469109.olist_project.customers c
USING (customer_unique_id)
JOIN
    e-com-469109.olist_project.orders o
USING (customer_id)
JOIN
    e-com-469109.olist_project.order_payments p
USING (order_id)
WHERE 
    o.order_status = 'delivered'
GROUP BY
    cs.customer_segment;
