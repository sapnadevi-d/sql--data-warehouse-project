# 🏢 SQL Data Warehouse Project | SQL Server
 
> Developed as part of a guided SQL Data Warehouse course by Bara Saklani, providing hands-on experience in ETL development, data modeling, and analytical data warehousing.

---



## 📖 Project Overview
This project demonstrates the end-to-end development of a modern Data Warehouse using SQL Server. The solution consolidates data from multiple source systems, applies data quality and transformation processes, and delivers a business-ready analytical model for reporting and decision-making.

The project follows the Medallion Architecture (Bronze, Silver, and Gold layers) to ensure scalability, maintainability, and data quality throughout the pipeline. 


---


## 🎯 Business Problem

Business data is often distributed across multiple operational systems, making reporting and analysis difficult.

This project solves that challenge by centralizing CRM and ERP data into a unified SQL Server Data Warehouse that supports consistent reporting and business analytics.

---

## 🏗️ Data Architecture

This project follows the **Medallion Architecture** design pattern consisting of Bronze, Silver, and Gold layers.

![Data Architecture](docs/data_architecture.png)

### Bronze Layer – Raw Data

The Bronze Layer serves as the landing zone for source data.

**Responsibilities**

- Store raw data in its original format.
- Load source CSV files into SQL Server.
- Preserve source-system data for traceability.
- Perform minimal processing.

### Silver Layer – Cleansed & Standardized Data

The Silver Layer transforms raw data into clean and reliable datasets.

**Responsibilities**

- Data cleansing
- Data standardization
- Data normalization
- Duplicate removal
- Data validation
- Business rule implementation

### Gold Layer – Business-Ready Data

The Gold Layer contains curated datasets optimized for analytics and reporting.

**Responsibilities**

- Dimensional modeling
- Fact table creation
- Dimension table creation
- Business metric generation
- Reporting optimization

---

## 📂 Data Sources

The data warehouse integrates data from two business systems.

### CRM System

Customer-related data including:

- Customer information
- Customer demographics
- Customer master records

### ERP System

Operational and sales-related data including:

- Product information
- Sales transactions
- Business operations data

### Source Format

- CSV Files

---

## 🔄 ETL Pipeline

The project implements a complete Extract, Transform, and Load (ETL) workflow.
![ETL Workflow ](docs/data_flow.png)

### Extract

- Import source CSV files.
- Load raw data into Bronze tables.
- Validate source file availability.

### Transform

- Clean inconsistent values.
- Standardize formats.
- Resolve data quality issues.
- Remove duplicate records.
- Apply business transformation rules.
- Integrate CRM and ERP datasets.

### Load

- Populate Silver tables.
- Build Gold analytical tables.
- Create Fact and Dimension tables.
- Prepare data for reporting and analytics.

---

## 📊 Data Model

The Gold Layer follows a **Star Schema** design optimized for analytical workloads.
![Star Schema](docs/Data_Model.png)

### Fact Table

#### Fact Sales

Stores transactional sales measures including:

- Sales Amount
- Quantity Sold
- Order Details

### Dimension Tables

#### Dim Customer

Stores customer-related descriptive attributes.

#### Dim Product

Stores product-related descriptive attributes.

#### Dim Date

Stores calendar and date-related attributes.


### Benefits

- Improved query performance
- Simplified reporting
- Faster analytical queries
- Enhanced business insights

---


## ✅ Data Quality Checks

The project includes multiple validation checks to ensure data integrity and consistency.

### Implemented Checks

- Primary Key Validation
- Duplicate Detection
- Null Value Validation
- Referential Integrity Checks
- Fact-to-Dimension Relationship Validation
- Data Consistency Verification

---

## 🛠️ Technologies Used

| Category | Technology |
|-----------|------------|
| Database | SQL Server |
| Query Language | T-SQL |
| Development Tool | SQL Server Management Studio (SSMS) |
| Data Source | CSV Files |
| Architecture | Medallion Architecture |
| Data Modeling | Star Schema |
| ETL Development | SQL-Based ETL Pipelines |

---

## 🚀 How to Run This Project

### 1. Create the Database

```text
Execute the script init.database
```

### 2. Create Bronze Layer Objects

Execute all scripts located in:

```text
scripts/bronze/
```

### 3. Load Bronze Data

Run the Bronze ETL procedures to ingest source CSV files.

### 4. Create Silver Layer Objects

Execute all scripts located in:

```text
scripts/silver/
```

### 5. Load Silver Data

Run the Silver ETL procedures to cleanse and standardize the data.

### 6. Create Gold Layer Objects

Execute all scripts located in:

```text
scripts/gold/
```

### 7. Validate Data Quality

Run:

```text
quality_checks.sql
```

### 8. Query Gold Layer

Use Gold Layer views and tables for reporting and analytics.



---

## 🎯 Key Skills Demonstrated

- ETL pipeline development using SQL Server and T-SQL
- Data cleansing, validation, and transformation
- Medallion Architecture implementation (Bronze, Silver, Gold)
- Star Schema dimensional modeling
- Fact and Dimension table design
- Data quality and integrity validation
- Analytical data warehouse development



---

## 👨‍💻 Author

**Sapna Devi**


