-- Create saleswalmart database
CREATE DATABASE saleswalmart;

-- Create Sales Table
CREATE TABLE Sales (
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(30) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12,4) NOT NULL,
rating FLOAT(2,1) 
);

-- Select the columns with null values in them
SELECT * FROM sales WHERE product_line IS NULL;

-- Add a column time_of_the_day to find out which part of the day sales were made
SELECT time , 
(CASE 
WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
ELSE 'Evening'
END
) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
 SET time_of_day = (
CASE 
	WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
    WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END
);

-- day_name for corresponding date 
SELECT date,DAYNAME(date) AS day_name FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

UPDATE Sales 
SET day_name = DAYNAME(date);

-- month_name
SELECT date ,MONTHNAME(date) AS month_name FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE Sales 
SET month_name=MONTHNAME(date); 

-- ---------------------- Generic Questions -------------------------------

-- How many unique cities does data have 
SELECT DISTINCT city FROM Sales;
SELECT COUNT( DISTINCT city) FROM Sales;

-- In which city is each branch?
SELECT DISTINCT branch FROM Sales;
SELECT DISTINCT city,branch FROM sales;

-- -------------------------------------Product -------------------------

-- How many unique product lines does the data have?
SELECT DISTINCT product_line FROM Sales;
SELECT COUNT(DISTINCT product_line) FROM Sales;

-- What is the most common payment method?
SELECT payment_method,COUNT(payment_method) FROM Sales GROUP BY payment_method ORDER BY COUNT(payment_method) DESC;

-- What is the most selling product line?
SELECT product_line,COUNT(product_line) AS cnt FROM Sales GROUP BY product_line ORDER BY COUNT(product_line) DESC;

-- What is the total revenue by month?
SELECT month_name AS month,SUM(total) AS total_revenue FROM Sales GROUP BY month_name ORDER BY total_revenue DESC;

-- What month has largest COGS
SELECT month_name,SUM(COGS) AS sum_of_cogs FROM Sales GROUP BY month_name ORDER BY SUM(COGS) DESC;

-- What product line has largest revenue?
SELECT product_line , SUM(total) AS total_revenue FROM Sales GROUP BY product_line ORDER BY SUM(total) DESC;

-- What is the city with the largest revenue?
SELECT city,branch,SUM(total) FROM sales GROUP BY city,branch ORDER BY SUM(total) DESC;

-- What product line had the largest VAT
SELECT product_line,AVG(VAT) AS avg_vat FROM Sales GROUP BY product_line ORDER BY AVG(VAT) DESC;

-- Which branch sold more products than average products sold
SELECT branch,SUM(quantity) AS qty FROM Sales GROUP BY branch HAVING SUM(quantity) > (SELECT AVG(quantity) FROM Sales);

-- Most common product line by gender 
SELECT gender,product_line,COUNT(gender) FROM Sales GROUP BY gender,product_line ORDER BY COUNT(gender) DESC;

-- What is the average rating of each product line
SELECT product_line,AVG(rating) FROM Sales GROUP BY product_line ORDER BY AVG(rating) DESC;

-- ------------------------------------- Sales -----------------------------------

-- Number of sales made in each time of the day per weekday
SELECT time_of_day,COUNT(*) FROM SALES WHERE day_name NOT IN ('Saturday','Sunday')  GROUP BY time_of_day ORDER BY COUNT(*) DESC;

-- Which type of customer types bring most revenue
SELECT customer_type,SUM(total) from sales GROUP BY customer_type;

-- Which city has the largest tax percent/VAT (Value added tax)
SELECT city,SUM(VAT) FROM Sales GROUP BY city ORDER BY SUM(VAT) DESC;

-- Which customer type pays more VAT
SELECT customer_type,SUM(VAT) FROM Sales GROUP BY customer_type ORDER BY SUM(VAT) DESC;

-- ------------------------------------- Customer --------------------------

-- How many unique customer types does the data have
SELECT COUNT(DISTINCT customer_type) FROM Sales;

-- How many unique payment methods does data have
SELECT COUNT(DISTINCT payment_method) FROM Sales;

-- What is the most common customer type
SELECT customer_type, COUNT(customer_type) FROM Sales GROUP BY customer_type ORDER BY COUNT(customer_type) DESC;

-- Which customer type buys the most
SELECT customer_type , COUNT(*) FROM Sales GROUP BY customer_type;

-- What is the gender of most of customers
SELECT gender,COUNT(*) FROM Sales GROUP BY gender ORDER BY COUNT(*) DESC;

-- What is the gender distribution per branch
SELECT gender,branch,COUNT(*) FROM Sales GROUP BY gender,branch ORDER BY COUNT(*) DESC;

-- Which time of day do customers give most ratings
SELECT time_of_day,COUNT(rating) FROM Sales GROUP BY time_of_day ORDER BY COUNT(rating) DESC;

-- What time of day do customers give most ratings per branch
SELECT time_of_day,branch,COUNT(rating) FROM Sales GROUP BY time_of_day,branch ORDER BY COUNT(rating) DESC;

-- Which day of the week has best avg ratings
SELECT day_name,AVG(rating) AS avg_rating from Sales GROUP BY day_name ORDER BY AVG(rating) DESC;

-- Which day of the week has best average ratings per branch 
SELECT day_name,branch,AVG(rating) FROM Sales GROUP BY day_name,branch ORDER BY AVG(rating) DESC;