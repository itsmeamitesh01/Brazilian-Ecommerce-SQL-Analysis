# E-commerce: A Deep-Dive SQL Analysis [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
### Author: Amitesh Singh | [LinkedIn](https://www.linkedin.com/in/amiteshsingh2001/) | [Portfolio](https://sites.google.com/view/amitesh-singh-analytics)
---

## Executive Summary

This project is an in-depth SQL analysis of the Olist E-commerce dataset, transforming over 100,000 order records into a strategic business asset. By dissecting customer behavior, operational efficiency, and product performance, this analysis provides actionable, data-driven recommendations to key stakeholders. The final deliverable is an interactive BI dashboard in Looker Studio, designed to empower ongoing strategic decision-making.

---

## Tools & Tech Stack

* **Cloud Data Warehouse:** Google BigQuery
* **Language:** Advanced SQL with CTEs & Window Functions
* **BI & Visualization:** Google Looker Studio

---

## Strategic Analyses & Recommendations

### 1. Customer Value Analysis: The Financial Case for Retention

* **Business Question:** What is the quantifiable value of a repeat customer versus a new one?
* **Insight:** The analysis proved that **repeat customers are 88% more valuable** than single-purchase customers, with an average revenue of **$302.36** compared to **$160.68**. While representing only 3.1% of the customer base, they are a significantly more profitable segment.
* **Strategic Recommendation:** Shift marketing focus from pure acquisition to a **Customer Lifetime Value (CLV)-driven retention strategy**. Launch targeted "Welcome Back" campaigns for the 90,000+ single-purchase customers to convert them into this higher-value group.

---

### 2. Operations Analysis: The Impact of Late Deliveries on Customer Satisfaction

* **Business Question:** What is the direct impact of shipping delays on customer satisfaction scores?
* **Insight:** There is a dramatic negative correlation between shipping delays and customer satisfaction. The average review score **plummets from a positive 4.29 for on-time deliveries to just 1.70 for 'Very Late' orders**—a 60% drop in satisfaction.
* **Strategic Recommendation:** **Prioritize and invest in logistics and delivery accuracy.** This is the single most effective operational lever to pull to protect the brand's reputation and improve the overall customer rating.

---

### 3. Product Analysis: Identifying "Powerhouse" Revenue Categories

* **Business Question:** Which product categories are the financial core of the business?
* **Insight:** Revenue is highly concentrated. The top 3 categories alone—**'Health/Beauty', 'Watches/Gifts', and 'Bed/Bath/Table'—generated over $3.9 million**, establishing them as the primary engines of the business.
* **Strategic Recommendation:** **Allocate a prioritized budget for inventory and marketing spend** to these top categories. Secure the supply chain for these products to ensure they are perpetually in stock.

---

### 4. Advanced Product Ranking: Pinpointing the "Hero Products"

* **Business Question:** Within our most valuable categories, which specific products are our best-sellers?
* **Insight:** Using advanced SQL with window functions, this analysis moved beyond category trends to **pinpoint the 15 individual 'hero products'** that are the true financial drivers of our most important business segments.
* **Strategic Recommendation:** **Immediately launch "Bestseller" marketing campaigns** featuring this curated list of products. Provide this list to the inventory team to ensure these critical items have the highest stock priority.

---

## Interactive BI Dashboard

A comprehensive, interactive dashboard was developed in **Google Looker Studio** to consolidate all project findings into a single source of truth for stakeholders. The dashboard provides a self-service tool to explore customer value, operational performance, and product trends on a state-by-state basis.

**[View the Live Interactive Dashboard](https://lookerstudio.google.com/reporting/dae8637b-c91e-4a04-b64c-c2371deec7cf)**

![Dashboard Screenshot](https://github.com/user-attachments/assets/d56de82d-f8b5-45d4-badb-18ba86318748)
