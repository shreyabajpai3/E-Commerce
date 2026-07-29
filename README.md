# 🛒 E-Commerce Business Insights — SQL

Delivering Actionable Analytics Across Finance, Product, Customer, and Order Fulfillment using Advanced SQL

## Business Context

This project analyzes a real, anonymized e-commerce marketplace transaction dataset (Olist, Brazil, 2016–2018) to uncover actionable insights across four business verticals — Finance, Product Performance, Customer Behavior, and Order Fulfillment/Business Performance. The queries reflect realistic analytics problems (revenue tracking, customer segmentation, delivery performance, seller ranking) and use production-grade SQL techniques — CTEs, window functions, and RFM segmentation — to support stakeholder decision-making.

## Table of Contents
- [About the Project](#about-the-project)
- [Business Domains Covered](#business-domains-covered)
- [Database Schema](#database-schema)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Tools & Technologies](#tools--technologies)
- [Methodology Notes](#methodology-notes)
- [Key Stakeholder Insights](#key-stakeholder-insights)
- [Query Bank Summary](#query-bank-summary)
- [Getting Started](#getting-started)
- [Author](#author)

## About the Project

This project simulates a real-world e-commerce analytics use case where SQL is used to extract stakeholder-relevant insights from a normalized, multi-table transactional dataset. It covers four business domains and uses CTEs, window functions (`RANK()`, `NTILE()`, `SUM() OVER()`), and RFM (Recency-Frequency-Monetary) customer segmentation to drive data storytelling grounded in real numbers, not assumptions.

## Business Domains Covered

- **Finance & Revenue** — total revenue, payment method mix, monthly trends
- **Product Analytics** — category/product revenue, top sellers, pricing patterns
- **Customer Analytics** — repeat purchase rate, spend-based segmentation, RFM scoring
- **Order & Business Performance** — delivery time, order status, regional performance, seller ranking

## Database Schema

Real Olist marketplace tables, joined across customers, orders, order items, payments, products, and sellers:

| Table Name | Description |
|---|---|
| `olist_customers_dataset` | Customer ID and location (city, state) |
| `olist_orders_dataset` | Order status and timestamps (purchase, delivery, estimated delivery) |
| `olist_order_items_dataset` | Line items per order — product, seller, price |
| `olist_order_payments_dataset` | Payment type, installment count, and value per order |
| `olist_products_dataset` | Product category and attributes |
| `olist_sellers_dataset` | Seller ID and location |
| `product_category_name_translation` | Maps Portuguese category names to English |

All monetary values are in **Brazilian Real (R$)**.

## Entity Relationship Diagram

See [`Schema/`](Schema/) for the full ER diagram and table creation scripts.

## Tools & Technologies

- SQL Server Management Studio (SSMS)
- Microsoft SQL Server
- Dataset: [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- GitHub

## Methodology Notes

- **Revenue filtering:** revenue and business-performance queries filter to `order_status = 'delivered'`, since cancelled/unavailable orders aren't realized revenue. Operational queries (status distribution, delivery time) intentionally include all statuses, since that's what they're measuring.
- **Product/category revenue** is calculated from `order_items.price` (item-level sale price), not `order_payments.payment_value`. Payments are recorded per order and can span multiple installments — joining them directly to line items would double-count revenue on multi-item orders. Payment-level totals are used only for whole-order/business-wide revenue (Finance file), never for per-product attribution.
- **Average Order Value** is computed by first aggregating payments per order in a CTE, then averaging — not by averaging raw payment rows, which conflates installments with orders.

## Key Stakeholder Insights

### Finance
- Total revenue generated: **R$16,008,872.12** across the full dataset.
- **Credit card is the dominant payment method** — ~76,800 transactions, contributing ~78% of total revenue; Boleto is the second most common at ~18%.
- Monthly revenue shows a strong upward trend from 2017 into 2018, useful for finance teams planning seasonal budgets.

### Product Analytics
- A small number of products generate a disproportionate share of revenue within each category — useful for inventory and marketing prioritization.
- Certain categories carry meaningfully higher average selling prices, indicating a premium-vs-volume split worth different pricing/marketing strategies.
- Revenue is concentrated among a small subset of top sellers, useful for vendor relationship prioritization.

### Customer Analytics
- Out of ~96,000 unique customers, **only a small fraction placed more than one order** — retention, not acquisition, is the biggest growth lever.
- Customer value segmentation shows most customers fall into the low-spend tier, while a small high-value segment contributes disproportionately to revenue.
- **RFM segmentation** identifies a top "555" segment (recent, frequent, high-spending) as the highest-priority group for retention investment.

### Order & Business Performance
- **97% of orders were successfully delivered**, indicating a reliable fulfillment process; under 1% were cancelled.
- Average delivery time is ~12 days; **~8% of orders arrive later than the estimated delivery date**.
- **São Paulo (SP)** is the largest single market by order volume, with Rio de Janeiro and Minas Gerais next.
- Delivery performance varies significantly by state — fastest in São Paulo, slowest in more remote states — highlighting regional logistics opportunities.

## Query Bank Summary

| Domain | Basic | Intermediate | Advanced | Total |
|---|---|---|---|---|
| Finance | 2 | 2 | 2 | 6 |
| Product Analytics | 2 | 3 | 2 | 7 |
| Customer Analytics | 2 | 2 | 1 | 5 |
| Order & Business Performance | 1 | 7 | 3 | 11 |
| **Total** | **7** | **14** | **8** | **29** |

### SQL Techniques Used

| File | Techniques |
|---|---|
| `01_Finance.sql` | Aggregation, Joins, CTEs, percent-of-total window calculation |
| `02_Product_Analytics.sql` | Joins across 3–4 tables, `HAVING`, `RANK() OVER (PARTITION BY ...)` |
| `03_Customer_Analytics.sql` | CTEs, `CASE`-based segmentation, `NTILE()` for RFM quintile scoring |
| `04_Order_Analytics.sql` | `DATEDIFF()`, `SUM() OVER()` for percentage distribution, regional grouping |
| `05_Business_Performance_Analytics.sql` | CTEs, `RANK()`, `SUM() OVER()` for revenue share, multi-table joins |

## Getting Started

1. Clone the repo
2. Open SSMS and create a new database
3. Run the schema script in [`Schema/`](Schema/) to create all 7 tables
4. Import the CSVs from [`Dataset/`](Dataset/) into their matching tables (see import order/notes if using foreign keys)
5. Run each file in [`Queries/`](Queries/) in order — `01_Finance.sql` through `05_Business_Performance_Analytics.sql`
6. Refer to the Key Stakeholder Insights above alongside each query's inline business insight comment

## Author

**Shreya Bajpai**
Aspiring Data Analyst | SQL | Python | Power BI
