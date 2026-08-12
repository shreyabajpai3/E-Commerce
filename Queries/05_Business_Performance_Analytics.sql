-- Intermediate
-- Q1.How has the company's monthly revenue changed over time?
SELECT
    YEAR(o.order_purchase_timestamp) AS Order_Year,
    MONTH(o.order_purchase_timestamp) AS Order_Month,
    ROUND(SUM(oi.price),2) AS Total_Revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    Order_Year,
    Order_Month;
/* Business Insight:
- The business experienced strong growth after 2017,
indicating increasing customer adoption and marketplace expansion.*/

-- Q2.Which customers generated the highest lifetime revenue?
SELECT TOP 10
    c.customer_unique_id,
    ROUND(SUM(oi.price),2) AS Lifetime_Value,
    COUNT(DISTINCT o.order_id) AS Total_Orders
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY Lifetime_Value DESC;
/* Business Insight:
- Identifying high-spending customers helps create targeted retention strategies. */

-- Q3.What percentage of customers have placed more than one order?
WITH CustomerOrders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Orders_Count
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(CASE WHEN Orders_Count > 1 THEN 1 END) AS Repeat_Customers,
    COUNT(*) AS Total_Customers,
    ROUND(
        COUNT(CASE WHEN Orders_Count > 1 THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS Repeat_Customer_Rate
FROM CustomerOrders;
/* Business Insight:
- The business relies heavily on acquiring new customers rather than retaining existing ones. */

-- Advance
-- Q4.Which sellers contribute the highest revenue, and how do they rank?
WITH SellerRevenue AS
(
    SELECT
        seller_id,
        ROUND(SUM(price),2) AS Revenue
    FROM olist_order_items_dataset
    GROUP BY seller_id
)
SELECT TOP 10
    seller_id,
    Revenue,
    RANK() OVER(ORDER BY Revenue DESC) AS Seller_Rank
FROM SellerRevenue
ORDER BY Seller_Rank;
/* Business Insight:
- Seller performance varies widely, meaning seller-level monitoring is important for marketplace growth. */

-- Q5.Which customer states contribute the most revenue?
SELECT
    c.customer_state,
    ROUND(SUM(oi.price),2) AS Total_Revenue,
    ROUND(
        SUM(oi.price) * 100.0 /
        SUM(SUM(oi.price)) OVER (),
        2
    ) AS Revenue_Share_Percentage
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY Total_Revenue DESC;
/* Business Insight:
- The company has strong market presence in major Brazilian states but potential growth
opportunities exist in low-performing regions.
--------------------------------------------------------------------------------------------------------
Recommendation 
Strengthen long-term business growth by improving customer retention, 
rewarding high-performing sellers, expanding into underperforming regions, 
and leveraging customer and sales insights to drive sustainable revenue growth.