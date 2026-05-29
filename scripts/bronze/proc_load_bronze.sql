

/* ============================================================
   STORED PROCEDURE: Load Bronze Layer(source= Bronze)
   ============================================================

   PURPOSE:
   --------
   This stored procedure loads raw CSV data files into the 
   Bronze Schema from external CSV files through BULK INSERT.

   The procedure performs the following operations:
   1. Truncates existing data from bronze tables
   2. Loads fresh data from CSV files
   3. Tracks load duration for each table
   4. Tracks total batch execution time
   5. Implements TRY...CATCH error handling

   LAYER:
   ------
   Bronze Layer (Raw Data Layer)

   ============================================================ */

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    /* ========================================================
       DECLARE VARIABLES FOR LOAD TRACKING
       ======================================================== */

    DECLARE 
        @start_time DATETIME,         -- Stores start time of each table load
        @end_time DATETIME,           -- Stores end time of each table load
        @batch_start_time DATETIME,   -- Stores overall procedure start time
        @batch_end_time DATETIME;     -- Stores overall procedure end time

    BEGIN TRY

        /* ====================================================
           START OF BATCH EXECUTION
           ==================================================== */

        SET @batch_start_time = GETDATE();

        PRINT '===========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '============================================';

        /* ====================================================
           CRM TABLES LOADING SECTION
           ==================================================== */

        PRINT '------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------';

        /* ====================================================
           LOAD CRM CUSTOMER INFORMATION TABLE
           ==================================================== */

        SET @start_time = GETDATE();

        -- Remove existing records before inserting fresh data
        PRINT '>> Truncating Table: bronze.crm_cust_info';

        TRUNCATE TABLE bronze.crm_cust_info;

        -- Insert CSV data into CRM Customer Info table
        PRINT '>> Inserting Data into: bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Sapna\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH
        (
            FIRSTROW = 2,             -- Skip header row
            FIELDTERMINATOR = ',',    -- CSV delimiter
            TABLOCK                   -- Apply table-level lock for faster load
        );

        SET @end_time = GETDATE();

        -- Display load duration
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)+ ' seconds';

        PRINT '------------------------------------------';

        /* ====================================================
           LOAD CRM PRODUCT INFORMATION TABLE
           ==================================================== */

        SET @start_time = GETDATE();

        -- Remove existing records
        PRINT '>> Truncating Table: bronze.crm_prd_info';

        TRUNCATE TABLE bronze.crm_prd_info;

        -- Insert CSV data into Product Info table
        PRINT '>> Inserting Data into: bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Sapna\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        -- Display load duration
        PRINT '>> Load Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '------------------------------------------';

        /* ====================================================
           LOAD CRM SALES DETAILS TABLE
           ==================================================== */

        SET @start_time = GETDATE();

        -- Remove existing records
        PRINT '>> Truncating Table: bronze.crm_sales_details';

        TRUNCATE TABLE bronze.crm_sales_details;

        -- Insert sales details CSV data
        PRINT '>> Inserting Data into: bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Sapna\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        -- Display load duration
        PRINT '>> Load Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)  + ' seconds';

        PRINT '------------------------------------------';

        /* ====================================================
           LOAD ERP CUSTOMER TABLE
           ==================================================== */

        SET @start_time = GETDATE();

        -- Remove existing ERP customer data
        PRINT '>> Truncating Table: bronze.erp_cust_az12';

        TRUNCATE TABLE bronze.erp_cust_az12;

        -- Insert ERP customer CSV data
        PRINT '>> Inserting Data into: bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\Sapna\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        -- Display load duration
        PRINT '>> Load Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '------------------------------------------';

        /* ====================================================
           LOAD ERP LOCATION TABLE
           ==================================================== */

        SET @start_time = GETDATE();

        -- Remove existing ERP location data
        PRINT '>> Truncating Table: bronze.erp_loc_ac101';

        TRUNCATE TABLE bronze.erp_loc_ac101;

        -- Insert ERP location CSV data
        PRINT '>> Inserting Data into: bronze.erp_loc_ac101';

        BULK INSERT bronze.erp_loc_ac101
        FROM 'C:\Users\Sapna\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        -- Display load duration
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)+ ' seconds';

        PRINT '------------------------------------------';

        /* ====================================================
           LOAD ERP PRODUCT CATEGORY TABLE
           ==================================================== */

        SET @start_time = GETDATE();

        -- Remove existing ERP product category data
        PRINT '>> Truncating Table : bronze.erp_px_cat_g1v2';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        -- Insert ERP product category CSV data
        PRINT '>> Inserting Data into: bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\Sapna\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        -- Display load duration
        PRINT '>> Load Duration: '+ CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)+ ' seconds';

        PRINT '------------------------------------------';

        /* ====================================================
           END OF BATCH EXECUTION
           ==================================================== */

        SET @batch_end_time = GETDATE();

        PRINT '==========================================';
        PRINT 'Loading Bronze Layer is completed';

        -- Display total execution duration
  PRINT '-Total Load Duration: '+ CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)+ ' seconds';

        PRINT '==========================================';

    END TRY

    /* ========================================================
       ERROR HANDLING SECTION
       ======================================================== */

    BEGIN CATCH

        PRINT '==========================================';
        PRINT 'Error Occured during Loading Bronze Layer';

        -- Display actual SQL error message
        PRINT 'Error Message: ' + ERROR_MESSAGE();

        -- Display SQL error number
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);

        -- Display SQL error state
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);

        PRINT '==========================================';

    END CATCH

END;
