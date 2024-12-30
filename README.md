# Credit Card Transactions - Data Analysis Project

This project explores a dataset related to credit card transactions, with a focus on identifying customer behavior, fraudulent transactions, and insights into credit card usage patterns. The project involves creating a database, analyzing the data using SQL queries, and answering business-relevant questions.

## Project Overview

The dataset comprises information about:
- Types of credit cards held by customers.
- Details about customer credit limits.
- Transactions, including fraudulent ones.
- Demographic data about customers.

![image](https://files.oaiusercontent.com/file-HrfuVjNfUANyuDoTuWuijG?se=2024-12-30T08%3A18%3A14Z&sp=r&sv=2024-08-04&sr=b&rscc=max-age%3D604800%2C%20immutable%2C%20private&rscd=attachment%3B%20filename%3Da60f9688-abbf-4f97-a0e2-78ea966ea645.webp&sig=m%2BCv3N3jgUR/JoyDq8WYKgHAibSI45EMZjzcUOVMSxk%3D)

The goal of this project is to utilize SQL to solve specific problems and provide actionable insights for stakeholders.

## Problem Statements
The following questions were addressed in this project:

1. **Transaction Threshold**: How many customers have done transactions exceeding $49,000?
2. **Premium Card Criteria**: What type of customers qualify for a Premium credit card?
3. **Fraudulent Transactions**: What is the credit limit range of customers who have made fraudulent transactions?
4. **Fraud Analysis by Age**: What is the average age of customers involved in fraud transactions, segmented by card type?
5. **Fraud Peak Month**: Identify the month with the highest number of fraudulent transactions.
6. **Top Honest Customer**: Which customer has the highest transaction value without any fraudulent transactions?
7. **No Transaction Customers**: Identify customers who haven't made any transactions.
8. **Credit Limits by Card Type**: What are the highest and lowest credit limits for each card type?
9. **Transactions by Age Bracket**: What is the total transaction value for customers in different age brackets (e.g., 0–20, 20–30, etc.)?
10. **Best Performing Card Type**: Which card type has the most transactions and the highest total transaction value without any fraudulent transactions?

## Tools Used
- **SQL**: For database creation and querying.
- **Database Management System**: Compatible with PostgreSQL.
- **Dataset**: Includes four files with details on credit card types, customer transactions, fraud details, and demographics.

## Key Insights and SQL Queries
### Database Creation
The database schema includes multiple tables, such as:
- `credit_cards`: Details about credit card types.
- `customers`: Information about customers.
- `transactions`: Transaction details.
- `fraud_transactions`: Details of fraudulent transactions.

### Example Queries

#### 1. Transaction Threshold
```sql
SELECT COUNT(DISTINCT customer_id) AS High_Value_Customers
FROM transactions
WHERE transaction_value > 49000;
```

#### 2. Premium Card Criteria
```sql
SELECT customer_id, credit_limit
FROM credit_cards
WHERE credit_limit > 50000;
```

#### 3. Fraudulent Transaction Analysis
```sql
SELECT MIN(credit_limit) AS Min_Credit_Limit, MAX(credit_limit) AS Max_Credit_Limit
FROM customers c
JOIN fraud_transactions f
ON c.customer_id = f.customer_id;
```

#### 4. Age Bracket Analysis
```sql
SELECT CASE
           WHEN age BETWEEN 0 AND 20 THEN '0-20'
           WHEN age BETWEEN 21 AND 30 THEN '21-30'
           WHEN age BETWEEN 31 AND 40 THEN '31-40'
           WHEN age BETWEEN 41 AND 50 THEN '41-50'
           ELSE '50+'
       END AS Age_Bracket,
       SUM(transaction_value) AS Total_Transactions
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
GROUP BY Age_Bracket;
```

## How to Run This Project

1. Clone the repository.
   ```bash
   git clone <repository_url>
   ```

2. Set up the database using the `Credit Card Transactions Database Creation.sql` script.

3. Execute the queries in `Credit Card Transactions Project.sql` to analyze the data and solve the problem statements.

4. Review the results and insights.

## Key Learnings
- Advanced SQL techniques for data analysis.
- Fraud detection and customer segmentation using SQL.
- Analyzing large datasets to extract meaningful insights.

## Future Scope
- Integrate the analysis with visualization tools like Tableau or Power BI for better representation.
- Expand the dataset with more attributes for deeper analysis.
- Apply machine learning models to predict fraudulent transactions.
