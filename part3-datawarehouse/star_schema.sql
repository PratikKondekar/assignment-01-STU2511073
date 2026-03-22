-- ============================================================
-- Task 3.1 — Star Schema Design
-- File: part3-datawarehouse/star_schema.sql
-- Dataset: retail_transactions.csv
-- Data issues cleaned:
--   1. Inconsistent date formats (29/08/2023, 20-02-2023, 2023-02-05) → YYYY-MM-DD
--   2. Inconsistent category casing (electronics) → Electronics
--   3. Inconsistent category names (Grocery) → Groceries
--   4. NULL store_city values → filled from known store names
-- ============================================================

CREATE DATABASE IF NOT EXISTS retail_dw;
USE retail_dw;

DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;

-- ============================================================
-- DIMENSION TABLE 1: dim_date
-- ============================================================
CREATE TABLE dim_date (
    date_id     INT         NOT NULL,
    full_date   DATE        NOT NULL,
    day         INT         NOT NULL,
    month       INT         NOT NULL,
    month_name  VARCHAR(20) NOT NULL,
    quarter     INT         NOT NULL,
    year        INT         NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    is_weekend  BOOLEAN     NOT NULL,
    CONSTRAINT pk_dim_date PRIMARY KEY (date_id)
);

INSERT INTO dim_date VALUES (20230115, '2023-01-15', 15, 1,  'January',  1, 2023, 'Sunday',    TRUE);
INSERT INTO dim_date VALUES (20230205, '2023-02-05', 5,  2,  'February', 1, 2023, 'Sunday',    TRUE);
INSERT INTO dim_date VALUES (20230208, '2023-02-08', 8,  2,  'February', 1, 2023, 'Wednesday', FALSE);
INSERT INTO dim_date VALUES (20230220, '2023-02-20', 20, 2,  'February', 1, 2023, 'Monday',    FALSE);
INSERT INTO dim_date VALUES (20230331, '2023-03-31', 31, 3,  'March',    1, 2023, 'Friday',    FALSE);
INSERT INTO dim_date VALUES (20230428, '2023-04-28', 28, 4,  'April',    2, 2023, 'Friday',    FALSE);
INSERT INTO dim_date VALUES (20230521, '2023-05-21', 21, 5,  'May',      2, 2023, 'Sunday',    TRUE);
INSERT INTO dim_date VALUES (20230604, '2023-06-04', 4,  6,  'June',     2, 2023, 'Sunday',    TRUE);
INSERT INTO dim_date VALUES (20230801, '2023-08-01', 1,  8,  'August',   3, 2023, 'Tuesday',   FALSE);
INSERT INTO dim_date VALUES (20230809, '2023-08-09', 9,  8,  'August',   3, 2023, 'Wednesday', FALSE);
INSERT INTO dim_date VALUES (20230815, '2023-08-15', 15, 8,  'August',   3, 2023, 'Tuesday',   FALSE);
INSERT INTO dim_date VALUES (20230829, '2023-08-29', 29, 8,  'August',   3, 2023, 'Tuesday',   FALSE);
INSERT INTO dim_date VALUES (20231026, '2023-10-26', 26, 10, 'October',  4, 2023, 'Thursday',  FALSE);
INSERT INTO dim_date VALUES (20231118, '2023-11-18', 18, 11, 'November', 4, 2023, 'Saturday',  TRUE);
INSERT INTO dim_date VALUES (20231208, '2023-12-08', 8,  12, 'December', 4, 2023, 'Friday',    FALSE);
INSERT INTO dim_date VALUES (20231212, '2023-12-12', 12, 12, 'December', 4, 2023, 'Tuesday',   FALSE);


-- ============================================================
-- DIMENSION TABLE 2: dim_store
-- NULL city values cleaned and filled from store name
-- ============================================================
CREATE TABLE dim_store (
    store_id     INT          NOT NULL AUTO_INCREMENT,
    store_name   VARCHAR(100) NOT NULL,
    store_city   VARCHAR(50)  NOT NULL,
    store_region VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_dim_store PRIMARY KEY (store_id)
);

INSERT INTO dim_store (store_name, store_city, store_region) VALUES ('Bangalore MG',   'Bangalore', 'South');
INSERT INTO dim_store (store_name, store_city, store_region) VALUES ('Chennai Anna',   'Chennai',   'South');
INSERT INTO dim_store (store_name, store_city, store_region) VALUES ('Delhi South',    'Delhi',     'North');
INSERT INTO dim_store (store_name, store_city, store_region) VALUES ('Mumbai Central', 'Mumbai',    'West');
INSERT INTO dim_store (store_name, store_city, store_region) VALUES ('Pune FC Road',   'Pune',      'West');


-- ============================================================
-- DIMENSION TABLE 3: dim_product
-- Category cleaned: electronics → Electronics, Grocery → Groceries
-- ============================================================
CREATE TABLE dim_product (
    product_id   INT            NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(100)   NOT NULL,
    category     VARCHAR(50)    NOT NULL,
    unit_price   DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_dim_product PRIMARY KEY (product_id)
);

INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Atta 10kg',  'Groceries',   52464.00);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Biscuits',   'Groceries',   27469.99);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Headphones', 'Electronics', 39854.96);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Jacket',     'Clothing',    30187.24);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Jeans',      'Clothing',     2317.47);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Laptop',     'Electronics', 42343.15);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Milk 1L',    'Groceries',   43374.39);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Oil 1L',     'Groceries',   26474.34);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Phone',      'Electronics', 48703.39);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Pulses 1kg', 'Groceries',   31604.47);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Rice 5kg',   'Groceries',   52195.05);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Saree',      'Clothing',    35451.81);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Smartwatch', 'Electronics', 58851.01);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Speaker',    'Electronics', 49262.78);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('T-Shirt',    'Clothing',    29770.19);
INSERT INTO dim_product (product_name, category, unit_price) VALUES ('Tablet',     'Electronics', 23226.12);


-- ============================================================
-- FACT TABLE: fact_sales
-- Central table with numeric measures
-- Foreign keys to all 3 dimension tables
-- ============================================================
CREATE TABLE fact_sales (
    sale_id        INT           NOT NULL AUTO_INCREMENT,
    transaction_id VARCHAR(20)   NOT NULL,
    date_id        INT           NOT NULL,
    store_id       INT           NOT NULL,
    product_id     INT           NOT NULL,
    customer_id    VARCHAR(20)   NOT NULL,
    units_sold     INT           NOT NULL,
    unit_price     DECIMAL(10,2) NOT NULL,
    total_amount   DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_fact_sales   PRIMARY KEY (sale_id),
    CONSTRAINT fk_fact_date    FOREIGN KEY (date_id)    REFERENCES dim_date    (date_id),
    CONSTRAINT fk_fact_store   FOREIGN KEY (store_id)   REFERENCES dim_store   (store_id),
    CONSTRAINT fk_fact_product FOREIGN KEY (product_id) REFERENCES dim_product (product_id)
);

-- 15 cleaned fact rows (dates standardized, categories fixed)
INSERT INTO fact_sales (transaction_id, date_id,  store_id, product_id, customer_id, units_sold, unit_price,  total_amount) VALUES
('TXN5000', 20230829, 2, 14, 'CUST045', 3,  49262.78,  147788.34),
('TXN5001', 20231212, 2, 16, 'CUST021', 11, 23226.12,  255487.32),
('TXN5002', 20230205, 2,  9, 'CUST019', 20, 48703.39,  974067.80),
('TXN5003', 20230220, 3, 16, 'CUST007', 14, 23226.12,  325165.68),
('TXN5004', 20230115, 2, 13, 'CUST004', 10, 58851.01,  588510.10),
('TXN5005', 20230809, 1,  1, 'CUST027', 12, 52464.00,  629568.00),
('TXN5006', 20230331, 5, 13, 'CUST025', 6,  58851.01,  353106.06),
('TXN5007', 20231026, 5,  5, 'CUST041', 16,  2317.47,   37079.52),
('TXN5008', 20231208, 1,  2, 'CUST030', 9,  27469.99,  247229.91),
('TXN5009', 20230815, 1, 13, 'CUST020', 3,  58851.01,  176553.03),
('TXN5010', 20230604, 2,  4, 'CUST031', 15, 30187.24,  452808.60),
('TXN5011', 20230801, 4,  5, 'CUST045', 13,  2317.47,   30127.11),
('TXN5012', 20230521, 1,  6, 'CUST044', 13, 42343.15,  550461.00),
('TXN5013', 20230428, 4,  7, 'CUST015', 10, 43374.39,  433743.90),
('TXN5014', 20231118, 3,  4, 'CUST042', 5,  30187.24,  150936.20);
