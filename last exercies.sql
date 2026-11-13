--'202511449','202512523','202513073','202511613'
( 202511198 - Asim Mohamed ) 
create database regions_db;
use regions_db;
CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL
);

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    branch_id INT,
    manager_id INT,
    performance_score INT,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    branch_id INT,
    quantity INT NOT NULL,
    sale_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);
INSERT INTO regions VALUES (1, 'Kigali'), (2, 'Butare'), (3, 'Musanze');

INSERT INTO branches VALUES (101, 'Kigali Main', 1), (102, 'Butare Central', 2), (103, 'Musanze North', 3);

INSERT INTO employees VALUES 
(1, 'Alice Umutoni', 101, NULL, 95),
(2, 'Bob Ndayisaba', 101, 1, 88),
(3, 'Chantal Uwase', 102, NULL, 92),
(4, 'David Mugabo', 103, NULL, 85);

INSERT INTO customers VALUES 
(1, 'Eric Gasana', 1),
(2, 'Diane Mukamana', 2),
(3, 'Frank Kagame', 3),
(4, 'Grace Uwimana', 1);

INSERT INTO products VALUES 
(1, 'Laptop', 1200.00, 1),
(2, 'Smartphone', 800.00, 1),
(3, 'Tablet', 400.00, 2),
(4, 'Monitor', 250.00, 3);

INSERT INTO sales VALUES 
(1, 1, 1, 101, 2, '2026-01-15', 2400.00),
(2, 2, 2, 101, 1, '2026-02-10', 800.00),
(3, 3, 3, 102, 3, '2026-02-15', 1200.00),
(4, 4, 4, 103, 2, '2026-03-01', 500.00),
(5, 1, 2, 101, 1, '2026-03-10', 1200.00);
SELECT s.sale_id, p.product_name, c.customer_name, s.amount
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN customers c ON s.customer_id = c.customer_id;
SELECT b.branch_name, s.sale_id, s.amount
FROM branches b
LEFT JOIN sales s ON b.branch_id = s.branch_id;
SELECT p.product_name, s.sale_id, s.amount
FROM sales s
RIGHT JOIN products p ON s.product_id = p.product_id;
SELECT c.customer_name, s.sale_id, s.amount
FROM customers c
FULL OUTER JOIN sales s ON c.customer_id = s.customer_id;
SELECT e.employee_name AS Employee, m.employee_name AS Manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
SELECT product_id, amount,
       ROW_NUMBER() OVER (ORDER BY amount DESC) as rn,
       RANK() OVER (ORDER BY amount DESC) as rnk,
       DENSE_RANK() OVER (ORDER BY amount DESC) as dense_rnk,
       PERCENT_RANK() OVER (ORDER BY amount DESC) as pct_rnk
FROM sales;
SELECT branch_id, sale_date, amount,
       SUM(amount) OVER (PARTITION BY branch_id ORDER BY sale_date) as running_total,
       AVG(amount) OVER (PARTITION BY branch_id) as avg_branch_sales,
       MIN(amount) OVER (PARTITION BY branch_id) as min_sales,
       MAX(amount) OVER (PARTITION BY branch_id) as max_sales,
       COUNT(sale_id) OVER (PARTITION BY branch_id) as sales_count
FROM sales;
SELECT sale_date, amount,
       LAG(amount, 1) OVER (ORDER BY sale_date) as prev_amount,
       LEAD(amount, 1) OVER (ORDER BY sale_date) as next_amount
FROM sales;
SELECT customer_id, amount,
       NTILE(4) OVER (ORDER BY amount) as spending_quartile,
       CUME_DIST() OVER (ORDER BY amount) as cume_distribution
FROM sales;
SELECT sale_id, branch_id, amount,
       AVG(amount) OVER (PARTITION BY branch_id ORDER BY sale_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as moving_avg_rows,
       AVG(amount) OVER (PARTITION BY branch_id ORDER BY sale_date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as moving_avg_range
FROM sales;
