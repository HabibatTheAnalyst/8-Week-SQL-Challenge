# Case Study Two - Pizza Runner
<img src="https://user-images.githubusercontent.com/93320956/159271900-b007d9a9-8732-4e47-be7c-c46ae3f209bf.png" width="300" height="300">

# Table Of Contents
 - [Business Description](#business-description)
 - [Business Problem](#business-problem)
 - [Datasets](#datasets)
 - [Entity Relationship Diagram](#entity-relationship-diagram)

# Business Description
Danny's Pizza Empire was born from his numerous scrolls on instagram. During one of his numerous scrolls “80s Retro Styling and Pizza Is The Future!” caught his eye. But he knew pizza alone was not going to help him get seed funding to expand his new Pizza Empire. He decided to combine that with delivery and so Pizza Runner was launched!

# Business Problem
Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth. He prepared an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

# Datasets
In this case study, six datasets were presented by Danny to solve the business challenge. The datasets are: 
* runners: The runners table shows the registration_date for each new runner
* customer_orders: The customer_orders table captures the customer pizza orders with 1 row for each individual pizza that is part of the order. The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.
* runner_orders: After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer. The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.
* pizza_names: Name of available pizzas - the Meat Lovers or Vegetarian.
* pizza_recipes: Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.
* pizza_toppings: This table contains all of the topping_name values with their corresponding topping_id value.

# Entity Relationship Diagram
The diagram below shows the entity relationship between the datasets.

<img src="https://user-images.githubusercontent.com/93320956/162197770-f5435f23-07b5-4389-8de5-c67892b02bb9.png" width="600" height="300">

Click [here](https://github.com/HabibatTheAnalyst/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%202%20-%20Pizza%20Runner/A.%20Pizza%20Metrics) to view the pizza metrics solution!