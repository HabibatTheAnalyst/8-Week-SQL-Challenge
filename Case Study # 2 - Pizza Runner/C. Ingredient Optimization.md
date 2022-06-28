# Ingredient Optimisation Questions

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
* Meat Lovers
* Meat Lovers - Exclude Beef
* Meat Lovers - Extra Bacon
* Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

***
# Solution
### SQL Queries

### 1. What are the standard ingredients for each pizza?
```sql
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
```

***
### 2. What was the most commonly added extra?
```sql
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
```

***
### 3. What was the most common exclusion?
```sql
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
```

***
### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
* Meat Lovers
* Meat Lovers - Exclude Beef
* Meat Lovers - Extra Bacon
* Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
```sql
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
```