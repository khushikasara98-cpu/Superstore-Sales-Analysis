CREATE DATABASE Store_Analytics;
USE Store_Analytics;

CREATE TABLE master_dataset (
Order_ID VARCHAR(50),
Order_Date VARCHAR(50),
Ship_Date VARCHAR(50),
Ship_Mode VARCHAR(50),
Customer_ID VARCHAR(50),
Customer_Name VARCHAR(100),
Segment VARCHAR(50),
Country VARCHAR(50),
City VARCHAR(50),
State VARCHAR(50),
Region VARCHAR(50),
Product_ID VARCHAR(50),
Category VARCHAR(50),
Sub_Category VARCHAR(50),
Product_Name VARCHAR(255),
Sales DECIMAL(10,2),
Quantity INT,
Profit DECIMAL(10,2)
);

SELECT @@secure_file_priv;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_order1.csv' INTO TABLE master_dataset FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;


SELECT COUNT(*) FROM master_dataset;

SELECT DATABASE();
SHOW TABLES;
SHOW CREATE TABLE master_dataset;
TRUNCATE TABLE master_dataset;

SELECT * FROM master_dataset;

SHOW WARNINGS;
SELECT Order_ID, Sales, Profit FROM master_dataset LIMIT 10;

-- 1. Customers Table (Unique Customers)
CREATE TABLE Customers AS SELECT DISTINCT 
Customer_ID,
MIN(Customer_Name) AS Customer_Name,
MIN(Segment) AS Segment,
MIN(Country) AS Country,
MIN(city) AS City,
MIN(State) AS State,
MIN(Region) AS Region
FROM master_dataset
GROUP BY Customer_ID;

-- 2. Products Table (Unique Products)
CREATE TABLE Products AS SELECT DISTINCT 
Product_ID,
Category AS Product_Category,
Sub_Category,
MIN(Product_Name) AS Product_Name
FROM master_dataset
GROUP BY Product_ID, Category, Sub_Category;

-- 3. Orders Table (Transactions)
CREATE TABLE Orders AS SELECT
Order_ID,
Order_Date,
Ship_Date,
Ship_Mode,
Customer_ID,
Product_ID,
Sales,
Quantity,
Profit
FROM master_dataset;

SELECT 
o.Order_ID,
o.Order_Date,
c.Customer_Name,
c.Region,
p.Product_Category,
o.Sales,
o.Profit
FROM Orders o
INNER JOIN Customers c ON o.Customer_ID = c.Customer_ID
INNER JOIN Products p ON o.Product_ID = p.Product_ID;

-- Total Sales by Region
SELECT
c.Region,
SUM(o.Sales) AS Total_Sales
FROM Orders o
INNER JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY Total_Sales DESC;

-- Profit Margin by Category
SELECT 
p.Product_Category,
SUM(o.Profit)/SUM(o.Sales) AS Profit_Margin
FROM Orders o
INNER JOIN Products p ON o.Product_ID = p.Product_ID
GROUP BY p.Product_Category;

-- Monthly Sales Trend
SELECT
MONTH(STR_TO_DATE(o.Order_Date, '%d-%m-%Y')) AS Month,
SUM(o.Sales) AS Monthly_Sales
FROM Orders o
GROUP BY MONTH(STR_TO_DATE(o.Order_Date, '%d-%m-%Y'))
ORDER BY Month;

-- Top 5 Customers by Revenue
SELECT
c.Customer_Name,
SUM(o.Sales) AS Total_Revenue
FROM Orders o
INNER JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
ORDER BY Total_Revenue DESC
LIMIT 5;


