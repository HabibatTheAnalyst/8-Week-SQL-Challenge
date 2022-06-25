# Case Study One - Danny's Diner
<img src="https://user-images.githubusercontent.com/93320956/159065921-fcf15796-6de1-4054-a964-de6dc425f994.png" width="300" height="300">

# Table Of Contents
 - [Business Description](#business-description)
 - [Business Problem](#business-problem)
 - [Datasets](#datasets)
 - [Entity Relationship Diagram](#entity-relationship-diagram)
 - [Case Study Questions](#case-study-questions)

# Business Description
Danny's Diner is a Japanese restaurant that sells Danny's favourite foods: sushi, curry and ramen.

# Business Problem
The restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business. These data are to be used to answer questions about Danny's custmers especially about their visiting patterns, how much money they’ve spent and also which menu items are their favour. 
U
This understanding will help him deliver and keep up with customers demands. To help with this, by keeping the business afloat, I need to provide answers to Danny's business questions.

# Datasets
In this case study, three key datasets were presented by Danny to solve the business challenge.
The datasets are: sales, menu, and members.

* ### sales:
The sales table captures all "customer_id" level purchases with an corresponding "order_date" and "product_id" information for when and what menu items were ordered.

* ### menu:
The menu table maps the product_id to the actual product_name and price of each menu item.

* ### members:
The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.

# Entity Relationship Diagram
The diagram below shows the entity relationship between the datasets.

<img src="https://user-images.githubusercontent.com/93320956/159158168-fc3f4618-be4d-49cd-a0d8-80a181bcb067.png" width="600" height="300">

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