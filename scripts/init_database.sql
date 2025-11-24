/* ====================================================================================================
    DATA WAREHOUSE INITIAL SETUP SCRIPT
    -----------------------------------------------------------------------------------------------
    Project:        Enterprise Sales Analytics – Data Warehouse Build
    Environment:    PostgreSQL
    Author:         <Geet Pandey>
    Created On:     <23/11/2025>

    Description:
        This script initializes the complete Data Warehouse environment by:
        • Creating the required schema (gold)
        • Dropping any existing dimension and fact tables
        • Recreating clean dimensional model structures:
              - gold.dim_customers
              - gold.dim_products
              - gold.fact_sales
        • Loading data into these tables from CSV sources using the COPY command

    Important Notes:
        • Ensure that the database "datawarehouseanalytics" is created and selected before running.
        • Update COPY file paths to match your local machine.
        • This script will TRUNCATE existing tables — all previous data in these tables will be erased.
        • CSV files must follow the correct delimiter and header structure.

    Purpose:
        This forms the foundation of a star-schema Data Warehouse used for:
            - Sales performance analysis
            - Customer segmentation & analytics
            - Product performance monitoring
            - Dashboarding (Tableau/Power BI)
            - Advanced SQL analytical queries & reporting

    WARNING:
        Running this script will delete and recreate all DW tables in schema 'gold'.
        Ensure you have backups if needed.

==================================================================================================== */



-- DROP & CREATE DATABASE
DROP DATABASE IF EXISTS datawarehouseanalytics;
CREATE DATABASE datawarehouseanalytics;

-- CONNECT TO NEW DB
\c datawarehouseanalytics;

-- CREATE SCHEMA
CREATE SCHEMA IF NOT EXISTS gold;

-- DROP TABLES IF THEY ALREADY EXIST
DROP TABLE IF EXISTS gold.fact_sales;
DROP TABLE IF EXISTS gold.dim_products;
DROP TABLE IF EXISTS gold.dim_customers;

-- CREATE TABLES
CREATE TABLE gold.dim_customers (
    customer_key     INT,
    customer_id      INT,
    customer_number  VARCHAR(50),
    first_name       VARCHAR(50),
    last_name        VARCHAR(50),
    country          VARCHAR(50),
    marital_status   VARCHAR(50),
    gender           VARCHAR(50),
    birthdate        DATE,
    create_date      DATE
);

CREATE TABLE gold.dim_products (
    product_key     INT,
    product_id      INT,
    product_number  VARCHAR(50),
    product_name    VARCHAR(50),
    category_id     VARCHAR(50),
    category        VARCHAR(50),
    subcategory     VARCHAR(50),
    maintenance     VARCHAR(50),
    cost            INT,
    product_line    VARCHAR(50),
    start_date      DATE
);

CREATE TABLE gold.fact_sales (
    order_number   VARCHAR(50),
    product_key    INT,
    customer_key   INT,
    order_date     DATE,
    shipping_date  DATE,
    due_date       DATE,
    sales_amount   INT,
    quantity       SMALLINT,
    price          INT
);

-- LOAD DATA (with corrected paths)
TRUNCATE gold.dim_customers;
COPY gold.dim_customers
FROM 'E:/data/1bcf8e7ed7fc44fba0185e565c46f982/sql-data-analytics-project/datasets/csv-files/gold.dim_customers.csv'
DELIMITER ','
CSV HEADER;

TRUNCATE gold.dim_products;
COPY gold.dim_products
FROM 'E:/data/1bcf8e7ed7fc44fba0185e565c46f982/sql-data-analytics-project/datasets/csv-files/gold.dim_products.csv'
DELIMITER ','
CSV HEADER;

TRUNCATE gold.fact_sales;
COPY gold.fact_sales
FROM 'E:/data/1bcf8e7ed7fc44fba0185e565c46f982/sql-data-analytics-project/datasets/csv-files/gold.fact_sales.csv'
DELIMITER ','
CSV HEADER;
