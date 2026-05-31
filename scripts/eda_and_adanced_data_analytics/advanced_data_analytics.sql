/* 
===============================================================================
📊 SALES ANALYTICS – GOLD LAYER REPORTING QUERIES
===============================================================================

PROJECT OVERVIEW:
-----------------
This script contains advanced analytical SQL queries built on the Gold Layer 
of a data warehouse.

The goal of this analysis is to transform cleaned and modeled data into 
business insights that support decision-making.

These queries focus on:

✔ Sales performance trends over time
✔ Customer activity and engagement
✔ Product-level performance analysis
✔ Category contribution to revenue
✔ Pricing segmentation insights
✔ Advanced analytics using window functions

TECHNIQUES USED:
----------------
✔ Aggregations (SUM, COUNT, AVG)
✔ Window Functions (LAG, OVER, PARTITION BY)
✔ Time-based analysis (YEAR, MONTH, DATETRUNC)
✔ Common Table Expressions (CTEs)
✔ Business segmentation logic (CASE statements)

===============================================================================
*/


-- =============================================================================
-- 1. SALES PERFORMANCE OVER TIME (MONTHLY TREND)
-- =============================================================================
-- Purpose:
-- Analyze monthly sales performance to identify growth patterns, seasonality,
-- and customer purchasing behavior over time.

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;


-- =============================================================================
-- 2. RUNNING TOTAL & MOVING AVERAGE ANALYSIS
-- =============================================================================
-- Purpose:
-- Track sales accumulation over time and smooth price trends using averages.

SELECT 
    order_date,
    total_sales,

    -- Cumulative sales to measure business growth over time
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,

    -- Moving average to observe pricing stability trends
    AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg_price

FROM (
    SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(sls_price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t;


-- =============================================================================
-- 3. YEARLY PRODUCT PERFORMANCE ANALYSIS
-- =============================================================================
-- Purpose:
-- Evaluate how each product performs over time by comparing yearly sales
-- against historical averages and identifying growth trends.

WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)

SELECT
    order_year,
    product_name,
    current_sales,

    -- Average performance of product across years
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,

    -- Difference from historical average
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_from_avg,

    -- Performance classification
    CASE 
        WHEN current_sales > AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Above Average'
        WHEN current_sales < AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Below Average'
        ELSE 'Stable'
    END AS performance_status,

    -- Previous year comparison
    LAG(current_sales) OVER (
        PARTITION BY product_name 
        ORDER BY order_year
    ) AS previous_year_sales,

    -- Year-over-year change
    current_sales - LAG(current_sales) OVER (
        PARTITION BY product_name 
        ORDER BY order_year
    ) AS yoy_difference,

    -- Growth direction
    CASE 
        WHEN current_sales > LAG(current_sales) OVER (
            PARTITION BY product_name ORDER BY order_year
        ) THEN 'Increase'
        WHEN current_sales < LAG(current_sales) OVER (
            PARTITION BY product_name ORDER BY order_year
        ) THEN 'Decrease'
        ELSE 'No Change'
    END AS yoy_trend
FROM yearly_product_sales
ORDER BY product_name, order_year;


-- =============================================================================
-- 4. CATEGORY CONTRIBUTION TO TOTAL SALES
-- =============================================================================
-- Purpose:
-- Understand how each product category contributes to total revenue.

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.category
)

SELECT
    category,
    total_sales,

    -- Total revenue across all categories
    SUM(total_sales) OVER () AS overall_sales,

    -- Percentage contribution of each category
    CONCAT(
        ROUND(total_sales * 100.0 / SUM(total_sales) OVER (), 2),
        '%'
    ) AS sales_contribution
FROM category_sales
ORDER BY total_sales DESC;


-- =============================================================================
-- 5. PRODUCT SEGMENTATION BY COST RANGE
-- =============================================================================
-- Purpose:
-- Group products into pricing segments to understand product distribution.

WITH product_segments AS (
    SELECT 
        product_key,
        product_name,
        cost,

        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100–500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500–1000'
            ELSE 'Above 1000'
        END AS cost_segment
    FROM gold.dim_products
)

SELECT 
    cost_segment,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_segment
ORDER BY total_products DESC;