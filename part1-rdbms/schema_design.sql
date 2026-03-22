-- ============================================================
-- Task 1.2 — Schema Design (3NF)
-- File: part1-rdbms/schema_design.sql
-- Description: Normalized schema derived from orders_flat.csv
-- ============================================================

-- Drop tables in reverse dependency order (for re-runs)
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sales_reps;

-- ============================================================
-- TABLE 1: sales_reps
-- Stores sales representative details independently
-- Fixes INSERT anomaly: reps can now exist without any order
-- ============================================================
CREATE TABLE sales_reps (
    sales_rep_id    VARCHAR(10)  NOT NULL,
    sales_rep_name  VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(100) NOT NULL,
    office_address  VARCHAR(255) NOT NULL,
    CONSTRAINT pk_sales_reps PRIMARY KEY (sales_rep_id)
);

INSERT INTO sales_reps VALUES ('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021');
INSERT INTO sales_reps VALUES ('SR02', 'Anita Desai',  'anita@corp.com',  'Delhi Office, Connaught Place, New Delhi - 110001');
INSERT INTO sales_reps VALUES ('SR03', 'Ravi Kumar',   'ravi@corp.com',   'South Zone, MG Road, Bangalore - 560001');


-- ============================================================
-- TABLE 2: customers
-- Stores customer details independently
-- Fixes INSERT anomaly: customers can exist without any order
-- ============================================================
CREATE TABLE customers (
    customer_id    VARCHAR(10)  NOT NULL,
    customer_name  VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    customer_city  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);

INSERT INTO customers VALUES ('C001', 'Rohan Mehta',  'rohan@gmail.com',  'Mumbai');
INSERT INTO customers VALUES ('C002', 'Priya Sharma', 'priya@gmail.com',  'Delhi');
INSERT INTO customers VALUES ('C003', 'Amit Verma',   'amit@gmail.com',   'Bangalore');
INSERT INTO customers VALUES ('C004', 'Sneha Iyer',   'sneha@gmail.com',  'Chennai');
INSERT INTO customers VALUES ('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai');
INSERT INTO customers VALUES ('C006', 'Neha Gupta',   'neha@gmail.com',   'Delhi');
INSERT INTO customers VALUES ('C007', 'Arjun Nair',   'arjun@gmail.com',  'Bangalore');
INSERT INTO customers VALUES ('C008', 'Kavya Rao',    'kavya@gmail.com',  'Hyderabad');


-- ============================================================
-- TABLE 3: products
-- Stores product details independently
-- Fixes DELETE anomaly: products survive even if all orders deleted
-- Fixes INSERT anomaly: products can exist before anyone orders them
-- ============================================================
CREATE TABLE products (
    product_id   VARCHAR(10)    NOT NULL,
    product_name VARCHAR(100)   NOT NULL,
    category     VARCHAR(50)    NOT NULL,
    unit_price   DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_products PRIMARY KEY (product_id)
);

INSERT INTO products VALUES ('P001', 'Laptop',        'Electronics', 55000.00);
INSERT INTO products VALUES ('P002', 'Mouse',         'Electronics',   800.00);
INSERT INTO products VALUES ('P003', 'Desk Chair',    'Furniture',    8500.00);
INSERT INTO products VALUES ('P004', 'Notebook',      'Stationery',    120.00);
INSERT INTO products VALUES ('P005', 'Headphones',    'Electronics',  3200.00);
INSERT INTO products VALUES ('P006', 'Standing Desk', 'Furniture',   22000.00);
INSERT INTO products VALUES ('P007', 'Pen Set',       'Stationery',    250.00);
INSERT INTO products VALUES ('P008', 'Webcam',        'Electronics',  2100.00);


-- ============================================================
-- TABLE 4: orders
-- Stores only order-specific data
-- References customers, products, and sales_reps via foreign keys
-- Fixes UPDATE anomaly: customer/product/rep info stored only once
-- ============================================================
CREATE TABLE orders (
    order_id     VARCHAR(10) NOT NULL,
    customer_id  VARCHAR(10) NOT NULL,
    product_id   VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    quantity     INT            NOT NULL,
    order_date   DATE           NOT NULL,
    CONSTRAINT pk_orders          PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)  REFERENCES customers (customer_id),
    CONSTRAINT fk_orders_product  FOREIGN KEY (product_id)   REFERENCES products  (product_id),
    CONSTRAINT fk_orders_salesrep FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id)
);

INSERT INTO orders VALUES ('ORD1002', 'C002', 'P005', 'SR02', 1, '2023-01-17');
INSERT INTO orders VALUES ('ORD1012', 'C001', 'P006', 'SR01', 1, '2023-05-29');
INSERT INTO orders VALUES ('ORD1021', 'C008', 'P004', 'SR03', 2, '2023-08-23');
INSERT INTO orders VALUES ('ORD1022', 'C005', 'P002', 'SR01', 5, '2023-10-15');
INSERT INTO orders VALUES ('ORD1025', 'C008', 'P001', 'SR01', 2, '2023-02-26');
INSERT INTO orders VALUES ('ORD1027', 'C002', 'P004', 'SR02', 4, '2023-11-02');
INSERT INTO orders VALUES ('ORD1033', 'C004', 'P002', 'SR02', 5, '2023-03-24');
INSERT INTO orders VALUES ('ORD1035', 'C002', 'P003', 'SR02', 1, '2023-05-03');
INSERT INTO orders VALUES ('ORD1037', 'C002', 'P007', 'SR03', 2, '2023-03-06');
INSERT INTO orders VALUES ('ORD1043', 'C004', 'P005', 'SR01', 1, '2023-01-04');
INSERT INTO orders VALUES ('ORD1047', 'C008', 'P002', 'SR02', 2, '2023-07-28');
INSERT INTO orders VALUES ('ORD1048', 'C002', 'P001', 'SR03', 3, '2023-08-09');
INSERT INTO orders VALUES ('ORD1049', 'C007', 'P004', 'SR02', 1, '2023-01-28');
INSERT INTO orders VALUES ('ORD1054', 'C002', 'P001', 'SR03', 1, '2023-10-04');
INSERT INTO orders VALUES ('ORD1061', 'C006', 'P001', 'SR01', 4, '2023-10-27');
INSERT INTO orders VALUES ('ORD1075', 'C005', 'P003', 'SR03', 3, '2023-04-18');
INSERT INTO orders VALUES ('ORD1076', 'C004', 'P006', 'SR03', 5, '2023-05-16');
INSERT INTO orders VALUES ('ORD1083', 'C006', 'P007', 'SR01', 2, '2023-07-03');
INSERT INTO orders VALUES ('ORD1085', 'C001', 'P001', 'SR02', 2, '2023-03-15');
INSERT INTO orders VALUES ('ORD1086', 'C003', 'P007', 'SR01', 1, '2023-07-31');
INSERT INTO orders VALUES ('ORD1089', 'C001', 'P007', 'SR02', 2, '2023-04-24');
INSERT INTO orders VALUES ('ORD1090', 'C008', 'P003', 'SR02', 2, '2023-04-27');
INSERT INTO orders VALUES ('ORD1091', 'C001', 'P006', 'SR01', 3, '2023-07-24');
INSERT INTO orders VALUES ('ORD1092', 'C005', 'P007', 'SR01', 3, '2023-05-23');
INSERT INTO orders VALUES ('ORD1093', 'C007', 'P006', 'SR03', 1, '2023-06-19');
INSERT INTO orders VALUES ('ORD1094', 'C002', 'P003', 'SR01', 3, '2023-10-25');
INSERT INTO orders VALUES ('ORD1095', 'C001', 'P001', 'SR03', 3, '2023-08-11');
INSERT INTO orders VALUES ('ORD1098', 'C007', 'P001', 'SR03', 2, '2023-10-03');
INSERT INTO orders VALUES ('ORD1101', 'C005', 'P006', 'SR02', 4, '2023-06-17');
INSERT INTO orders VALUES ('ORD1114', 'C001', 'P007', 'SR01', 2, '2023-08-06');
INSERT INTO orders VALUES ('ORD1118', 'C006', 'P007', 'SR02', 5, '2023-11-10');
INSERT INTO orders VALUES ('ORD1124', 'C003', 'P002', 'SR02', 2, '2023-12-22');
INSERT INTO orders VALUES ('ORD1125', 'C004', 'P001', 'SR02', 3, '2023-07-28');
INSERT INTO orders VALUES ('ORD1127', 'C007', 'P007', 'SR03', 1, '2023-12-23');
INSERT INTO orders VALUES ('ORD1131', 'C008', 'P001', 'SR02', 4, '2023-06-22');
INSERT INTO orders VALUES ('ORD1132', 'C003', 'P007', 'SR02', 5, '2023-03-07');
INSERT INTO orders VALUES ('ORD1133', 'C001', 'P004', 'SR03', 1, '2023-10-16');
INSERT INTO orders VALUES ('ORD1137', 'C005', 'P007', 'SR02', 1, '2023-05-10');
INSERT INTO orders VALUES ('ORD1143', 'C003', 'P005', 'SR03', 2, '2023-02-28');
INSERT INTO orders VALUES ('ORD1144', 'C005', 'P001', 'SR03', 3, '2023-01-14');
INSERT INTO orders VALUES ('ORD1148', 'C007', 'P006', 'SR02', 5, '2023-02-05');
INSERT INTO orders VALUES ('ORD1153', 'C006', 'P007', 'SR01', 3, '2023-02-14');
INSERT INTO orders VALUES ('ORD1155', 'C007', 'P003', 'SR01', 3, '2023-09-11');
INSERT INTO orders VALUES ('ORD1161', 'C004', 'P004', 'SR03', 3, '2023-05-05');
INSERT INTO orders VALUES ('ORD1162', 'C006', 'P004', 'SR03', 3, '2023-09-29');
INSERT INTO orders VALUES ('ORD1163', 'C007', 'P006', 'SR03', 3, '2023-06-19');
INSERT INTO orders VALUES ('ORD1166', 'C003', 'P002', 'SR01', 3, '2023-09-05');
INSERT INTO orders VALUES ('ORD1169', 'C003', 'P003', 'SR01', 5, '2023-01-28');
INSERT INTO orders VALUES ('ORD1180', 'C008', 'P004', 'SR01', 3, '2023-06-02');
INSERT INTO orders VALUES ('ORD1185', 'C003', 'P008', 'SR03', 1, '2023-06-15');
