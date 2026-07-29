-- Basic
-- Q1 How many unique customers does the marketplace have?
SELECT COUNT(DISTINCT customer_unique_id) AS Total_Customers
FROM olist_customers_dataset;

-- Q2 How many customers placed more than one order?
SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS Total_Orders
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY Total_Orders DESC;
/* Business Insight
- Out of 96,096 unique customers, only about 2,900 made repeat purchases, indicating a 
relatively low repeat purchase rate.
- Most customers purchased only once, suggesting customer retention is a key opportunity.
- A small group of highly loyal customers generated multiple orders and should be targeted 
with loyalty initiatives.*/

-- Intermediate
-- Q3. Who are the top 10 customers based on total spending?
SELECT TOP 10
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    SUM(oi.price) AS Total_Spent,
    AVG(oi.price) AS Avg_Order_Value
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY Total_Spent DESC;
/* Business Insight
- The highest-spending customer generated R$13,440 in revenue from a single order.
- Most of the top 10 customers made only one purchase, indicating that high revenue 
is driven by high-value transactions rather than repeat buying.
- Only one customer in the top 10 placed more than one order, highlighting an
opportunity to improve customer retention.*/

-- Q4. How can customers be segmented based on their total spending?
WITH Customer_Spending AS
(SELECT
        c.customer_unique_id,
        SUM(oi.price) AS Total_Spent
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id)
SELECT
    CASE
        WHEN Total_Spent >= 1000 THEN 'High Value'
        WHEN Total_Spent >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Total_Spent),2) AS Avg_Spending
FROM Customer_Spending
GROUP BY
    CASE
        WHEN Total_Spent >= 1000 THEN 'High Value'
        WHEN Total_Spent >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END
ORDER BY Avg_Spending DESC;
/* Business Insight
- Most customers (95%) belong to the low-value segment, while only 1% are high-value 
customers, highlighting that a small customer group contributes disproportionately 
to revenue.*/

-- Advance
-- Q5. How can customers be segmented based on their purchasing behaviour using RFM
--(Recency, Frequency, Monetary) analysis?
WITH RFM AS
(
    SELECT
        c.customer_unique_id,
        DATEDIFF(
            DAY,
            MAX(CAST(o.order_purchase_timestamp AS DATE)),
            (SELECT MAX(CAST(order_purchase_timestamp AS DATE))
             FROM olist_orders_dataset)
        ) AS Recency,
        COUNT(DISTINCT o.order_id) AS Frequency,
        ROUND(SUM(oi.price),2) AS Monetary
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
),
Scores AS
(
    SELECT *,
        6 - NTILE(5) OVER (ORDER BY Recency ASC) AS R_Score,
        6 - NTILE(5) OVER (ORDER BY Frequency DESC) AS F_Score,
        6 - NTILE(5) OVER (ORDER BY Monetary DESC) AS M_Score
    FROM RFM
)
SELECT Top 10
    customer_unique_id,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    CONCAT(R_Score, F_Score, M_Score) AS RFM_Score
FROM Scores
ORDER BY
    R_Score DESC,
    F_Score DESC,
    M_Score DESC;
/* Business Insight
- Customers with an RFM score of 555 are the marketplace's most valuable customers,
characterized by recent purchases, frequent orders, and high spending. 
These customers have the highest potential for long-term retention and revenue 
generation.
---------------------------------------------------------------------------------------------------------
Recommendation
Retain high-value (555) customers through loyalty programs, exclusive offers, 
and personalized recommendations, while creating targeted campaigns to improve 
the engagement of lower RFM segments.*/
