-- Basic
-- Q1. What is the distribution of orders across different order statuses?
SELECT
    order_status,
    COUNT(*) AS Total_Orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS Percentage
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY Total_Orders DESC;
/* Business Insight
- 97.02% of all orders were successfully delivered, indicating a highly reliable 
order fulfillment process. Less than 1% of orders were cancelled or unavailable. */

-- Intermediate 
-- Q2. How long does it take, on average, to deliver an order to customers?
SELECT
    AVG(DATEDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date)) AS Avg_Delivery_Days
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;
/* Business Insight
- The average delivery time is 12 days, providing a benchmark for evaluating 
logistics performance and customer delivery expectations. */

-- Q3. How many orders were delivered later than the estimated delivery date?
SELECT
    COUNT(*) AS Delayed_Orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM olist_orders_dataset
         WHERE order_delivered_customer_date IS NOT NULL),
        2
    ) AS Delay_Percentage
FROM olist_orders_dataset
WHERE order_delivered_customer_date > order_estimated_delivery_date;
/* Business Insight
- 7,827 orders (8.11%) were delivered after the estimated delivery date, 
indicating opportunities to improve delivery reliability. */

-- Q4. How has the number of orders changed over time?
SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    MONTH(order_purchase_timestamp) AS Order_Month,
    COUNT(order_id) AS Total_Orders
FROM olist_orders_dataset
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY
    Order_Year,
    Order_Month;
/* Business Insight
- Orders increased steadily throughout 2017, peaking at 7,544 orders in November 2017.
Order volume remained consistently high during 2018, indicating strong marketplace 
growth and increased customer demand.*/

--Q5.Which states generate the highest number of customer orders?
SELECT TOP 10
    c.customer_state,
    COUNT(o.order_id) AS Total_Orders
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY Total_Orders DESC;
/* Business Insight
- São Paulo (SP) generated 41,746 orders, significantly outperforming every other state.
Rio de Janeiro (RJ) and Minas Gerais (MG) were the next largest markets. */

-- Advance
-- Q6. Which states experience the fastest and slowest deliveries?
SELECT
    c.customer_state,
    AVG(DATEDIFF(DAY,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date)) AS Avg_Delivery_Days
FROM olist_orders_dataset o
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY Avg_Delivery_Days DESC;
/* Business Insight
- Delivery performance varies significantly across Brazil. São Paulo (8 days) and 
Minas Gerais (11 days) had the fastest deliveries, whereas Roraima (29 days) and
Amapá (27 days) experienced the longest delivery times.
--------------------------------------------------------------------------------------
Recommendation:
Focus on improving logistics efficiency by reducing delivery delays in 
underperforming regions, preparing inventory for seasonal demand spikes, 
and strengthening operations in high-volume states. These initiatives can 
enhance customer satisfaction, improve delivery reliability, and support 
continued business growth.*/