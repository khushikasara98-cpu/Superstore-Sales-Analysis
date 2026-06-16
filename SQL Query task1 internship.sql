CREATE DATABASE superstore;
USE superstore;

CREATE TABLE sales_dataset (
order_id VARCHAR(50),
order_date VARCHAR(20),
ship_date VARCHAR(20),
ship_mode VARCHAR(50),
customer_name VARCHAR(50),
segment VARCHAR(50),
state VARCHAR(50),
country VARCHAR(100),
market VARCHAR(50),
region VARCHAR(50),
product_id VARCHAR(50),
category VARCHAR(100),
sub_category VARCHAR(100),
product_name VARCHAR(255),
sales VARCHAR(50),
quantity VARCHAR(50),
discount VARCHAR(50),
profit VARCHAR(50),
shipping_cost VARCHAR(50),
order_priority VARCHAR(20),
year VARCHAR(50)
);

SELECT @@secure_file_priv;
SELECT COUNT(*) FROM sales_dataset;

SELECT DATABASE();
SHOW TABLES;
SHOW CREATE TABLE sales_dataset;
TRUNCATE TABLE sales_dataset;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/superstore_sales.csv' INTO TABLE sales_dataset FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

SELECT * FROM sales_dataset;

SELECT region, SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '')AS DECIMAL(10,2))) AS total_sales FROM sales_dataset GROUP BY region;

SELECT product_name, SUM(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '')AS DECIMAL(10,2))) AS total_profit FROM sales_dataset GROUP BY product_name ORDER BY total_profit DESC LIMIT 5;

SELECT MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) AS month_number, SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '')AS DECIMAL(10,2))) AS total_sales FROM sales_dataset GROUP BY month_number ORDER BY month_number;

SELECT discount, AVG(CAST(REPLACE(REPLACE(profit, '$', ''), ',', '')AS DECIMAL(10,2))) AS average_profit FROM sales_dataset GROUP BY discount ORDER BY discount;

SELECT state, SUM(CAST(REPLACE(REPLACE(sales, '$', ''), ',', '')AS DECIMAL(10,2))) AS total_sales FROM sales_dataset GROUP BY state ORDER BY total_sales DESC LIMIT 5;




