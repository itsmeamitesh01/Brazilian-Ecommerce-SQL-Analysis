# Brazilian E-commerce SQL Analysis
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
### Author: Amitesh Singh | <a href="https://www.linkedin.com/in/amiteshsingh2001/">LinkedIn</a>


---

## 1. Project Objective

This project performs an in-depth analysis of the Olist E-commerce dataset, which contains data for over 100,000 orders from a Brazilian marketplace. The goal is to use SQL to explore the data and derive actionable business insights for marketing, operations, and product strategy stakeholders. We aim to answer key questions about customer behavior, product performance, and the drivers of customer satisfaction.

---

## 2. Tools Used

* **Database:** Google BigQuery (primarily), MySQL Workbench (for local prototyping)
* **Language:** Standard SQL
* **Visualization:** Google Looker Studio / Tableau

---

## 3. Key Business Questions & Insights

Here are the four key analyses performed in this project:

### A. Customer Value Analysis: Are repeat customers more valuable?

* **Business Question:** To justify a budget for a new retention marketing program, we need to prove that customers who make repeat purchases are more valuable to the business than single-purchase customers.
* **SQL Query:**
    ```sql
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
    ```
* **Finding:**
  
     <img width="682" height="78" alt="{E678487A-5441-41E4-8B05-C907A934975B}" src="https://github.com/user-attachments/assets/aab83860-550a-4e94-b8f2-034692d35dda" />



* **Insight:** The analysis reveals that repeat customers are **88% more valuable** than single-purchase customers, with an average revenue per customer of **$302.36** compared to **$160.68**. This provides a strong financial justification for a retention-focused marketing strategy.
* **Recommendation:** We recommend launching a pilot program for a "Welcome Back" campaign targeting our 90,000+ single-purchase customers to convert them into higher-value repeat purchasers.

---

### B. Operations Analysis: What is the impact of late deliveries?

* **Business Question:** What is the direct, quantifiable impact of shipping delays on customer satisfaction scores?
* **SQL Query:**
    ```sql
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
    ```
* **Finding:**
  
    <img width="415" height="106" alt="{3E280950-EC1F-41FA-969A-0011787B2F03}" src="https://github.com/user-attachments/assets/09677d9a-7224-4ecd-8d82-e3e01df51793" />


* **Insight:** The analysis reveals a dramatic negative correlation between shipping delays and customer satisfaction. The average review score plummets from a positive 4.29 for on-time deliveries to just 1.70 for 'Very Late' orders—a drop of over 2.6 points (approx.) on our 5-point scale
* **Recommendation:** Improving delivery time accuracy and logistics is the single most effective lever the Operations team can pull to increase the overall company rating.

---

### C. Product Analysis: Which product categories drive the most revenue?

* **Business Question:** What are our "powerhouse" categories? Where is the bulk of our revenue coming from?
* **SQL Query:**
    ```sql
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
    ```
* **Finding:**

    <img width="385" height="161" alt="{1A26702F-E94F-4A9B-BADF-00DA764D97A9}" src="https://github.com/user-attachments/assets/0877538b-4a1c-4dcd-97d9-8818dc06fec8" />


* **Insight:** The analysis reveals a significant concentration of revenue in a few key areas. The top 3 categories alone—beleza_saude (health/beauty), relogios_presentes (watches/gifts), and cama_mesa_banho (bed/bath/table)—generated over $3.9 million in revenue, establishing them as the financial core of the business.
* **Recommendation:** These categories should be prioritized for inventory management, marketing spend, and strategic partnerships to ensure their continued growth.

---

### D. Advanced Product Ranking: What are our "Hero Products"?

* **Business Question:** What are the top 3 best-selling products within each of our top 5 most valuable product categories?
* **SQL Query:**
    ```sql
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
    ```
* **Finding:**
    
    <img width="744" height="432" alt="{13172C85-3F2B-4033-B8DE-74818E88B2F3}" src="https://github.com/user-attachments/assets/d8b6498e-3690-4852-bb7e-6a8c249f0bab" />

* **Insight:** By combining category-level revenue analysis with product-level sales volume, this analysis moves beyond high-level trends to pinpoint the 15 individual 'hero products' that are the true financial engines of our most important business segments. These are our "**crown jewel products**."
* **Recommendation:** This list should be given directly to the marketing team for immediate inclusion in "Bestseller" campaigns and to the inventory team to ensure these critical products are never out of stock.

---

## 4. Interactive Dashboard [**[Link]**](https://lookerstudio.google.com/reporting/dae8637b-c91e-4a04-b64c-c2371deec7cf)

A comprehensive, interactive dashboard was developed in Google Looker Studio to consolidate all project findings into a single source of truth for stakeholders.

The dashboard visualizes the core insights from the analysis, including the financial impact of customer loyalty, the operational drivers of customer satisfaction, and a breakdown of top-performing product lines. An interactive filter allows for the entire report to be viewed on a state-by-state basis, providing granular insights into regional performance.



<img width="1240" height="924" alt="{4C68EFAC-2F50-44B9-8E23-2492EAF4C6AC}" src="https://github.com/user-attachments/assets/d56de82d-f8b5-45d4-badb-18ba86318748" />



