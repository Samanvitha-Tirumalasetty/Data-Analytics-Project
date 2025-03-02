#Find the top 10 highest revenue generating products.
SELECT product_id, SUM(sale_price) AS sales
FROM df_orders
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;

#Find top 5 highest selling products in each region
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

# For each category which month had highest sales
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


#Which sub category had highest growth by profit in 2023 compare to 2022
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
select * 
, (sales_2023-sales_2022)
from cte2
order by(sales_2023-sales_2022) desc
limit 1;
