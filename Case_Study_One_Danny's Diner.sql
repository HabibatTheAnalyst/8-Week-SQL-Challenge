USE SQL_Training
GO     


--- DANNY MA'S SQL EIGHT WEEKS CHALLENGE (CASE STUDY ONE - DANNY'S DINER)
CREATE TABLE sales 
(
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
	  ('A', '2021-01-01', '1'),
	  ('A', '2021-01-01', '2'),
	  ('A', '2021-01-07', '2'),
	  ('A', '2021-01-10', '3'),
	  ('A', '2021-01-11', '3'),
	  ('A', '2021-01-11', '3'),
	  ('B', '2021-01-01', '2'),
	  ('B', '2021-01-02', '2'),
	  ('B', '2021-01-04', '1'),
	  ('B', '2021-01-11', '1'),
	  ('B', '2021-01-16', '3'),
	  ('B', '2021-02-01', '3'),
	  ('C', '2021-01-01', '3'),
	  ('C', '2021-01-01', '3'),
	  ('C', '2021-01-07', '3');




CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  



CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');



--- What is the total amount each customer spent at the restaurant?

SELECT
		s.customer_id,
		SUM(price) AS TotalAmount
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY customer_id;




---How many days has each customer visited the restaurant?

SELECT
	   customer_id,
	   COUNT(DISTINCT (order_date)) AS NumberofVisits
FROM sales
Group by customer_id;




---What was the first item from the menu purchased by each customer?

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



---What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT TOP 1 (COUNT(s.product_id)) AS most_purchased, product_name
FROM menu AS m
INNER JOIN sales AS s
ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY most_purchased DESC;




---Which item was the most popular for each customer?

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




---Which item was purchased first by the customer after they became a member?

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




---Which item was purchased just before the customer became a member?
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




---What is the total items and amount spent for each member before they became a member?

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




---If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?

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




---In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi — how many points do customer A and B have at the end of January?

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
GROUP BY d.customer_id, s.order_date, d.join_date, d.valid_date, d.last_date, m.product_name, m.price