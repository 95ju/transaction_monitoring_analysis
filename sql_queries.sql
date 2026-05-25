Transaction_analysis_queries.sql

—Display first 5 transactions
SELECT *
FROM transactions
LIMIT 5;

—Count total transactions
SELECT COUNT(*) 
FROM transactions;

—Revenue by country
SELECT COUNTRY,
SUM(numberOfitemsPurchased*costperitem) AS total_revenue
FROM transactions
GROUP BY country
ORDER BY total_revenue DESC;

Revenue Insights:
United Kingdom generates the highest revenue by far.
European countries dominate total sales revenue.

frutos=# SELECT itemdescription,
frutos-# SUM(numberofitemspurchased)AS total_items_sold
frutos-# FROM transactions
frutos-# GROUP BY itemdescription
frutos-# ORDER BY total_items_sold DESC
frutos-# LIMIT 10;

Business Insight:
The most sold product is
World war 2 gliders ASST DESIGNS

Several decorative and gift-related items dominate sales volume,
Suggesting strong demand for home and novelty products.

frutos=# SELECT country,
frutos-# COUNT(*) AS total_transactions
frutos-# FROM transactions
frutos-# GROUP BY country
frutos-# ORDER BY total_transactions DESC
frutos-# LIMIT 10;

Business Insight:
The United Kingdom generates the highest transaction volume by far.
The Netherlands generate high revenue with less transactions  4742, which may indicate higher average order value


Customer behavior Insights:
frutos=# SELECT country,
frutos-# SUM(numberofitemspurchased*costperitem)/ COUNT(*) AS avg_revenue_per_transaction
frutos-# FROM transactions
frutos-# GROUP BY country
frutos-# ORDER BY avg_revenue_per_transaction DESC
frutos-# LIMIT 10;

Netherlands has a higher average transaction value
This could indicate:
-higher-priced products
-Bulk purchases
-larger basket sizes
-business/commercial customers

frutos=# SELECT userid,
frutos-# SUM(numberofitemspurchased*costperitem) AS total_customer_revenue
frutos-# FROM transactions
frutos-# GROUP BY userid
frutos-# ORDER BY total_customer_revenue DESC
frutos-# LIMIT 10;

Business insight:
A small number of customers generate a disproportionately high share of total revenue.
This may indicate the presence of high-value commercial customers or bulk purchasing behavior.
One customer ID(-1) appears among the top revenue generators, which may indicate missing customer information, anonymous transactions, or a potential data quality issue.

frutos=# SELECT userid,
frutos-# itemdescription,
frutos-# numberofitemspurchased,
frutos-# costperitem,
frutos-# (numberofitemspurchased*costperitem)AS transaction_value
frutos-# FROM transactions
frutos-# ORDER BY transaction_value DESC
frutos-# LIMIT 10;

Several transactions contain unusually high transaction values, particularly for low-value retail products such as lamps.
This may indicate data quality issues, pricing anomalies, or erroneous transaction records.

frutos=# WITH ranked_customers AS(
frutos(# SELECT country,
frutos(# userid,
frutos(# SUM(numberofitemspurchased*costperitem) AS total_revenue,
frutos(# RANK() OVER(
frutos(# PARTITION BY country
frutos(# ORDER BY SUM(numberofitemspurchased*costperitem) DESC) AS revenue_rank
frutos(# FROM transactions
frutos(# GROUP BY country, userid)
frutos-# SELECT country,
frutos-# userid,
frutos-# total_revenue,
frutos-# revenue_rank
frutos-# FROM ranked_customers
frutos-# WHERE revenue_rank <=3
frutos-# ORDER BY country, revenue_rank;

For each country show the top 3 customers by total revenue

Ex

Australia            | 260715 |     1026822.9000000007 |            1
 Australia            | 261051 |     45170.519999999975 |            2
 Australia            | 260148 |      23074.37999999999 |            3

Some countries contain unusually high-revenue customers, which may represent commercial buyers, bulk purchasing activity, or potential anomalies requiring further investigation.

frutos=# SELECT country,
frutos-# AVG(numberofitemspurchased) AS avg_quantity_purchased
frutos-# FROM transactions
frutos-# GROUP BY country
frutos-# ORDER BY avg_quantity_purchased DESC
frutos-# LIMIT 10;

Counties such as the Netherlands, Sweden, and Japan show significantly higher average purchase quantities, which may indicate bulk purchasing behavior or a stronger presence of commercial customers

frutos=# SELECT itemdescription,
frutos-# SUM (numberofitemspurchased*costperitem) AS total_product_revenue
frutos-# FROM transactions
frutos-# GROUP BY itemdescription
frutos-# ORDER BY total_product_revenue DESC
frutos-# LIMIT 10;

Operational Insights:
A small number of products generate disproportionally high revenue, with certain items such as RETROSPOT LAMP showing unusually large transaction values that may indicate  pricing anomalies or data quality issues

Which countries generate the highest average revenue per custo,er+

frutos=# SELECT country,
frutos-# SUM(numberofitemspurchased*costperitem)/COUNT(DISTINCT userid) AS avg_revenue_per_customer
frutos-# FROM transactions
frutos-# GROUP BY country
frutos-# ORDER BY avg_revenue_per_customer DESC
frutos-# LIMIT 10;

Countries such as EIRE and the Netherlands generate significantly higher average rev by customer, suggesting the presence of high-value customers or stronger purchasing behavior in these markets.

frutos=# WITH customer_revenue AS(
frutos(# SELECT country,
frutos(# userid,
frutos(# SUM(numberofitemspurchased*costperitem) AS total_revenue
frutos(# FROM transactions
frutos(# GROUP BY country,userid
frutos(# )
frutos-# SELECT country,
frutos-# userid,
frutos-# total_revenue,
frutos-# AVG(total_revenue)OVER(
frutos(# PARTITION BY country
frutos(# ) AS country_avg_revenue
frutos-# FROM customer_revenue
frutos-#  ORDER BY total_revenue DESC
frutos-# LIMIT 20;

Some customers generate revenue far above their country average, indicating strong customer concentration and potential high-value or anomalous purchasing behavior

Risk/anomaly Insight:

frutos=# SELECT userid,
frutos-# country,
frutos-# itemdescription,
frutos-# numberofitemspurchased,
frutos-# costperitem,
frutos-# (numberofitemspurchased*costperitem) AS transaction_value
frutos-# FROM transactions
frutos-# WHERE (numberofitemspurchased*costperitem)>100000
frutos-# ORDER BY transaction_value DESC
frutos-# LIMIT 20;


Several transactions contain unusually high purchase quantities and transaction values, particularly in the United Kingdom which might indicate bulk purchases, data quality issues or potentially anomalies requiring further investigation



frutos=# CREATE TABLE customers(
frutos(# userid INT,
frutos(# customer_segment TEXT
frutos(# );
CREATE TABLE
frutos=# INSERT INTO customers VALUES
frutos-# (278166,'Retail'),
frutos-# (337701,'Corporate'),
frutos-# (267099,'Small Business'),
frutos-# (380478,'VIP'),
frutos-# (288687,'Corporate');
INSERT 0 5


frutos=# SELECT t.userid,
frutos-#  t.country,
frutos-# c.customer_segment,
frutos-# SUM(t.numberofitemspurchased*t.costperitem) AS total_revenue
frutos-# FROM transactions t
frutos-# INNER JOIN customers c
frutos-# on t.userid=c.userid
frutos-# GROUP BY t.userid,t.country,c.customer_segment
frutos-# ORDER BY total_revenue DESC;


Corporate customers generate significantly higher revenue compared to other business segments, suggesting that business-oriented clients contribute a major sales of total shares


frutos=# SELECT c.customer_segment,
frutos-# COUNT(DISTINCT t.userid) AS total_customers,
frutos-# SUM(t.numberofitemspurchased*t.costperitem)AS total_revenue,
frutos-# AVG(t.numberofitemspurchased*t.costperitem)AS avg_transaction_value
frutos-#  FROM transactions t
frutos-# INNER JOIN customers c
frutos-# on t.userid=c.userid
frutos-# GROUP BY c.customer_segment
frutos-# ORDER BY total_revenue DESC;

Corporate customers represent a very small customer group but generate disproportionately high revenue, suggesting that a limited number of business clients contribute heavily to total sales.

frutos=# SELECT t.userid,
frutos-# t.country,
frutos-# c.customer_segment
frutos-# FROM transactions t
frutos-# LEFT JOIN customers c
frutos-# ON t.userid=c.userid
frutos-# WHERE c.customer_segment IS NULL
frutos-# LIMIT 20;

A large number of transaction records do not have corresponding customer information, which may indicate incomplete customer data, on boarding gaps, or missing CRM mappings

frutos=# SELECT userid,
frutos-# country,
frutos-# (numberofitemspurchased*costperitem) AS transaction_value,
frutos-# CASE
frutos-# WHEN (numberofitemspurchased*costperitem)<100 THEN'Low value'
frutos-# WHEN (numberofitemspurchased*costperitem) BETWEEN 100 AND 1000 THEN 'Medium Value'
frutos-# ELSE 'High Value'
frutos-# END AS transaction_category
frutos-# FROM transactions
frutos-# ORDER BY transaction_value ASC
frutos-# LIMIT 50;

A significant number of transactions have negative values, suggesting the presence of refunds or cancelled orders within the dataset

frutos=# SELECT c.customer_segment,
frutos-# CASE
frutos-# WHEN (t.numberofitemspurchased*t.costperitem)>10000 THEN 'High Risk'
frutos-# WHEN (t.numberofitemspurchased*t.costperitem) BETWEEN 1000 AND 10000 THEN 'Medium Risk'
frutos-# ELSE 'Low Risk'
frutos-# END AS risk_category,
frutos-# COUNT(*) AS total_transactions,
frutos-# SUM(t.numberofitemspurchased*t.costperitem) AS total_revenue
frutos-# FROM transactions t
frutos-# INNER JOIN customers c
frutos-# on t.userid=c.userid
frutos-# GROUP BY c.customer_segment, risk_category
frutos-# ORDER BY total_revenue DESC;

Corporate customers are responsible for the only high-risk transactions identified in the dataset, indicating that a small subset of business-oriented clients generates exceptionally large transaction values


frutos=# WITH transaction_analysis AS(
frutos(# SELECT country,
frutos(# userid,
frutos(# (numberofitemspurchased*costperitem) AS transaction_value,
frutos(# AVG (numberofitemspurchased*costperitem)
frutos(# OVER (PARTITION BY country) AS country_avg_transaction
frutos(# FROM transactions)
frutos-# SELECT country,
frutos-# userid,
frutos-# transaction_value,
frutos-# country_avg_transaction,
frutos-# transaction_value-country_avg_transaction AS difference_from_avg
frutos-# FROM transaction_analysis
frutos-# ORDER BY difference_from_avg DESC
frutos-# LIMIT 20;


Several transactions in the United Kingdom deviate massively from the country’s average transaction value, suggesting the presence of significant outliers, bulk purchases, or potentially anomalous transaction activity


