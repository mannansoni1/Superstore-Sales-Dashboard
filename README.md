# 📊 Superstore Sales Dashboard (SQL + MySQL + Power BI)

## About This Project

I built this project to understand how SQL and Power BI work together in a real business scenario.

Instead of importing the Excel file directly into Power BI, I first imported the data into **MySQL**, designed a relational database, analyzed the data using SQL, and then connected Power BI to MySQL to create an interactive dashboard.

This project helped me improve my understanding of database design, SQL queries, Power BI, DAX, and dashboard development.



# Dashboard Preview

"C:\Users\manna\OneDrive\Desktop\Superstore-Sales-Dashboard\Images\dashboard.png"

# Project Workflow

### Step 1 – Importing Data into MySQL

The Superstore dataset was originally available as an Excel file.

I imported the dataset into MySQL and created separate tables for:

- Customers
- Orders
- Products

Instead of keeping everything in one table, I divided the data into multiple related tables to reduce redundancy and follow database normalization principles.

---

### Step 2 – Database Design

After creating the tables, I established relationships using primary and foreign keys.


"C:\Users\manna\OneDrive\Desktop\Superstore-Sales-Dashboard\Images\data_model.png"

Customers (1)
      │
      ▼
Orders (*)
      ▲
      │
Products (1)
```

This structure made it easier to write SQL queries and build relationships in Power BI.



### Step 3 – SQL Analysis

Before creating the dashboard, I used SQL to analyze the data.

Some of the queries I wrote include:

- Total Sales
- Total Profit
- Sales by Region
- Sales by Category
- Monthly Sales Trend
- Top 10 Customers
- Profit by Category
- INNER JOIN between multiple tables

Screenshots of these queries are available in the **Images** folder.



### Step 4 – Connecting Power BI to MySQL

Instead of importing the Excel file directly into Power BI, I connected **Power BI to MySQL using the MySQL ODBC Connector**.

### Why did I use ODBC?

Power BI cannot communicate directly with MySQL on its own. The **MySQL ODBC Connector** acts as a bridge between Power BI and the MySQL database.

Using ODBC allowed me to:

- Connect Power BI directly to the MySQL database.
- Retrieve data from multiple related tables instead of a single Excel file.
- Work with a database structure similar to what is commonly used in companies.
- Refresh the dashboard whenever the database is updated.

This helped me understand how Power BI connects to relational databases in real-world projects.

### Step 5 – Building the Dashboard

After importing the data into Power BI, I:

- Created relationships between tables.
- Built DAX measures.
- Designed KPI cards.
- Added slicers.
- Created interactive charts.

The dashboard includes:

- Total Sales
- Total Profit
- Total Orders
- Total Customers
- Total Quantity
- Sales by Region
- Sales by Category
- Profit by Category
- Monthly Sales Trend
- Sales Contribution by Category
- Top 10 Customers
- Top 10 Products

Users can filter the dashboard using:

- Region
- Category
- Segment
- Year

---

# Tools Used

- Microsoft Excel
- MySQL Workbench
- SQL
- MySQL ODBC Connector
- Power BI Desktop
- DAX

---

# Challenges I Faced

While building this project, I faced a few challenges.

### 1. Connecting MySQL with Power BI

Initially, Power BI could not connect to MySQL because the ODBC driver was not installed correctly.

I solved this by:

- Installing the MySQL ODBC Connector.
- Creating an ODBC Data Source (DSN).
- Configuring the connection using the correct server, database, username, and password.

---

### 2. Understanding Table Relationships

At first, I was confused about why the relationship between Products and Orders was one-to-many instead of many-to-many.

After learning how the Orders table stores one row for each product in an order, I understood why the correct relationship is one-to-many.


### 3. Power BI Aggregation

Initially, I used the Sales column directly in visuals.

Later, I learned that Power BI automatically aggregates numeric columns, and creating DAX measures is considered a better practice because they are reusable and easier to maintain.


### 4. Dashboard Design

Choosing the right chart for each business question took several attempts.

For example:

- Bar charts were used to compare regions and categories.
- A line chart was used to analyze monthly sales trends.
- A donut chart was used to show each category's contribution to total sales.


# What I Learned

This project helped me improve my knowledge of:

- SQL
- MySQL
- Database Normalization
- Primary and Foreign Keys
- SQL JOINs
- Aggregate Functions
- Power BI
- Data Modeling
- DAX Measures
- Dashboard Design
- Business Reporting

# Future Improvements

In future versions, I would like to:

- Add Profit Margin analysis.
- Create a Sales Forecast page.
- Add more advanced DAX measures.
- Publish the dashboard to Power BI Service.
- Improve the dashboard for mobile devices.

---

# Repository Structure

```
Superstore-Sales-Dashboard
│
├── Dataset
├── Images
├── PowerBI
├── SQL
└── README.md
```

---

# Author

**Mannan**

Thank you for checking out my project! If you have any suggestions or feedback, feel free to connect with me.