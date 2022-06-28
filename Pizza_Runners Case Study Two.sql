USE SQL_Training
GO                           


--- DANNY MA'S SQL EIGHT WEEKS CHALLENGE (CASE STUDY TWO - PIZZA RUNNER)

--- Creating tables
--- Runners table
CREATE TABLE runners (
	"runner_id" INT, 
	"registration_date" DATE
);

INSERT INTO runners (runner_id, registration_date)
VALUES 
		(1, '2021-01-01'),
		(2, '2021-01-03'),
		(3, '2021-01-08'),
		(4, '2021-01-15');



--- Customer_orders table
CREATE TABLE customer_orders (
	"order_id" INT,
	"customer_id" INT,
	"pizza_id" INT,
	"exclusions" VARCHAR(4),
	"extras" VARCHAR(4),
	"order_time" DATETIME
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');     




--- Runner_orders table
  CREATE TABLE runner_orders (
	"order_id" INT,
	"runner_id" INT,
	"pickup_time" VARCHAR(19),
	"distance" VARCHAR(7),
	"duration" VARCHAR(10),
	"cancellation" VARCHAR(23)
);

INSERT INTO runner_orders 
	("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
	('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
	('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
	('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
	('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
	('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
	('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
	('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
	('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
	('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
	('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');



--- Pizza_names table
CREATE TABLE pizza_names (
	"pizza_id" INT,
	"pizza_name" VARCHAR(11)
);

INSERT INTO pizza_names
	(pizza_id, pizza_name)
VALUES
	(1, 'Meat Lovers'),
	(2, 'Vegetarian');


--- Pizza_recipes table
CREATE TABLE pizza_recipes(
	"pizza_id" INT,
	"toppings" VARCHAR(23)
);

INSERT INTO pizza_recipes
	(pizza_id, toppings)
VALUES
	(1, '1, 2, 3, 4, 5, 6, 8, 10'),
	(2,	'4, 6, 7, 9, 11, 12');



--- Pizza_toppings table
CREATE TABLE pizza_toppings (
	"topping_id" INT,
	"topping_name" VARCHAR(12)
);

INSERT INTO pizza_toppings
	(topping_id, topping_name)
VALUES
	(1,	'Bacon'),
	(2,	'BBQ Sauce'),
	(3,	'Beef'),
	(4,	'Cheese'),
	(5,	'Chicken'),
	(6,	'Mushrooms'),
	(7,	'Onions'),
	(8,	'Pepperoni'),
	(9,	'Peppers'),
	(10, 'Salami'),
	(11, 'Tomatoes'),
	(12, 'Tomato Sauce');


								--- CLEANING CUSTOMER_ORDERS, RUNNER_ORDERS TABLES AND PIZZA RECIPES ---

SELECT * FROM customer_orders;
SELECT * FROM runner_orders;
SELECT * FROM customer_orders_temp;
SELECT * FROM runner_orders_temp;

								--- CUSTOMER_ORDERS TABLE ---

--- creating temporary table
SELECT
	 order_id
	,customer_id
	,pizza_id
	,exclusions
	,extras
	,order_time
INTO customer_orders_temp
FROM customer_orders;

--- updating temporary table by replacing empty columns and 'null' with NULL in exclusions
UPDATE customer_orders_temp
SET exclusions = NULL
WHERE exclusions = ''
OR exclusions = 'null';

--- updating temporary table by replacing empty columns and 'null' with NULL in extras
UPDATE customer_orders_temp
SET extras = NULL
WHERE extras = ''
OR extras = 'null';  


								--- RUNNER_ORDERS TABLE ---

--- creating temporary table
SELECT 
	 order_id
	,runner_id
	,pickup_time
		,CASE WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
			  ELSE distance
		 END AS distance
		,CASE WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)
			  WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration)
			  WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)
			  ELSE duration
		 END AS duration
	,cancellation
INTO runner_orders_temp
FROM runner_orders;

--- updating temporary table by replacing 'null' with NULL in pickup_time, distance, and duration.
UPDATE runner_orders_temp
SET pickup_time = NULL,
	distance = NULL,
	duration = NULL
WHERE pickup_time = 'null';

--- updating temporary table by replacing empty column and 'null' with NULL in cancellation.
UPDATE runner_orders_temp
SET cancellation = NULL
WHERE cancellation = ''
OR cancellation = 'null';

--- alter tables to change datatypes
ALTER TABLE runner_orders_temp ALTER COLUMN pickup_time DATETIME;
ALTER TABLE runner_orders_temp ALTER COLUMN distance FLOAT;
ALTER TABLE runner_orders_temp ALTER COLUMN duration INT;



								--- PIZZA RECIPES ---
--- creating new table
CREATE TABLE pizza_recipes_1 (
	 pizza_id INT
	,topping_id INT)

INSERT INTO pizza_recipes_1   
VALUES 
	 (1, 1)
	,(1, 2)
	,(1, 3)
	,(1, 4)
	,(1, 5)
	,(1, 6)
	,(1, 8)
	,(1, 10)
	,(2, 4)
	,(2, 6)
	,(2, 7)
	,(2, 9)
	,(2, 11)
	,(2, 12);
	    




										--- (A) PIZZA METRICS ---

--- How many pizzas were ordered?
SELECT
	COUNT(order_id) TotalPizzaOrdered
FROM customer_orders_temp;


--- How many unique customer orders were made?
SELECT 
	COUNT(DISTINCT order_id) AS UniqueCustomerOrders
FROM customer_orders_temp;


--- How many successful orders were delivered by each runner?
SELECT
	 DISTINCT(runner_id)
	,COUNT(order_id) AS OrdersDelivered
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY runner_id;


--- How many of each type of pizza was delivered? 
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


--- How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
	 DISTINCT(customer_id)
	,pizza_name
	,COUNT(order_id) AS total_order  
FROM customer_orders_temp AS c
	INNER JOIN pizza_names AS p
	ON c.pizza_id = p.pizza_id
GROUP BY customer_id, pizza_name;


--- What was the maximum number of pizzas delivered in a single order?
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


--- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
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


--- How many pizzas were delivered that had both exclusions and extras?
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


--- What was the total volume of pizzas ordered for each hour of the day?
SELECT
	 DATEPART(HOUR, order_time) AS hour_of_day
	,COUNT(order_id) AS TotalPizza
FROM customer_orders_temp
GROUP BY DATEPART(HOUR, order_time);


--- What was the volume of orders for each day of the week?
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





										--- (B) RUNNER AND CUSTOMER EXPERINCE ---

---How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
	 DATEPART(WEEK, registration_date) AS registration_week
	,COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY DATEPART(WEEK, registration_date);


---What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
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


---Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT	    	--- Yes. As expected, the more the number of pizza ordered the longer the order takes to prepare
	 COUNT(c.pizza_id) AS PizzaCount
	,AVG(DATEDIFF(minute,order_time, pickup_time)) as AverageTime
FROM runner_orders_temp AS r
INNER JOIN customer_orders_temp AS c
ON r.order_id = c.order_id
WHERE distance IS NOT NULL
GROUP BY pickup_time, order_time
ORDER BY PizzaCount DESC;


---What was the average distance travelled for each customer?
SELECT 
	 customer_id
	,ROUND(AVG(distance),1) AS AverageDistance
FROM runner_orders_temp AS r
INNER JOIN customer_orders_temp AS c
ON r.order_id = c.order_id
GROUP BY customer_id;


---What was the difference between the longest and shortest delivery times for all orders?
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


---What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT
	 DISTINCT runner_id
	,order_id
	,ROUND(AVG((distance*60)/duration),1) AverageSpeed_KMH
FROM runner_orders_temp
WHERE distance IS NOT NULL
GROUP BY order_id, runner_id;


---What is the successful delivery percentage for each runner?
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




										--- (C) INGREDIENT OPTIMIZATION ---
              
--- What are the standard ingredients for each pizza?    
WITH cte_ingredients
AS
(
SELECT 
	 DISTINCT(pn.pizza_id)
	,pt.topping_id
	,topping_name
	,pizza_name
FROM pizza_recipes_1 AS pr
	INNER JOIN pizza_names AS pn
	ON pn.pizza_id = pr.pizza_id
	INNER JOIN pizza_toppings AS pt
	ON pr.topping_id = pt.topping_id 
)
SELECT 
	 pizza_name
	,STRING_AGG(topping_name, ',') AS standard_ingredients
FROM cte_ingredients
WHERE topping_id NOT IN (4, 6)
GROUP BY pizza_name;
  
      
--- What was the most commonly added extra?                                             	   
WITH cte_extras
AS
(
SELECT 
	 extras
	,COUNT(extras) AS added_times
FROM customer_orders_temp AS c
WHERE extras IS NOT NULL
GROUP BY extras
)
SELECT
	 extras
FROM cte_extras
WHERE added_times > 1;   


--- What was the most common exclusion?
WITH cte_exclusion
AS
(
SELECT 
	 exclusions
	,COUNT(exclusions) AS added_times
FROM customer_orders_temp AS c
WHERE exclusions IS NOT NULL
GROUP BY exclusions
)
SELECT
	 exclusions
FROM cte_exclusion
WHERE added_times > 1;


--- Generate an order item for each record in the customers_orders table in the format of one of the following:
--- * Meat Lovers
--- * Meat Lovers - Exclude Beef
--- * Meat Lovers - Extra Bacon
--- * Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
WITH order_summary_cte AS
  (SELECT pizza_name,
          row_num,
          order_id,
          customer_id,
          excluded_topping,
          t2.topping_name AS extras_topping
   FROM
     (SELECT *,
             topping_name AS excluded_topping
      FROM row_split_customer_orders_temp
      LEFT JOIN standard_ingredients USING (pizza_id)
      LEFT JOIN pizza_toppings ON topping_id = exclusions) t1
   LEFT JOIN pizza_toppings t2 ON t2.topping_id = extras)
SELECT order_id,
       customer_id,
       CASE
           WHEN excluded_topping IS NULL
                AND extras_topping IS NULL THEN pizza_name
           WHEN extras_topping IS NULL
                AND excluded_topping IS NOT NULL THEN concat(pizza_name, ' - Exclude ', GROUP_CONCAT(DISTINCT excluded_topping))
           WHEN excluded_topping IS NULL
                AND extras_topping IS NOT NULL THEN concat(pizza_name, ' - Include ', GROUP_CONCAT(DISTINCT extras_topping))
           ELSE concat(pizza_name, ' - Include ', GROUP_CONCAT(DISTINCT extras_topping), ' - Exclude ', GROUP_CONCAT(DISTINCT excluded_topping))
       END AS order_item
FROM order_summary_cte
GROUP BY row_num;


										--- (D) Pricing and Ratings ---

SELECT * FROM customer_orders_temp;   
SELECT * FROM runner_orders_temp;
SELECT * FROM pizza_recipes_1;   
SELECT * FROM pizza_toppings;       
SELECT * FROM pizza_recipes;   
SELECT * FROM pizza_names;
SELECT * FROM runners;      

