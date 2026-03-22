!pip install duckdb
import duckdb
print('DuckDB ready!')
from google.colab import files
uploaded = files.upload()
con = duckdb.connect()
print('Connected to DuckDB!')

# Q1: List all customers along with total number of orders they have placed
q1 = """
SELECT
    c.customer_id,
    c.name            AS customer_name,
    c.city,
    COUNT(o.order_id) AS total_orders
FROM read_csv_auto('customers.csv') AS c
LEFT JOIN read_json_auto('orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_orders DESC
"""
result_q1 = con.execute(q1).df()
print('Q1 — Customers with total orders:')
print(result_q1.to_string())
# Q2: Find the top 3 customers by total order value
q2 = """
SELECT
    c.customer_id,
    c.name                AS customer_name,
    c.city,
    SUM(o.total_amount)   AS total_order_value,
    COUNT(o.order_id)     AS total_orders
FROM read_csv_auto('customers.csv') AS c
JOIN read_json_auto('orders.json') AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_order_value DESC
LIMIT 3
"""
result_q2 = con.execute(q2).df()
print('Q2 — Top 3 customers by order value:')
print(result_q2.to_string())
# Q3: List all products purchased by customers from Bangalore
q3 = """
SELECT DISTINCT
    c.customer_id,
    c.name           AS customer_name,
    c.city,
    o.order_id,
    o.order_date,
    p.product_name,
    p.category
FROM read_csv_auto('customers.csv')   AS c
JOIN read_json_auto('orders.json')    AS o ON c.customer_id = o.customer_id
JOIN read_parquet('products.parquet') AS p ON o.order_id    = p.order_id
WHERE c.city = 'Bangalore'
ORDER BY c.customer_id
"""
result_q3 = con.execute(q3).df()
print('Q3 — Products bought by Bangalore customers:')
print(result_q3.to_string())
# Q4: Join all 3 files — customer name, order date, product name, quantity
q4 = """
SELECT
    c.name         AS customer_name,
    c.city         AS customer_city,
    o.order_id,
    o.order_date,
    o.status       AS order_status,
    p.product_name,
    p.category,
    p.quantity,
    p.unit_price,
    o.total_amount
FROM read_csv_auto('customers.csv')   AS c
JOIN read_json_auto('orders.json')    AS o ON c.customer_id = o.customer_id
JOIN read_parquet('products.parquet') AS p ON o.order_id    = p.order_id
ORDER BY o.order_date
"""
result_q4 = con.execute(q4).df()
print('Q4 — Full join: customer name, order date, product name, quantity:')
print(result_q4.to_string())
