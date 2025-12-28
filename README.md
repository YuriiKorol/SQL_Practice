# SQL Data Analysis

This repository contains SQL queries created during hands-on practice and self-learning.
The focus is on data analysis using relational databases and solving analytical problems.

## Scope
- JOINs
- JOINs on aggregated tables
- GROUP BY
- Subqueries (including correlated subqueries)
- Common Table Expressions (CTEs), including multi-level CTEs
- Window functions
- Practical analytical cases (segmentation, seasonality analysis)
- [customer_spending_analysis.sql](./customer_spending_analysis.sql)
     Practical case: Customer spending vs category average
    - Calculated total spending per customer per category
    - Computed category average spending
    - Determined % difference from average
    - Displayed only customers who spent above the category average
    - Demonstrates CTEs, JOINs, aggregation, and business logic

## Database
Test relational database.
The repository includes database schema (DDL) without real data.

## Purpose
- Practice analytical SQL queries
- Find optimal and simple solutions to analytical problems
- Focus on clarity, performance, and correctness rather than overengineering
- Develop a deep understanding of data and query logic

## Database Description
This database represents a simple online shop system. It contains information about customers (people), products (shop), product categories (categories), and orders (orders).
The database supports queries for customer behavior, product availability, and sales analytics.
