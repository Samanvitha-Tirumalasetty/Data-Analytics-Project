# Data-Analytics-Project
## Project Overview 
This project focuses on performing **data extraction**, **data cleaning**, and **data loading** to prepare raw data for analysis or further processing. The goal of this project is to demonstrate the process of transforming raw data into a usable format by addressing issues like missing data, duplicates, and inconsistencies. Once cleaned, the data is loaded into a structured format that can be used for analysis.
## The project includes:

- **Data Extraction**: Retrieving data from various sources, such as databases, CSV files, or APIs.
- **Data Cleaning**: Preprocessing data by handling missing values, removing duplicates, and standardizing formats.
- **Data Loading**: Storing cleaned data into a structured format, ready for further analysis or machine learning models.
- **Data Analysis**: While not the primary focus, the project also involves basic analysis to identify key trends, correlations, or insights that might inform further data-driven decisions.

## Technologies Used

- **Python**: Main programming language for data processing and analysis
- **Pandas**: For data manipulation and cleaning
- **NumPy**: For numerical analysis
- **Jupyter Notebooks**: For interactive data analysis
- **SQL**: For data querying (if applicable)
- **Git/GitHub**: For version control and collaboration

## SQL Code for creating the table:
```sql
CREATE TABLE df_orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(20),
    segment VARCHAR(20),
    country VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_id VARCHAR(50),
    quantity INT,
    discount DECIMAL(7,2),
    sale_price DECIMAL(7,2),
    profit DECIMAL(7,2)
);
```
## Query to retrieve the data
SELECT * FROM df_orders;

## 1.Query to find the top 10 highest revenue generating products.
``` sql
SELECT product_id, SUM(sale_price) AS sales
FROM df_orders
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;
```
## 2.Query to find the top 5 highest selling products in each region.
``` sql
WITH ranked_products AS (
    SELECT product_id, region, SUM(sale_price) AS total_sales,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sale_price) DESC) AS rn
    FROM df_orders
    GROUP BY region, product_id
)
SELECT product_id, region, total_sales
FROM ranked_products
WHERE rn <= 5
ORDER BY region, total_sales DESC;

```
## 3.Query to find month over month growth comparison for 2022 and 2023 sales.[i.e.: jan 2022 vs jan 2023].
``` sql
WITH ranked_products AS (
    SELECT product_id, region, SUM(sale_price) AS total_sales,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sale_price) DESC) AS rn
    FROM df_orders
    GROUP BY region, product_id
)
SELECT product_id, region, total_sales
FROM ranked_products
WHERE rn <= 5
ORDER BY region, total_sales DESC;

#Find month over month growth comparison for 2022 and 2023 sales eg: jan 2022 vs jan 2023
WITH cte AS (
    SELECT 
        YEAR(order_date) AS order_year, 
        MONTH(order_date) AS order_month, 
        SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT 
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;
```
## 4.Query to find for each category which month had the highest sales.
``` sql
WITH cte AS (
    SELECT category, 
        DATE_FORMAT(order_date, '%Y%m') AS order_year_month, 
        SUM(sale_price) AS sales 
    FROM df_orders
    GROUP BY category, DATE_FORMAT(order_date, '%Y%m')
)
SELECT * 
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) AS rn
    FROM cte
) AS subquery
WHERE rn = 1;
```
## 5.Query to find which sub category had the highest growth by profit in 2023 compare to 2022.
``` sql
WITH cte AS (
    SELECT 
        sub_category,
        YEAR(order_date) AS order_year, 
        SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY sub_category,YEAR(order_date)
)
, cte2 as (
SELECT 
    sub_category,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY sub_category
)
select * , (sales_2023-sales_2022)
from cte2
order by(sales_2023-sales_2022) desc
limit 1;
```
## Organizational Benifits

- **Improved Decision-Making**: Clean and reliable data enables better business decisions by reducing errors and inconsistencies, leading to more accurate insights.

- **Increased Efficiency**: Automating data extraction, cleaning, and loading saves time, allowing employees to focus on higher-value tasks, improving overall productivity.

- **Cost Savings**: Streamlined processes reduce manual effort and the costs associated with data errors, corrections, and delays.

- **Scalability**: The project allows businesses to efficiently manage growing data volumes without compromising on quality or performance.

- **Better Insights**: Clean data enables deeper analysis, helping businesses identify trends, optimize operations, and improve customer targeting, which drives growth.

- **Faster Time to Market**: With quicker access to clean data, businesses can launch products or services more rapidly, responding to market demands with agility.

- **Compliance & Risk Management**: Ensures data accuracy for compliance with regulations, minimizing risks of errors or fraud.

## Project Insights

- **Data Cleaning**: Gained experience in handling missing values, removing duplicates, and transforming data for analysis.
- **SQL Querying**: Practiced extracting and querying data from databases using SQL for efficient data manipulation.
- **Jupyter Notebooks**: Used Jupyter for interactive analysis, live coding, and creating reproducible reports.
- **Version Control with Git/GitHub**: Improved skills in version control, collaboration, and project management using Git.
- **ETL Process**: Hands-on experience with the full Extract, Transform, Load (ETL) pipeline.
- **Data-Driven Decision Making**: Developed insights from data analysis to support informed decision-making.
  
## Contributing
Feel free to fork this repository, create a new branch, and submit a pull request if you have suggestions for improvements. All contributions are welcome!


