# Case Study Questions

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

```sql
SELECT customer_id,
       count(DISTINCT order_date) AS visit_count
FROM dannys_diner.sales
GROUP BY customer_id
ORDER BY customer_id;
``` 
1. What is the total amount each customer spent at the restaurant?
```sql
SELECT
		s.customer_id,
		SUM(price) AS TotalAmount
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY customer_id;
```

2. How many days has each customer visited the restaurant?
```sql
SELECT
	   customer_id,
	   COUNT(DISTINCT (order_date)) AS 'Number of Visits'
FROM sales
Group by customer_id;
```

3. What was the first item from the menu purchased by each customer?
```sql
WITH CTE
AS
(
	 SELECT customer_id, order_date, product_name,
	  DENSE_RANK() OVER(PARTITION BY customer_id
	  ORDER BY order_date) AS rank        
	 FROM sales AS s
	 JOIN menu AS m
	  ON s.product_id = m.product_id
)
SELECT customer_id, product_name
FROM CTE
WHERE rank = 1
GROUP BY customer_id, product_name;
```

4. What is the most purchased item on the menu and how many times was it purchased by all customers?
```sql
SELECT TOP 1 (COUNT(s.product_id)) AS most_purchased, product_name
FROM menu AS m
INNER JOIN sales AS s
ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY most_purchased DESC;
```

5. Which item was the most popular for each customer?
```sql
WITH CTE
AS
(
	SELECT s.customer_id, m.product_name, 
			COUNT(m.product_id) AS order_count,
			DENSE_RANK() OVER(PARTITION BY customer_id
			ORDER BY COUNT(s.customer_id) DESC) AS rank
	FROM sales AS s
	INNER JOIN menu AS m
	ON s.product_id = m.product_id
	GROUP BY customer_id, s.product_id, product_name
)
SELECT customer_id, product_name, order_count
FROM CTE 
WHERE rank = 1
GROUP BY customer_id, product_name, order_count;
```

6. Which item was purchased first by the customer after they became a member?
```sql
WITH member_sales_cte AS 
(
 SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
         DENSE_RANK() OVER(PARTITION BY s.customer_id
  ORDER BY s.order_date) AS rank
     FROM sales AS s
 JOIN members AS m
  ON s.customer_id = m.customer_id
 WHERE s.order_date >= m.join_date
)   
SELECT s.customer_id, s.order_date, m2.product_name 
FROM member_sales_cte AS s
JOIN menu AS m2
 ON s.product_id = m2.product_id
WHERE rank = 1;
```

7. Which item was purchased just before the customer became a member?
```sql
WITH cte_before_member
AS
(
SELECT s.customer_id
	,s.product_id
	,order_date
	,join_date
	,DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS Rank
FROM sales AS s
INNER JOIN members AS mb
ON s.customer_id = mb.customer_id
WHERE s.order_date < join_date
)
SELECT c.customer_id
	,product_name
	,order_date
FROM menu AS m
INNER JOIN cte_before_member AS c
ON m.product_id = c.product_id
WHERE Rank = 1;
```

8. What is the total items and amount spent for each member before they became a member?
```sql
SELECT DISTINCT(s.customer_id)
	,COUNT(DISTINCT s.product_id) AS total_item
	,SUM(price) total_price
FROM sales AS s
INNER JOIN members AS mb
ON s.customer_id = mb.customer_id
INNER JOIN menu AS m
ON s.product_id = m.product_id
WHERE order_date < join_date
GROUP BY s.customer_id;
```

9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier � how many points would each customer have?
```sql
WITH cte_points
AS
(
SELECT *,
	CASE
		WHEN product_id = 1 THEN price * 20
		ELSE price * 10 
	END AS points
FROM menu 
)
SELECT
	 customer_id
	,SUM(points) total_points
FROM cte_points AS c
INNER JOIN sales AS s
ON c.product_id = s.product_id
GROUP BY customer_id;
```

10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi � how many points do customer A and B have at the end of January?
```sql
WITH dates_cte 
AS
(
 SELECT *, 
  DATEADD(DAY, 6, join_date) AS valid_date, 
  EOMONTH('2021-01-31') AS last_date
 FROM members AS mb
)
SELECT d.customer_id, s.order_date, d.join_date, 
 d.valid_date, d.last_date, m.product_name, m.price,
 SUM(CASE
  WHEN m.product_name = 'sushi' THEN 2 * 10 * m.price
  WHEN s.order_date BETWEEN d.join_date AND d.valid_date THEN 2 * 10 * m.price
  ELSE 10 * m.price
  END) AS points
FROM dates_cte AS d
JOIN sales AS s
 ON d.customer_id = s.customer_id
JOIN menu AS m
 ON s.product_id = m.product_id
WHERE s.order_date < d.last_date
GROUP BY d.customer_id, s.order_date, d.join_date, d.valid_date, d.last_date, m.product_name, m.price;
```