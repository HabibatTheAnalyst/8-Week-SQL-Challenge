# Data Analysis Questions

1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

# Solution
### SQL Queries

### 1. How many customers has Foodie-Fi ever had?
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions;
```

***
### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
```sql
SELECT 
	 plan_name           
	,DATENAME(month, start_date) AS month
	,COUNT(plan_name) AS total_trial_plans
FROM plans AS p     
INNER JOIN subscriptions as s
ON p.plan_id = s.plan_id
WHERE plan_name = 'trial'
GROUP BY plan_name, DATENAME(month, start_date)
ORDER BY total_trial_plans DESC;
```

***
### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
```sql
SELECT 
	 plan_name 
	,COUNT(plan_name) AS total_plans
	,DATEPART(YEAR, start_date) AS year
FROM plans AS p
INNER JOIN subscriptions AS s
ON p.plan_id = s.plan_id     
WHERE DATEPART(YEAR, start_date) > 2020
GROUP BY plan_name, DATEPART(YEAR, start_date)
ORDER BY total_plans DESC;         
```

***
### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
```sql
SELECT 
	 plan_name 
	,COUNT(DISTINCT customer_id) as churned_customers
    ,CAST(100 * COUNT(DISTINCT customer_id) / (
			SELECT COUNT(DISTINCT customer_id)
			FROM subscriptions) AS NUMERIC(4,1)) --- round to 1 decimal place
			AS percentage_churned
FROM subscriptions AS s
INNER JOIN plans AS p 
ON s.plan_id = p.plan_id
WHERE s.plan_id = 4
GROUP BY plan_name;
```

***
### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
```sql
WITH cte_churn_trial 
AS
(
SELECT *
	,LEAD(plan_id, 1) OVER(PARTITION BY customer_id
                      ORDER BY start_date) AS next_plan
FROM subscriptions),
     churners AS
	   (SELECT *
	    FROM cte_churn_trial
	    WHERE next_plan=4
	    AND plan_id=0)
SELECT  COUNT(customer_id) AS 'churn after trial count'
       ,100 * COUNT(customer_id) / (SELECT COUNT(DISTINCT customer_id) AS 'distinct customers'
        FROM subscriptions) AS 'churn percentage'
FROM churners;
```

***
### 6. What is the number and percentage of customer plans after their initial free trial?
```sql
SELECT 
	 plan_name
	,COUNT(DISTINCT customer_id) as 'total return customers'
    ,CAST(100 * COUNT(DISTINCT customer_id) / (
			SELECT COUNT(DISTINCT customer_id)
			FROM subscriptions) AS NUMERIC(4,1)) --- to round to 1 decimal place
			 AS 'percentage return'
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE plan_name != 'trial'
GROUP BY plan_name
ORDER BY 'percentage return' DESC;
```

***
### 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
```sql
SELECT 
	 plan_name
	,COUNT(DISTINCT customer_id) as 'total customers'
    ,CAST(100 * COUNT(DISTINCT customer_id) / (
			SELECT COUNT(DISTINCT customer_id)
			FROM subscriptions) AS NUMERIC(4,1))
			 AS 'percentage breakdown'
FROM subscriptions AS s
INNER JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE start_date = '2020-12-31'
GROUP BY plan_name
ORDER BY 'percentage breakdown' DESC;
```

***
### 8. How many customers have upgraded to an annual plan in 2020?
```sql
SELECT
	 plan_name
	,COUNT(DISTINCT customer_id) '2020 annual plans'
FROM plans AS p
INNER JOIN subscriptions AS s
ON p.plan_id = s.plan_id
WHERE YEAR(start_date) = '2020'
AND s.plan_id = 3
GROUP BY plan_name;
```

***
### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
```sql
WITH avg_cte
AS
((
	SELECT *
	FROM subscriptions AS s
	INNER JOIN plans AS p
	ON s.plan_id = p.plan_id
	WHERE s.plan_id = 0)), AS first_
(	
	SELECT *
	FROM subscriptions AS s
	INNER JOIN plans AS p
	ON s.plan_id = p.plan_id
	WHERE s.plan_id = 3)

SELECT 
	AVG(DATEDIFF(avg_cte, first_))
	FROM avg_cte AS a
	INNER subscription AS s
	ON a.customer_id = s.customer_id;
```

***
### 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)


***
### 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
```sql
WITH cte_next
AS
(
SELECT *
	,LEAD(plan_id,1) OVER(PARTITION BY customer_id
					 ORDER BY start_date) AS next_plan
FROM subscriptions)
SELECT COUNT(*) AS 'downgrade count'
FROM cte_next
WHERE plan_id = 2
AND next_plan=1
AND year(start_date) = 2020;
```