-- ============================
-- SAMPLE ECOMMERCE DATASET
-- Tables: EC_CUSTOMERS, EC_ORDERS, EC_PRODUCTS
-- View: VW_EC_ORDER_DETAILS
-- ============================

USE ROLE ACCOUNTADMIN;          -- or your role
USE WAREHOUSE COMPUTE_WH;       -- or your warehouse

CREATE DATABASE IF NOT EXISTS EC_ANALYTICS;
CREATE SCHEMA IF NOT EXISTS EC_ANALYTICS.PUBLIC;

USE DATABASE EC_ANALYTICS;
USE SCHEMA PUBLIC;

-- 1) Create tables
CREATE OR REPLACE TABLE EC_CUSTOMERS (
  CUSTOMER_ID     NUMBER,
  FIRST_NAME      STRING,
  LAST_NAME       STRING,
  EMAIL           STRING,
  CITY            STRING,
  STATE           STRING,
  SIGNUP_DATE     DATE
);

CREATE OR REPLACE TABLE EC_PRODUCTS (
  PRODUCT_ID      NUMBER,
  PRODUCT_NAME    STRING,
  CATEGORY        STRING,
  UNIT_COST       NUMBER(10,2),
  UNIT_PRICE      NUMBER(10,2)
);

CREATE OR REPLACE TABLE EC_ORDERS (
  ORDER_ID        NUMBER,
  ORDER_DATE      DATE,
  CUSTOMER_ID     NUMBER,
  PRODUCT_ID      NUMBER,
  QUANTITY        NUMBER,
  DISCOUNT_PCT    NUMBER(5,2),
  CHANNEL         STRING,
  STATUS          STRING
);

-- 2) Load data (2 options)

-- OPTION A: If you used Snowsight "Load Data" wizard, Snowflake already loaded the CSVs.
-- No COPY needed.

-- OPTION B: If you want COPY INTO with a stage:
-- (Create file format + stage, then upload files to stage using Snowsight or SnowSQL)

CREATE OR REPLACE FILE FORMAT FF_CSV
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  EMPTY_FIELD_AS_NULL = TRUE
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

CREATE OR REPLACE STAGE STG_EC_CSV
  FILE_FORMAT = FF_CSV;

-- After uploading files into STG_EC_CSV, run:
-- COPY INTO EC_CUSTOMERS FROM @STG_EC_CSV/ec_customers.csv;
-- COPY INTO EC_PRODUCTS  FROM @STG_EC_CSV/ec_products.csv;
-- COPY INTO EC_ORDERS    FROM @STG_EC_CSV/ec_orders.csv;

-- 3) Create a joined view for Sigma
CREATE OR REPLACE VIEW VW_EC_ORDER_DETAILS AS
SELECT
  o.ORDER_ID,
  o.ORDER_DATE,
  o.CUSTOMER_ID,
  o.PRODUCT_ID,
  o.QUANTITY,
  o.DISCOUNT_PCT,
  o.CHANNEL,
  o.STATUS,
  p.PRODUCT_NAME,
  p.CATEGORY,
  p.UNIT_COST,
  p.UNIT_PRICE,

  -- Calculations
  (o.QUANTITY * p.UNIT_PRICE) * (1 - COALESCE(o.DISCOUNT_PCT,0)/100) AS REVENUE,
  (o.QUANTITY * p.UNIT_COST) AS TOTAL_COST,
  ((o.QUANTITY * p.UNIT_PRICE) * (1 - COALESCE(o.DISCOUNT_PCT,0)/100)) - (o.QUANTITY * p.UNIT_COST) AS PROFIT,

  CASE
    WHEN ((o.QUANTITY * p.UNIT_PRICE) * (1 - COALESCE(o.DISCOUNT_PCT,0)/100)) = 0 THEN NULL
    ELSE (
      (((o.QUANTITY * p.UNIT_PRICE) * (1 - COALESCE(o.DISCOUNT_PCT,0)/100)) - (o.QUANTITY * p.UNIT_COST))
      /
      ((o.QUANTITY * p.UNIT_PRICE) * (1 - COALESCE(o.DISCOUNT_PCT,0)/100))
    )
  END AS MARGIN_PCT
FROM EC_ORDERS o
JOIN EC_PRODUCTS p ON o.PRODUCT_ID = p.PRODUCT_ID;

-- Quick validation
SELECT * FROM VW_EC_ORDER_DETAILS LIMIT 10;
