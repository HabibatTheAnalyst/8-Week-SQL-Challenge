# Runner and Customer Experience

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

***
# Solution
### SQL Queries

### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```sql
SELECT 
	 DATEPART(WEEK, registration_date) AS registration_week
	,COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY DATEPART(WEEK, registration_date);
```

***
### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```sql
WITH cte_time_taken
AS 
(
SELECT
	 DISTINCT c.order_id
	,DATEDIFF(minute,order_time, pickup_time) as PickupTime
FROM runner_orders_temp AS r
INNER JOIN customer_orders_temp AS c
ON r.order_id = c.order_id
WHERE distance IS NOT NULL
GROUP BY c.order_id, DATEDIFF(minute,order_time, pickup_time)
)
SELECT
	AVG(PickupTime) AS AvgPickupTime
FROM cte_time_taken;
```

***
### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
```sql
SELECT	    	
	 COUNT(c.pizza_id) AS PizzaCount
	,AVG(DATEDIFF(minute,order_time, pickup_time)) as AverageTime
FROM runner_orders_temp AS r
INNER JOIN customer_orders_temp AS c
ON r.order_id = c.order_id
WHERE distance IS NOT NULL
GROUP BY pickup_time, order_time
ORDER BY PizzaCount DESC;
```
> Yes. As expected, the more the number of pizza ordered the longer it takes to prepare.

***
### 4. What was the average distance travelled for each customer?
```sql
SELECT 
	 customer_id
	,ROUND(AVG(distance),1) AS AverageDistance
FROM runner_orders_temp AS r
INNER JOIN customer_orders_temp AS c
ON r.order_id = c.order_id
GROUP BY customer_id;
```

***
### 5. What was the difference between the longest and shortest delivery times for all orders?
```sql
WITH cte_diff
AS
(
SELECT
	 MAX(duration) AS max_duration
	,MIN(duration) AS min_duration
FROM runner_orders_temp
)
SELECT
	max_duration - min_duration AS TimeDifference
FROM cte_diff;
```

***
### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
```sql
SELECT
	 DISTINCT runner_id
	,order_id
	,ROUND(AVG((distance*60)/duration),1) AverageSpeed_KMH
FROM runner_orders_temp
WHERE distance IS NOT NULL
GROUP BY order_id, runner_id;
```

***
### 7. What is the successful delivery percentage for each runner?
```sql
WITH cte_u
AS
(
SELECT
	 runner_id
	,SUM(CASE WHEN distance IS NOT NULL THEN 1
		  ELSE 0
	 END) AS pass
	,COUNT(order_id) AS Total
FROM runner_orders_temp
WHERE distance IS NOT NULL
GROUP BY runner_id
)
SELECT
	(COUNT(*) * 100) / Total
FROM cte_u
GROUP BY Total;
```