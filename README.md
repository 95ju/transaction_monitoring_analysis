# Transaction Monitoring & Revenue Analysis Project

## Project Overview
This project analyzes retail transaction data to identify revenue trends, refund activity, customer behavior, product concentration, and potential transaction anomalies.

The goal is to demonstrate an end-to-end data analyst workflow using Python, pandas, SQL/PostgreSQL, and business insight generation.

## Tools Used
- Python
- pandas
- PostgreSQL
- SQL
- Google Colab / Jupyter Notebook
- GitHub

## Key Analyses
- Data cleaning and missing value checks
- KPI calculation
- Revenue by country
- Product revenue analysis
- Refund and negative transaction analysis
- Customer revenue analysis
- SQL joins and customer segmentation
- CTEs and window functions
- Transaction anomaly detection

## Key Business Insights
- The United Kingdom generated the highest transaction volume and revenue.
- Some countries, such as the Netherlands, showed higher average transaction values, suggesting bulk purchasing or higher-value orders.
- A small number of products and customers contributed disproportionately to total revenue.
- Several transactions showed unusually high values compared to country averages, suggesting potential anomalies or data quality issues.
- Negative transaction values likely represent refunds, cancellations, or returns.

## SQL Highlights
The SQL analysis includes:
- Aggregations with `GROUP BY`
- Customer and country-level KPIs
- `INNER JOIN` and `LEFT JOIN`
- `CASE WHEN` categorization
- CTEs
- Window functions such as `RANK()` and `AVG() OVER()`

## Future Improvements
- Build an interactive Power BI dashboard
- Improve visual storytelling with dashboard screenshots
