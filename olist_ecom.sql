-- =============================================================================
-- 1. DATABASE SCHEMA SETUP & DATA IMPORT (COPY)
-- =============================================================================

-- Table 1: Customer
CREATE TABLE customer (
    customer_id              VARCHAR(150),
    customer_unique_id       VARCHAR(150),
    customer_zip_code_prefix INT,
    customer_city            VARCHAR(150),
    customer_state           CHAR(10)
);

COPY customer
FROM 'E:\Data Analysis Projects\Project 1\archive\olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Table 2: Geolocation
CREATE TABLE geoloc (
    geolocation_zip_code_prefix NUMERIC,
    geolocation_lat            NUMERIC,
    geolocation_lng            NUMERIC,
    geolocation_city           VARCHAR(100),
    geolocation_state          CHAR(10)
);

COPY geoloc
FROM 'E:\Data Analysis Projects\Project 1\archive\olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Table 3: Order Items
CREATE TABLE order_item (
    order_id            VARCHAR(100),
    order_item_id       INT,
    product_id          VARCHAR(100),
    seller_id           VARCHAR(100),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC,
    freight_value       NUMERIC
);

COPY order_item
FROM 'E:\Data Analysis Projects\Project 1\archive\olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Table 4: Order Payments
CREATE TABLE order_payment (
    order_id             VARCHAR(100),
    payment_sequential   INT,
    payment_type         CHAR(15),
    payment_installments INT,
    payment_value        NUMERIC
);

COPY order_payment
FROM 'E:\Data Analysis Projects\Project 1\archive\olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Table 5: Order Reviews
CREATE TABLE order_review (
    review_id               VARCHAR(100),
    order_id                VARCHAR(100),
    review_score            NUMERIC,
    review_comment_title    VARCHAR(100),
    review_comment_message  VARCHAR(250),
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

COPY order_review
FROM 'E:\Data Analysis Projects\Project 1\archive\olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Table 6: Orders
CREATE TABLE orders (
    order_id                      VARCHAR(100),
    customer_id                   VARCHAR(100),
    order_status                  CHAR(15),
    order_purchase_timestamp      TIMESTAMP,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

COPY orders
FROM 'E:\Data Analysis Projects\Project 1\archive\olist_orders_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Table 7: Product
CREATE TABLE product (
    product_id                 VARCHAR(100),
    product_category_name      VARCHAR(100),
    product_name_lenght        INT,
    product_description_lenght INT,
    product_photos_qty         INT,
    product_weight_g           INT,
    product_length_cm          INT,
    product_height_cm          INT,
    product_width_cm           INT
);

COPY product
FROM 'E:\Data Analysis Projects\Project 1\archive\olist_products_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Table 8: Seller
CREATE TABLE seller (
    seller_id              VARCHAR(100),
    seller_zip_code_prefix INT,
    seller_city            VARCHAR(100),
    seller_state           CHAR(5)
);

COPY seller
FROM 'E:\Data Analysis Projects\Project 1\archive\olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Table 9: Category Name Translation
CREATE TABLE category_name (
    product_category_name         VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

COPY category_name
FROM 'E:\Data Analysis Projects\Project 1\archive\product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');


-- =============================================================================
-- 2. INITIAL DATA VERIFICATION
-- =============================================================================

SELECT * FROM customer LIMIT 10;
SELECT * FROM geoloc LIMIT 10;
SELECT * FROM order_item LIMIT 10;
SELECT * FROM order_payment LIMIT 10;
SELECT * FROM order_review LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM product LIMIT 10;
SELECT * FROM seller LIMIT 10;
SELECT * FROM category_name LIMIT 10;


-- =============================================================================
-- 3. NULL VALUES AUDIT ACROSS TABLES
-- =============================================================================

-- 3.1 Customer Null Check
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(customer_id)              AS null_customer_id,
    COUNT(*) - COUNT(customer_unique_id)       AS null_customer_unique_id,
    COUNT(*) - COUNT(customer_zip_code_prefix) AS null_zip_code,
    COUNT(*) - COUNT(customer_city)            AS null_city,
    COUNT(*) - COUNT(customer_state)           AS null_state
FROM customer;

-- 3.2 Orders Null Check
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id)                      AS null_order_id,
    COUNT(*) - COUNT(customer_id)                   AS null_customer_id,
    COUNT(*) - COUNT(order_status)                  AS null_order_status,
    COUNT(*) - COUNT(order_purchase_timestamp)      AS null_purchase_ts,
    COUNT(*) - COUNT(order_approved_at)             AS null_approved_at,
    COUNT(*) - COUNT(order_delivered_carrier_date)  AS null_carrier_date,
    COUNT(*) - COUNT(order_delivered_customer_date) AS null_customer_date,
    COUNT(*) - COUNT(order_estimated_delivery_date) AS null_estimated_date
FROM orders;

-- 3.3 Order Item Null Check
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id)            AS null_order_id,
    COUNT(*) - COUNT(order_item_id)       AS null_order_item_id,
    COUNT(*) - COUNT(product_id)          AS null_product_id,
    COUNT(*) - COUNT(seller_id)           AS null_seller_id,
    COUNT(*) - COUNT(shipping_limit_date) AS null_shipping_limit_date,
    COUNT(*) - COUNT(price)               AS null_price,
    COUNT(*) - COUNT(freight_value)       AS null_freight_value
FROM order_item;

-- 3.4 Order Payment Null Check
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id)             AS null_order_id,
    COUNT(*) - COUNT(payment_sequential)   AS null_payment_seq,
    COUNT(*) - COUNT(payment_type)         AS null_payment_type,
    COUNT(*) - COUNT(payment_installments) AS null_installments,
    COUNT(*) - COUNT(payment_value)        AS null_payment_value
FROM order_payment;

-- 3.5 Order Review Null Check
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(review_id)               AS null_review_id,
    COUNT(*) - COUNT(order_id)                AS null_order_id,
    COUNT(*) - COUNT(review_score)            AS null_review_score,
    COUNT(*) - COUNT(review_comment_title)    AS null_comment_title,
    COUNT(*) - COUNT(review_comment_message)  AS null_comment_message,
    COUNT(*) - COUNT(review_creation_date)    AS null_creation_date,
    COUNT(*) - COUNT(review_answer_timestamp) AS null_answer_ts
FROM order_review;

-- 3.6 Product Null Check
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(product_id)                 AS null_product_id,
    COUNT(*) - COUNT(product_category_name)      AS null_category_name,
    COUNT(*) - COUNT(product_name_lenght)        AS null_name_length,
    COUNT(*) - COUNT(product_description_lenght) AS null_desc_length,
    COUNT(*) - COUNT(product_photos_qty)         AS null_photos_qty,
    COUNT(*) - COUNT(product_weight_g)           AS null_weight,
    COUNT(*) - COUNT(product_length_cm)          AS null_length,
    COUNT(*) - COUNT(product_height_cm)          AS null_height,
    COUNT(*) - COUNT(product_width_cm)           AS null_width
FROM product;

-- 3.7 Geolocation Null Check
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(geolocation_zip_code_prefix) AS null_zip_code,
    COUNT(*) - COUNT(geolocation_lat)            AS null_lat,
    COUNT(*) - COUNT(geolocation_lng)            AS null_lng,
    COUNT(*) - COUNT(geolocation_city)           AS null_city,
    COUNT(*) - COUNT(geolocation_state)          AS null_state
FROM geoloc;

-- 3.8 Seller Null Check
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(seller_id)              AS null_seller_id,
    COUNT(*) - COUNT(seller_zip_code_prefix) AS null_zip_code,
    COUNT(*) - COUNT(seller_city)            AS null_city,
    COUNT(*) - COUNT(seller_state)           AS null_state
FROM seller;

-- 3.9 Category Name Null Check
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(product_category_name)         AS null_category_name,
    COUNT(*) - COUNT(product_category_name_english) AS null_category_name_english
FROM category_name;


-- =============================================================================
-- 4. DATA CLEANING & TRANSFORMATION
-- =============================================================================

-- 4.1 Impute Missing Timestamps in Orders Table
WITH AvgCarrierDuration AS (
    SELECT AVG(order_delivered_carrier_date - order_approved_at) AS avg_duration
    FROM orders
    WHERE order_delivered_carrier_date IS NOT NULL 
      AND order_approved_at IS NOT NULL
)
UPDATE orders
SET order_delivered_carrier_date = order_approved_at + (SELECT avg_duration FROM AvgCarrierDuration)
WHERE order_delivered_carrier_date IS NULL 
  AND order_approved_at IS NOT NULL;

WITH AvgApprovalDuration AS (
    SELECT AVG(order_approved_at - order_purchase_timestamp) AS avg_duration
    FROM orders
    WHERE order_purchase_timestamp IS NOT NULL 
      AND order_approved_at IS NOT NULL
)
UPDATE orders
SET order_approved_at = order_purchase_timestamp + (SELECT avg_duration FROM AvgApprovalDuration)
WHERE order_approved_at IS NULL 
  AND order_purchase_timestamp IS NOT NULL;

-- 4.2 Product Table Staging & Cleaning
CREATE TABLE prod (LIKE product INCLUDING ALL);

INSERT INTO prod 
SELECT * FROM product;

DELETE FROM prod
WHERE product_category_name IS NULL
  AND product_name_lenght IS NULL
  AND product_description_lenght IS NULL
  AND product_photos_qty IS NULL;

DELETE FROM prod
WHERE product_weight_g IS NULL;

-- 4.3 Order Payment Cleaning
DELETE FROM order_payment
WHERE payment_type = 'not_defined';

-- 4.4 Order Review Missing Value Imputation
UPDATE order_review 
SET review_comment_title = 'No Comment'
WHERE review_comment_title IS NULL;

UPDATE order_review 
SET review_comment_message = 'No Comment'
WHERE review_comment_message IS NULL;


-- =============================================================================
-- 5. ANALYTICAL QUERIES & CTEs
-- =============================================================================

WITH OrderProductDetails AS (
    SELECT 
        o.order_id,
        o.customer_id,
        o.order_status,
        oi.product_id,
        p.product_category_name,
        c.product_category_name_english
    FROM orders o
    JOIN order_item oi ON o.order_id = oi.order_id
    JOIN prod p ON oi.product_id = p.product_id
    LEFT JOIN category_name c ON p.product_category_name = c.product_category_name
)
SELECT 
    order_id,
    customer_id,
    product_id,
    product_category_name,
    product_category_name_english
FROM OrderProductDetails
WHERE product_category_name_english IS NULL;