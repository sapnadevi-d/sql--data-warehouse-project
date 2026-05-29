/* ============================================================
   DDL Script: Create Bronze Layer Tables
   ============================================================

   PURPOSE:
   --------
   This script creates all Bronze Layer tables used for
   raw data ingestion in the DataWarehouse database.

   PROCESS:
   --------
   1. Checks whether the table already exists
   2. Drops the existing table
   3. Recreates the table structure

   ============================================================ */

USE DataWarehouse;


/* ---------------------------------------------------------
   TABLE: bronze.crm_cust_info
   Customer master data from CRM source system
  --------------------------------------------------------*/

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info
(
    cst_id INT,                        -- Customer ID
    cst_key NVARCHAR(50),              -- Customer business key
    cst_firstname NVARCHAR(50),        -- First name
    cst_lastname NVARCHAR(50),         -- Last name
    cst_marital_status NVARCHAR(50),   -- Marital status
    cst_gndr NVARCHAR(50),             -- Gender
    cst_create_date DATE               -- Record creation date
);





/* -----------------------------------------------------------
   TABLE: bronze.crm_prd_info
   Product master data from CRM source system
  -------------------------------------------------------------- */

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info
(
    prd_id INT,                    -- Product ID
    prd_key NVARCHAR(50),          -- Product business key
    prd_nm NVARCHAR(50),           -- Product name
    prd_cost INT,                  -- Product cost
    prd_line NVARCHAR(50),         -- Product line
    prd_start_dt DATETIME,         -- Product start date
    prd_end_dt DATETIME            -- Product end date
);





/* -----------------------------------------------------------
   TABLE: bronze.crm_sales_details
   Sales transaction data from CRM source system
  ------------------------------------------------------------- */

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details
(
    sls_ord_num NVARCHAR(50),      -- Sales order number
    sls_prd_key NVARCHAR(50),      -- Product key
    sls_cust_id INT,               -- Customer ID
    sls_order_dt INT,              -- Order date
    sls_ship_dt INT,               -- Shipping date
    sls_ship_sales INT,            -- Sales amount
    sls_due_dt INT,                -- Due date
    sls_quantity INT,              -- Quantity sold
    sls_price INT                  -- Product price
);





/* -------------------------------------------------------------
   TABLE: bronze.erp_cust_az12
   ERP customer demographic data
  ----------------------------------------------------------------*/

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12
(
    cid NVARCHAR(50),              -- Customer ID
    bdate DATE,                    -- Birth date
    gen NVARCHAR(50)               -- Gender
);


/* -------------------------------------------------------------
   TABLE: bronze.erp_loc_ac101
   ERP customer location data
  ----------------------------------------------------------------*/

IF OBJECT_ID('bronze.erp_loc_ac101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_ac101;

CREATE TABLE bronze.erp_loc_ac101
(
    cid NVARCHAR(50),              -- Customer ID
    cntry NVARCHAR(50)             -- Country
);


/* ----------------------------------------------------------------
   TABLE: bronze.erp_px_cat_g1v2
   ERP product category data
   ---------------------------------------------------------------- */

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2
(
    id NVARCHAR(50),               -- Product category ID
    cat NVARCHAR(50),              -- Main category
    subcat NVARCHAR(50),           -- Sub category
    maintenance NVARCHAR(50)       -- Maintenance type
);
