-- Basic
-- Q1.Which product categories generate the highest revenue?
SELECT
    pct.product_category_name_english AS Category,
    ROUND(SUM(op.payment_value), 2) AS Total_Revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset pr
    ON oi.product_id = pr.product_id
JOIN product_category_name_translation pct
    ON pr.product_category_name = pct.product_category_name
JOIN olist_order_payments_dataset op
    ON oi.order_id = op.order_id
GROUP BY pct.product_category_name_english
ORDER BY Total_Revenue DESC;
/* Business Insight
- Bed, Bath & Table generated the highest revenue (£1.71M), followed by Health & Beauty and
Computers & Accessories.
- These categories are the primary revenue drivers and should be prioritized for inventory and
promotional campaigns. */

-- Q2.Which are the top 10 best-selling products by number of orders?
SELECT TOP 10
    oi.product_id,
    COUNT(DISTINCT oi.order_id) AS Total_Orders
FROM olist_order_items_dataset oi
GROUP BY oi.product_id
ORDER BY Total_Orders DESC;
/* Business Insight:
- The best-selling product received 467 orders.
- The top 10 products have strong repeat demand and should be prioritized for inventory planning.*/

-- Intermediate
-- Q3.Which product categories have generated more than £500,000 in revenue?
SELECT
    pct.product_category_name_english AS Category,
    ROUND(SUM(op.payment_value),2) AS Total_Revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset pr
    ON oi.product_id = pr.product_id
JOIN product_category_name_translation pct
    ON pr.product_category_name = pct.product_category_name
JOIN olist_order_payments_dataset op
    ON oi.order_id = op.order_id
GROUP BY pct.product_category_name_english
HAVING SUM(op.payment_value) > 500000
ORDER BY Total_Revenue DESC;
/* Business Insight
- 14 product categories generated over £500K in revenue.
- Bed, Bath & Table, Health & Beauty, and Computers & Accessories
are the top revenue-generating categories. */

-- Q4.What is the average selling price of products in each category?
SELECT
    pct.product_category_name_english AS Category,
    ROUND(AVG(oi.price),2) AS Avg_Product_Price
FROM olist_order_items_dataset oi
JOIN olist_products_dataset pr
    ON oi.product_id = pr.product_id
JOIN product_category_name_translation pct
    ON pr.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
ORDER BY Avg_Product_Price DESC;
/* Business Insight
- Computers have the highest average selling price (£1,098.34), 
followed by Small Appliances and Home Appliances.
- Premium-priced categories contribute higher revenue per sale, 
while lower-priced categories rely on higher sales volume. */

-- Q5.Which product categories have sold more than 1,000 units?
SELECT
    pct.product_category_name_english AS Category,
    COUNT(*) AS Total_Units_Sold
FROM olist_order_items_dataset oi
JOIN olist_products_dataset pr
    ON oi.product_id = pr.product_id
JOIN product_category_name_translation pct
    ON pr.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
HAVING COUNT(*) > 1000
ORDER BY Total_Units_Sold DESC;
/* Business Insight
- Bed, Bath & Table sold the highest number of units (11,115),
followed by Health & Beauty and Sports & Leisure.
- These categories represent the highest customer demand and 
should receive priority in inventory planning. */

-- Advanced
-- Q6.Which are the top 5 highest-revenue products within each product category? */
WITH ProductRevenue AS
(
    SELECT
        pct.product_category_name_english AS Category,
        oi.product_id,
        ROUND(SUM(oi.price),2) AS Total_Revenue
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset pr
        ON oi.product_id = pr.product_id
    JOIN product_category_name_translation pct
        ON pr.product_category_name = pct.product_category_name
    GROUP BY
        pct.product_category_name_english,
        oi.product_id
),
RankedProducts AS
(
    SELECT *,
           RANK() OVER
           (
               PARTITION BY Category
               ORDER BY Total_Revenue DESC
           ) AS Product_Rank
    FROM ProductRevenue
)
SELECT
    Category,
    product_id,
    Total_Revenue,
    Product_Rank
FROM RankedProducts
WHERE Product_Rank <= 5
ORDER BY Category, Product_Rank;
/* Business Insight
- A small number of products generate a significant share of revenue within each category.
- Categories like Health & Beauty, Bed Bath Table, Furniture Decor, Watches & Gifts,
and Computers Accessories have clear best-selling products.
- These products should receive priority in inventory planning, marketing campaigns,
and supplier negotiations.
- Low-performing products in the same category can be reviewed for discontinuation or 
promotional strategies.*/

-- Q7.Who are the Top 10 sellers based on total revenue generated?
SELECT TOP 10
    s.seller_id,
    COUNT(DISTINCT oi.order_id) AS Total_Orders,
    SUM(oi.price) AS Total_Revenue,
    AVG(oi.price) AS Avg_Order_Value
FROM olist_sellers_dataset s
JOIN olist_order_items_dataset oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY Total_Revenue DESC;
/* Business Insight
- Revenue is concentrated among a small number of sellers, indicating that a few sellers 
contribute significantly to marketplace performance.
- Seller 4869f7... generated the highest revenue (229,472.63) while processing over 1,100
orders, demonstrating both high sales volume and consistent demand.
- Seller 4a3ca9... handled the highest number of orders (1,806), suggesting strong operational
capacity despite a lower average order value.
- Seller 532435... recorded the highest average order value (543.36), indicating a focus on 
premium or high-priced products.
---------------------------------------------------------------------------------------------------------
Recommendation
Prioritise inventory and marketing for high-performing products and categories, 
maintain stock availability for best sellers, and optimise or discontinue low-performing products 
to improve profitability and operational efficiency.