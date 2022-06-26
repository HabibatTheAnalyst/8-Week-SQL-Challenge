# Bonus Question
Create basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL. 
> A table was given to recreate

***
### Solution
```sql
SELECT customer_id,
       order_date,
       product_name,
       price,
       IF(order_date >= join_date, 'Y', 'N') AS member
FROM members
RIGHT JOIN sales USING (customer_id)
INNER JOIN menu USING (product_id)
ORDER BY customer_id,
         order_date;
```

![image](https://user-images.githubusercontent.com/77529445/167406964-25276db9-fe1c-4608-8b77-b0970b156888.png)
