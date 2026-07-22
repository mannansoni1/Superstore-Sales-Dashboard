
-- Table: Customers
--
-- Purpose:
-- This table stores the basic details of each customer.
-- I have kept only the stable customer information here.
-- Location details are stored in the Orders table because
-- the same customer may place orders from different locations.


CREATE TABLE customers (

    -- Unique ID assigned to every customer.
    customer_id VARCHAR(20) PRIMARY KEY,

    -- Full name of the customer.
    customer_name VARCHAR(100) NOT NULL,

    -- Customer segment such as Consumer, Corporate,
    -- or Home Office.
    segment VARCHAR(30)

);



-- Table: Products
--
-- Purpose:
-- This table stores information about each product.
-- Keeping product details in a separate table avoids
-- repeating the same information in every order.


CREATE TABLE products (

    -- Unique ID assigned to every product.
    product_id VARCHAR(30) PRIMARY KEY,

    -- Name of the product.
    product_name VARCHAR(255) NOT NULL,

    -- Main category the product belongs to.
    category VARCHAR(50),

    -- More specific classification within a category.
    sub_category VARCHAR(50)

);




-- Table: Orders
--
-- Purpose:
-- This table stores every sales transaction made by customers.
-- Each row represents one product purchased in an order.
-- It connects customers and products while also storing
-- order details, shipping information, and sales metrics.


CREATE TABLE orders (

    -- Unique order number assigned to each customer order.
    order_id VARCHAR(30),

    -- Date on which the order was placed.
    order_date DATE,

    -- Date on which the order was shipped.
    ship_date DATE,

    -- Shipping method chosen for the order.
    ship_mode VARCHAR(50),

    -- Customer who placed the order.
    customer_id VARCHAR(20),

    -- Product included in the order.
    product_id VARCHAR(30),

    -- Country where the order was delivered.
    country VARCHAR(50),

    -- City where the order was delivered.
    city VARCHAR(50),

    -- State where the order was delivered.
    state VARCHAR(50),

    -- Postal code of the delivery location.
    postal_code VARCHAR(20),

    -- Sales region associated with the order.
    region VARCHAR(30),

    -- Total sales amount for this product in the order.
    sales DECIMAL(10,2),

    -- Number of units purchased.
    quantity INT,

    -- Discount applied to the product.
    discount DECIMAL(4,2),

    -- Profit earned from this order line.
    profit DECIMAL(10,2),

    -- A single order can contain multiple products.
    -- Therefore, the combination of Order ID and Product ID
    -- uniquely identifies each order line.
    PRIMARY KEY (order_id, product_id),

    -- Ensures that every order belongs to an existing customer.
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    -- Ensures that every product in an order exists
    -- in the products table.
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)

);




-- Insert Data into Customers
--
-- Purpose:
-- The staging table contains one row for every product sold,
-- so the same customer appears multiple times.
--
-- Grouping by Customer ID ensures that each customer is
-- stored only once. 
-- for the remaining customer details if duplicate records
-- exist in the source data.


INSERT INTO customers (

    customer_id,
    customer_name,
    segment

)



   SELECT DISTINCT
customer_id,
customer_name,
segment
FROM staging_superstore;



-- Insert Data into Products
--
-- Purpose:
-- The staging table contains one row for every product sold,
-- so the same product appears multiple times across different
-- customer orders.
--
-- While reviewing the source data, a few Product IDs were
-- found to have inconsistent product names. Since Product ID
-- is treated as the unique business identifier, the data is
-- grouped by Product ID to ensure that only one record is
-- stored for each product.
--
-- MAX() is used to select one representative value for the
-- remaining product attributes. In a production environment,
-- these inconsistencies should be reviewed and corrected with
-- the business or data owners before loading the data.

INSERT INTO products (

    product_id,
    product_name,
    category,
    sub_category

)

SELECT

    product_id,
    MAX(product_name),
    MAX(category),
    MAX(sub_category)

FROM staging_superstore

GROUP BY product_id;




-- Insert Data into Orders
--
-- Purpose:
-- This table stores every sales transaction from the staging
-- table. Each row represents one product purchased in an
-- order.
--
-- Unlike the Customers and Products tables, no grouping or
-- DISTINCT is used here because every order line represents
-- a separate transaction that should be preserved.
--
-- Customer ID and Product ID are inserted as foreign keys,
-- linking each order to the corresponding customer and
-- product records.


INSERT INTO orders (

    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    product_id,
    country,
    city,
    state,
    postal_code,
    region,
    sales,
    quantity,
    discount,
    profit

)

SELECT

    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    product_id,
    country,
    city,
    state,
    postal_code,
    region,
    sales,
    quantity,
    discount,
    profit

FROM staging_superstore;



-- Display all tables created for the project.


SHOW TABLES;





-- Display the structure of the Orders table.


DESCRIBE orders;





-- Join Customers, Orders, and Products.
SELECT o.order_id,c.customer_name,p.product_name,o.sales,o.profit
FROM orders o
Inner JOIN customers c
ON o.customer_id = c.customer_id
 Inner JOIN products p
ON o.product_id = p.product_id
LIMIT 10;



-- Calculate total sales.
-- Purpose:
-- Displays the overall sales generated from all orders.

SELECT
ROUND(SUM(sales),2) AS total_sales
FROM orders;





-- Calculate total profit.
-- Purpose:
-- Shows the total profit earned across all orders.

SELECT
ROUND(SUM(profit),2) AS total_profit
FROM orders;


-- Top 10 Customers by Sales
-- Purpose:
-- Identifies the customers who generated the highest
-- sales revenue.


SELECT
    c.customer_name,
    ROUND(SUM(o.sales),2) AS total_sales
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_sales DESC
LIMIT 10;



-- Sales by Region
-- Purpose:
-- Compare sales performance across different regions.
SELECT
region,
ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;





-- Sales by Category
-- Purpose:
-- Compare sales across product categories.


SELECT
    p.category,
    ROUND(SUM(o.sales),2) AS total_sales
FROM orders o
  INNER JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;





-- Monthly Sales Trend
-- Purpose:
-- Analyze how sales changed over time.


SELECT
YEAR(order_date) AS year,
MONTH(order_date) AS month,
    ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY
    YEAR(order_date),MONTH(order_date)
ORDER BY year,month;


-- Profit by Category
-- Purpose:
-- Identify which product category generated the
-- highest profit.


SELECT
    p.category,
    ROUND(SUM(o.profit),2) AS total_profit
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;



-- ROW_NUMBER()
SELECT
    c.customer_name,
    ROUND(SUM(o.sales), 2) AS total_sales,
    ROW_NUMBER() OVER (ORDER BY SUM(o.sales) DESC) AS sales_rank
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name;



   --   Common Table Expression (CTE)
-- Regional Sales using CTE

WITH RegionalSales AS (
SELECT
        region,ROUND(SUM(sales), 2) AS total_sales
    FROM orders
    GROUP BY region
)
SELECT *
FROM RegionalSales
ORDER BY total_sales DESC;

-- CASE WHEN
-- Categorize Orders by Sales
SELECT
    order_id,
    sales,
    CASE
        WHEN sales >= 500 THEN 'High Sales'
        WHEN sales >= 200 THEN 'Medium Sales'
        ELSE 'Low Sales'
    END AS sales_category
FROM orders;

