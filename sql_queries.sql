
—-Display first 5 transactions
SELECT *
FROM transactions
LIMIT 5;

—Count total transactions
SELECT COUNT(*) 
FROM transactions;

—-Revenue by country
SELECT COUNTRY,
SUM(numberOfitemsPurchased*costperitem) AS total_revenue
FROM transactions
GROUP BY country
ORDER BY total_revenue DESC;

Revenue Insights:
United Kingdom generates the highest revenue by far.
European countries dominate total sales revenue.

SELECT itemdescription,
SUM(numberofitemspurchased)AS total_items_sold
FROM transactions
GROUP BY itemdescription
ORDER BY total_items_sold DESC
LIMIT 10;

Business Insight:
The most sold product is
World war 2 gliders ASST DESIGNS

Several decorative and gift-related items dominate sales volume,
Suggesting strong demand for home and novelty products.

SELECT country,
COUNT(*) AS total_transactions
FROM transactions
GROUP BY country
ORDER BY total_transactions DESC
LIMIT 10;

Business Insight:
The United Kingdom generates the highest transaction volume by far.
The Netherlands generate high revenue with less transactions  4742, which may indicate higher average order value


Customer behavior Insights:
SELECT country,
SUM(numberofitemspurchased*costperitem)/ COUNT(*) AS avg_revenue_per_transaction
FROM transactions
GROUP BY country
ORDER BY avg_revenue_per_transaction DESC
LIMIT 10;

Netherlands has a higher average transaction value
This could indicate:
-higher priced products
-Bulk purchases
-larger basket sizes
-business/commercial customers

SELECT userid,
 SUM(numberofitemspurchased*costperitem) AS total_customer_revenue
FROM transactions
GROUP BY userid
ORDER BY total_customer_revenue DESC
LIMIT 10;

Business insight:
A small number of customers generate a disproportionately high share of total revenue.
This may indicate the presence of high-value commercial customers or bulk purchasing behavior.
One customer ID(-1) appears among the top revenue generators, which may indicate missing customer information, anonymous transactions, or a potential data quality issue.

SELECT userid,
itemdescription,
numberofitemspurchased,
costperitem,
(numberofitemspurchased*costperitem)AS transaction_value
FROM transactions
ORDER BY transaction_value DESC
 LIMIT 10;

Several transactions contain unusually high transaction values, particularly for low-value retail products such as lamps.
This may indicate data quality issues, pricing anomalies, or erroneous transaction records.

WITH ranked_customers AS(
SELECT country,
userid,
SUM(numberofitemspurchased*costperitem) AS total_revenue,
RANK() OVER(
PARTITION BY country
ORDER BY SUM(numberofitemspurchased*costperitem) DESC) AS revenue_rank
FROM transactions
GROUP BY country, userid)
SELECT country,
userid,
total_revenue,
revenue_rank
FROM ranked_customers
WHERE revenue_rank <=3
ORDER BY country, revenue_rank;

For each country show the top 3 customers by total revenue

Ex

Australia            | 260715 |     1026822.9000000007 |            1
 Australia            | 261051 |     45170.519999999975 |            2
 Australia            | 260148 |      23074.37999999999 |            3

Some countries contain unusually high-revenue customers, which may represent commercial buyers, bulk purchasing activity, or potential anomalies requiring further investigation.

SELECT country,
AVG(numberofitemspurchased) AS avg_quantity_purchased
FROM transactions
GROUP BY country
ORDER BY avg_quantity_purchased DESC
LIMIT 10;

Counties such as the Netherlands, Sweden, and Japan show significantly higher average purchase quantities, which may indicate bulk purchasing behavior or a stronger presence of commercial customers

SELECT itemdescription,
SUM (numberofitemspurchased*costperitem) AS total_product_revenue
FROM transactions
GROUP BY itemdescription
ORDER BY total_product_revenue DESC
LIMIT 10;

Operational Insights:
A small number of products generate disproportionally high revenue, with certain items such as RETROSPOT LAMP showing unusually large transaction values that may indicate  pricing anomalies or data quality issues

Which countries generate the highest average revenue per custo,er+

SELECT country,
SUM(numberofitemspurchased*costperitem)/COUNT(DISTINCT userid) AS avg_revenue_per_customer
FROM transactions
GROUP BY country
ORDER BY avg_revenue_per_customer DESC
LIMIT 10;

Countries such as EIRE and the Netherlands generate significantly higher average rev by customer, suggesting the presence of high-value customers or stronger purchasing behavior in these markets.

WITH customer_revenue AS(
SELECT country,
userid,
SUM(numberofitemspurchased*costperitem) AS total_revenue
FROM transactions
GROUP BY country,userid
frutos(# )
SELECT country,
userid,
total_revenue,
AVG(total_revenue)OVER(
PARTITION BY country
AS country_avg_revenue
FROM customer_revenue
ORDER BY total_revenue DESC
LIMIT 20;

Some customers generate revenue far above their country average, indicating strong customer concentration and potential high-value or anomalous purchasing behavior

Risk/anomaly Insight:

SELECT userid,
country,
 itemdescription,
 numberofitemspurchased,
costperitem,
 (numberofitemspurchased*costperitem) AS transaction_value
 FROM transactions
WHERE (numberofitemspurchased*costperitem)>100000
ORDER BY transaction_value DESC
LIMIT 20;


Several transactions contain unusually high purchase quantities and transaction values, particularly in the United Kingdom which might indicate bulk purchases, data quality issues or potentially anomalies requiring further investigation



# CREATE TABLE customers(
(# userid INT,
(# customer_segment TEXT
(# );
CREATE TABLE
INSERT INTO customers VALUES
(278166,'Retail'),
(337701,'Corporate'),
(267099,'Small Business'),
 (380478,'VIP'),
(288687,'Corporate');
INSERT 0 5


SELECT t.userid,
 t.country,
c.customer_segment,
SUM(t.numberofitemspurchased*t.costperitem) AS total_revenue
 FROM transactions t
INNER JOIN customers c
on t.userid=c.userid
GROUP BY t.userid,t.country,c.customer_segment
ORDER BY total_revenue DESC;


Corporate customers generate significantly higher revenue compared to other business segments, suggesting that business-oriented clients contribute a major sales of total shares


SELECT c.customer_segment,
COUNT(DISTINCT t.userid) AS total_customers,
SUM(t.numberofitemspurchased*t.costperitem)AS total_revenue,
AVG(t.numberofitemspurchased*t.costperitem)AS avg_transaction_value
 FROM transactions t
INNER JOIN customers c
on t.userid=c.userid
GROUP BY c.customer_segment
ORDER BY total_revenue DESC;

Corporate customers represent a very small customer group but generate disproportionately high revenue, suggesting that a limited number of business clients contribute heavily to total sales.

SELECT t.userid,
t.country,
c.customer_segment
 FROM transactions t
LEFT JOIN customers c
ON t.userid=c.userid
WHERE c.customer_segment IS NULL
 LIMIT 20;

A large number of transaction records do not have corresponding customer information, which may indicate incomplete customer data, on boarding gaps, or missing CRM mappings

SELECT userid,
country,
(numberofitemspurchased*costperitem) AS transaction_value,
CASE
WHEN (numberofitemspurchased*costperitem)<100 THEN'Low value'
WHEN (numberofitemspurchased*costperitem) BETWEEN 100 AND 1000 THEN 'Medium Value'
ELSE 'High Value'
END AS transaction_category
FROM transactions
ORDER BY transaction_value ASC
LIMIT 50;

A significant number of transactions have negative values, suggesting the presence of refunds or cancelled orders within the dataset

SELECT c.customer_segment,
CASE
WHEN (t.numberofitemspurchased*t.costperitem)>10000 THEN 'High Risk'
 WHEN (t.numberofitemspurchased*t.costperitem) BETWEEN 1000 AND 10000 THEN 'Medium Risk'
ELSE 'Low Risk'
END AS risk_category,
COUNT(*) AS total_transactions,
SUM(t.numberofitemspurchased*t.costperitem) AS total_revenue
FROM transactions t
INNER JOIN customers c
on t.userid=c.userid
GROUP BY c.customer_segment, risk_category
ORDER BY total_revenue DESC;

Corporate customers are responsible for the only high-risk transactions identified in the dataset, indicating that a small subset of business-oriented clients generates exceptionally large transaction values


WITH transaction_analysis AS(
SELECT country,
userid,
(numberofitemspurchased*costperitem) AS transaction_value,
AVG (numberofitemspurchased*costperitem)
OVER (PARTITION BY country) AS country_avg_transaction
FROM transactions)
SELECT country,
userid,
transaction_value,
 country_avg_transaction,
transaction_value-country_avg_transaction AS difference_from_avg
FROM transaction_analysis
ORDER BY difference_from_avg DESC
LIMIT 20;


Several transactions in the United Kingdom deviate massively from the country’s average transaction value, suggesting the presence of significant outliers, bulk purchases, or potentially anomalous transaction activity


