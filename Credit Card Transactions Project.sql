/*
Credit Card Transactions
 Overview: Given dataset contains 4 files (both in csv and excel format) which provides
 information related to the type of card customers have, details about the credit card,
 transactions which are marked as fraudulent and the transactions done by each customer.
 Use this information to better understand the credit card transactions and solve given problems.

*/
select * from Card_base; -- 500 
select * from Customer_base; -- 5674
select * from Fraud_base; -- 109
select * from Transaction_base; -- 10000

--Problem Statements:
-- 1) How many customers have done transactions over 49000?

SELECT COUNT(DISTINCT cust_id) AS no_of_customers
FROM Transaction_base trn
INNER JOIN Card_base crd ON trn.credit_card_id = crd.card_number
WHERE trn.transaction_value > 49000;

-- 2) What kind of customers can get a Premium credit card?

SELECT DISTINCT customer_segment
FROM card_base crd
JOIN customer_base cus
ON crd.cust_id = cus.cust_id
WHERE crd.card_family = 'Premium';

--3) Identify the range of credit limit of customer who have done fraudulent 
--   transactions.

SELECT MIN(crd.credit_limit) AS min_credit_limit,
	   MAX(crd.credit_limit) AS max_credit_limit
FROM Fraud_base fb
INNER JOIN transaction_base trans ON trans.transaction_id = fb.transaction_id
INNER JOIN card_base crd ON crd.card_number = trans.credit_card_id;

--4) What is the average age of customers who are involved in fraud transactions 
--   based on different card type?

SELECT card_family AS card_type, ROUND(AVG(cus.age),0)
FROM Fraud_base fb
INNER JOIN transaction_base trans ON trans.transaction_id = fb.transaction_id
INNER JOIN card_base crd ON crd.card_number = trans.credit_card_id
INNER JOIN customer_base cus ON cus.cust_id = crd.cust_id
GROUP BY crd.card_family;

--5) Identify the month when highest no of fraudulent transactions occured.

SELECT EXTRACT(MONTH FROM transaction_date) AS month,SUM(fraud_flag) AS total_frauds
FROM Fraud_base fb
INNER JOIN transaction_base trans ON trans.transaction_id = fb.transaction_id
GROUP BY month
ORDER BY total_frauds DESC
LIMIT 1;

--Alternate Solution:-

SELECT to_char(transaction_date,'MON') AS mon, COUNT(1) AS no_of_fraud_trns
FROM Transaction_base trn
JOIN Fraud_base frd ON frd.transaction_id=trn.transaction_id
GROUP BY to_char(transaction_date,'MON')
ORDER BY no_of_fraud_trns DESC
LIMIT 1;

--6) Identify the customer who has done the most transaction value without 
--   involving in any fraudulent transactions.

SELECT cst.cust_id, MAX(trn.transaction_value) AS total_trns
FROM Transaction_base trn
JOIN Card_base crd ON trn.credit_card_id = crd.card_number
JOIN customer_base cst ON cst.cust_id=crd.cust_id
WHERE cst.cust_id NOT IN (SELECT crd.cust_id
							FROM Transaction_base trn
							JOIN Fraud_base frd ON frd.transaction_id=trn.transaction_id
							JOIN Card_base crd  ON trn.credit_card_id = crd.card_number)
GROUP BY cst.cust_id
ORDER BY total_trns DESC 
LIMIT 1;


--7) Check and return any customers who have not done a single transaction.

SELECT DISTINCT(cus.cust_id)
FROM customer_base cus
LEFT JOIN card_base crd ON crd.cust_id = cus.cust_id
LEFT JOIN transaction_base trans ON trans.credit_card_id = crd.card_number
WHERE credit_card_id IS NULL;

--Alternate Solution:-

SELECT DISTINCT cust_id 
FROM customer_base cst 
WHERE cst.cust_id NOT IN ( SELECT DISTINCT crd.cust_id
						   FROM Transaction_base trn
						   JOIN Card_base crd 
						   ON trn.credit_card_id = crd.card_number);


--8) What is the highest and lowest credit limit given to each card type?

SELECT card_family,
	   MIN(credit_limit) AS min_credit_limit,
	   MAX(credit_limit) AS max_credit_limit
FROM   card_base
GROUP BY card_family;

--9) What is the total value of transactions done by customers who come under the 
--   age bracket of 21-30 yrs, 30-40 yrs, 40-50 yrs, 50+ yrs and 0-20 yrs.

WITH cte AS(
 SELECT cust_id,
 		CASE WHEN age BETWEEN 0  AND 20 THEN '0-20'
		     WHEN age BETWEEN 21 AND 30 THEN '20-30'
			 WHEN age BETWEEN 31 AND 40 THEN '30-40'
			 WHEN age BETWEEN 41 AND 50 THEN '40-50'
			 WHEN age > 50 THEN '50+'
		ELSE '0'
			 END AS age_category
 FROM Customer_base
)
SELECT age_category,SUM(transaction_value) AS total_transactions
FROM cte cus
INNER JOIN card_base crd ON crd.cust_id = cus.cust_id
INNER JOIN transaction_base trans ON trans.credit_card_id = crd.card_number
GROUP BY age_category
ORDER BY age_category;

--Alternate Solution:-

select sum(case when age > 0 and age <= 20 then transaction_value else 0 end) as trns_value_0_to_20
, sum(case when age > 20 and age <= 30 then transaction_value else 0 end) as trns_value_20_to_30
, sum(case when age > 30 and age <= 40 then transaction_value else 0 end) as trns_value_30_to_40
, sum(case when age > 40 and age <= 50 then transaction_value else 0 end) as trns_value_40_to_50
, sum(case when age > 50 then transaction_value else 0 end) as trns_value_greater_than_50
from Transaction_base trn
join Card_base crd on trn.credit_card_id = crd.card_number
join customer_base cst on cst.cust_id=crd.cust_id;

--10)Which card type has done the most no of transactions and the total highest 
--   value of transactions without having any fraudulent transactions.

SELECT card_family,SUM(transaction_value) AS max_trans,COUNT(transaction_id) AS trns 
FROM card_base crd
JOIN transaction_base trans ON trans.credit_card_id = crd.card_number
WHERE transaction_id NOT IN (SELECT DISTINCT transaction_id
					  		  FROM fraud_base)
GROUP BY card_family
ORDER BY max_trans,trns;


--Alternate Presize Solution:-
		SELECT * FROM (
				SELECT card_family, COUNT(1) AS val, 'Highest number of trns'
				FROM Transaction_base trn
				JOIN Card_base crd ON trn.credit_card_id = crd.card_number
				WHERE transaction_id NOT IN (SELECT DISTINCT transaction_id
					  		                 FROM fraud_base)
				GROUP BY card_family
				ORDER BY val DESC 
				LIMIT 1) x
UNION ALL
		
		SELECT * FROM (
				SELECT card_family, SUM(transaction_value) AS val, 'Highest value of trns'
				FROM Transaction_base trn
				JOIN Card_base crd ON trn.credit_card_id = crd.card_number
				WHERE transaction_id NOT IN (SELECT DISTINCT transaction_id
							  		         FROM fraud_base)
				GROUP BY card_family
				ORDER BY val DESC 
				LIMIT 1) y;


 