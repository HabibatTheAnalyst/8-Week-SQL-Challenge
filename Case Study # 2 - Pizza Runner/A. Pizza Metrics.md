# Pizza Metrics Questions

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

# Solution
### SQL Queries

### 1. How many pizzas were ordered?
```sql
SELECT
	COUNT(order_id) TotalPizzaOrdered
FROM customer_orders_temp;
```

***
### 2. How many unique customer orders were made?
```sql
SELECT 
	COUNT(DISTINCT order_id) AS UniqueCustomerOrders
FROM customer_orders_temp;
```

***
### 3. How many successful orders were delivered by each runner?
```sql
SELECT
	 DISTINCT(runner_id)
	,COUNT(order_id) AS OrdersDelivered
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY runner_id;
```

***
### 4. How many of each type of pizza was delivered?
```sql
SELECT
	 pizza_name
	,COUNT(DISTINCT c.order_id) AS total_order
FROM customer_orders_temp AS c
	INNER JOIN runner_orders AS r
	ON c.order_id = r.order_id
	INNER JOIN pizza_names AS p
	ON c.pizza_id = p.pizza_id
WHERE distance IS NOT NULL
GROUP BY p.pizza_name;
```

***
### 5. How many Vegetarian and Meatlovers were ordered by each customer?
```sql
SELECT 
	 DISTINCT(customer_id)
	,pizza_name
	,COUNT(order_id) AS total_order  
FROM customer_orders_temp AS c
	INNER JOIN pizza_names AS p
	ON c.pizza_id = p.pizza_id
GROUP BY customer_id, pizza_name;
```

***
### 6. What was the maximum number of pizzas delivered in a single order?
```sql
WITH cte_max_order
AS
(
	SELECT
		 c.order_id
		,COUNT(c.order_id) AS total_order
	FROM customer_orders_temp AS c
		INNER JOIN runner_orders_temp AS r
		ON c.order_id = r.order_id
	WHERE distance IS NOT NULL
	GROUP BY c.order_id
)
SELECT 
	MAX(total_order) AS max_pizza_delivered
FROM cte_max_order;
```

***
### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```sql
SELECT 
	 customer_id
	,SUM(CASE WHEN exclusions <> 'NULL' OR extras <> 'NULL' THEN 1
			  ELSE 0
		 END) AS at_least_1_change
	,SUM(CASE WHEN exclusions = 'NULL' AND extras = 'NULL' THEN 1
			  ELSE 0
		 END) AS NoChange
FROM customer_orders_temp AS c
INNER JOIN runner_orders_temp AS r
ON c.order_id = r.order_id
WHERE distance != 0	
GROUP BY customer_id;
```

***
### 8. How many pizzas were delivered that had both exclusions and extras?
```sql
SELECT 
	 customer_id
	,COUNT(pizza_id) AS TotalPizza
FROM customer_orders_temp AS c
	INNER JOIN runner_orders_temp AS r
	ON c.order_id = r.order_id
WHERE exclusions IS NOT NULL 
	AND extras IS NOT NULL
	AND distance IS NOT NULL
GROUP BY customer_id;
```

***
### 9. What was the total volume of pizzas ordered for each hour of the day?
```sql
SELECT
	 DATEPART(HOUR, order_time) AS hour_of_day
	,COUNT(order_id) AS TotalPizza
FROM customer_orders_temp
GROUP BY DATEPART(HOUR, order_time);
```

***
### 10. What was the volume of orders for each day of the week?
```sql
WITH cte_week
AS
(
SELECT 
	 DATENAME(WEEKDAY, order_time) AS DaysOfWeek
	,COUNT(order_id) AS TotalOrders
FROM customer_orders_temp
GROUP BY order_time
)
SELECT 
	 DaysOfWeek
	,SUM(TotalOrders) AS TotalOrders
FROM cte_week
GROUP BY DaysOfWeek
ORDER BY TotalOrders DESC;
```