/*
===============================================================================
Exploratory Data Analysis (EDA) - Gold Layer Sales Data Warehouse
===============================================================================

Overview:
This script performs Exploratory Data Analysis (EDA) on the Gold Layer of the
sales data warehouse. It is designed to explore, validate, and understand the
structure, distribution, and quality of the data before any advanced analytics
or reporting is applied.

Purpose:
The primary goal of this EDA is to generate a clear understanding of the dataset,
including customers, products, and sales behavior, using descriptive SQL queries.

Key Areas Covered:
- Customer analysis (geography, demographics, and activity)
- Product structure (category, subcategory, and product distribution)
- Sales performance (revenue, quantity, and order metrics)
- Time coverage and data range analysis
- Core KPI generation for business understanding
- Basic segmentation of customers and products

Important Note:
This layer is  descriptive in nature. It does not include advanced analytics
such as forecasting, cohort analysis, machine learning, or statistical modeling.
It serves as the foundation for deeper analytical layers.

===============================================================================
*/


-- =========================================
-- Customer Geography: List unique countries customers belong to
-- =========================================
SELECT DISTINCT 
    country 
FROM gold.dim_customers;
-- =========================================
-- Customer Demography:-- Retrieve unique gender Composition
-- =========================================

SELECT DISTINCT 
    Gender
FROM gold.dim_customers;


-- =========================================
-- Product Hierarchy: Explore category → subcategory → product structure
-- =========================================
SELECT DISTINCT 
    category,
    subcategory,
    product_name 
FROM gold.dim_products
ORDER BY 1,2,3;


-- =========================================
-- Sales Time Range: Identify data coverage period
-- =========================================
-- Helps understand how many years of sales data are available
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;


-- =========================================
-- Customer Age Range: Identify youngest and oldest customers
-- =========================================
-- Age is approximated using year difference
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;


-- =========================================
-- Core KPIs: Basic business performance metrics
-- =========================================
SELECT SUM(sales_amount) AS Total_Sales FROM gold.fact_sales;     -- Total revenue
SELECT SUM(quantity) AS Total_Quantity FROM gold.fact_sales;      -- Total units sold
SELECT AVG(sls_price) AS Avg_Price FROM gold.fact_sales;              -- Average selling price
SELECT COUNT(DISTINCT order_number) AS Total_Orders FROM gold.fact_sales;-- Total Orders


-- Product Counts: Total vs unique product names
SELECT COUNT(product_key) AS total_products FROM gold.dim_products;
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products;

-- =========================================
-- Customer Counts
-- =========================================
SELECT COUNT(customer_key) AS Total_customers FROM gold.dim_customers;

-- Customers who actually placed orders
SELECT COUNT(DISTINCT customer_key) AS Total_customers FROM gold.fact_sales;


-- =========================================
-- KPI Summary Report (Single Result Set)
-- =========================================
-- Combines multiple KPIs into one output using UNION ALL
SELECT 'Total_Sales' AS Measure_Name, SUM(sales_amount) AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total_Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Avg_Price', AVG(sls_price) FROM gold.fact_sales
UNION ALL
SELECT 'Total_no_Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total_no_products', COUNT(product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total_no_Customers', COUNT(customer_key) FROM gold.dim_customers;


-- =========================================
-- Customer Distribution by Country
-- =========================================
SELECT
    Country,
    COUNT(Customer_key) AS Total_Customers
FROM gold.dim_customers
GROUP BY Country
ORDER BY Total_Customers DESC;


-- =========================================
-- Customer Distribution by Gender
-- =========================================
SELECT
    Gender,
    COUNT(Customer_key) AS Total_Customers
FROM gold.dim_customers
GROUP BY Gender
ORDER BY Total_Customers DESC;


-- =========================================
-- Product Distribution by Category
-- =========================================
SELECT
    Category,
    COUNT(product_key) AS Total_Products
FROM gold.dim_products
GROUP BY Category
ORDER BY Total_Products DESC;


-- =========================================
-- Average Product Cost by Category
-- =========================================
SELECT
    Category,
    AVG(Cost) AS Avg_Cost
FROM gold.dim_products
GROUP BY Category
ORDER BY Avg_Cost DESC;


-- =========================================
-- Revenue by Product Category
-- =========================================
-- LEFT JOIN ensures all sales are included even if product mapping is missing
SELECT
    p.Category,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s 
LEFT JOIN gold.dim_products AS p
    ON p.product_key = s.product_key
GROUP BY p.Category
ORDER BY Total_Revenue DESC;


-- =========================================
-- Revenue by Customer
-- =========================================
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = s.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY Total_Revenue DESC;


-- =========================================
-- Quantity Sold by Country
-- =========================================
SELECT
    c.Country,
    SUM(s.quantity) AS Total_quantity
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = s.customer_key
GROUP BY c.Country
ORDER BY Total_quantity DESC;


-- =========================================
-- Top 5 Products by Revenue
-- =========================================
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue DESC;


-- =========================================
-- Top Products using Ranking (Flexible approach)
-- =========================================
-- ROW_NUMBER allows dynamic ranking instead of fixed TOP
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(s.sales_amount) AS Total_Revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p
        ON p.product_key = s.product_key
    GROUP BY p.product_name
) t
WHERE rank_products <= 5;


-- =========================================
-- Top 10 Customers by Revenue
-- =========================================
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = s.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY Total_Revenue DESC;


-- =========================================
-- Bottom 5 Products by Revenue (Worst Performers)
-- =========================================
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS Total_Revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
    ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue ASC;


-- =========================================
-- Customers with Lowest Order Activity
-- =========================================
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT s.order_number) AS Total_Order
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = s.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY Total_Order ASC;


