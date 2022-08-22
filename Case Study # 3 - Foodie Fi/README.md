# Case Study Three - Foodie Fi
<img src="https://8weeksqlchallenge.com/images/case-study-designs/3.png" width="300" height="300">

# Table Of Contents
 - [Business Description](#business-description)
 - [Business Problem](#business-problem)
 - [Datasets](#datasets)
 - [Entity Relationship Diagram](#entity-relationship-diagram)

# Business Description
Foodie Fi is a subscription based business and these businesses are super popular. In 2020, Danny finds a few smart friends to launch his new startup "Foodie-Fi" and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world! Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data.

# Business Problem
Danny realised that there was a large gap in the subscription based market so he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows! Hence, this case study focuses on using subscription style digital data to answer important business questions.

# Datasets
Danny has shared the data design for Foodie-Fi and also short descriptions on each of the database tables. These case study focuses on only 2 tables but there will be a challenge to create a new table for the Foodie-Fi team.

The tables are: 
* subscriptions: Customer subscriptions show the exact date where their specific plan_id starts. If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes. When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway. When customers churn - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.

* plans: Customers can choose which plans to join Foodie-Fi when they first sign up. Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90 Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription. Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial. When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

# Case Study Questions
This case study has LOTS of questions. Each of which can be answered using a single SQL statement. They are broken up by area of focus including:

* Data Analysis Questions
* Challenge Payment Question
* Outside The Box Questions

# Entity Relationship Diagram
The diagram below shows the entity relationship between the datasets.

<img src="https://8weeksqlchallenge.com/images/case-study-3-erd.png" width="600" height="300">

Click [here](https://github.com/HabibatTheAnalyst/8-Week-SQL-Challenge/blob/main/Case%20Study%20%23%203%20-%20Foodie%20Fi/A.%20Data%20Analysis%20Questions.md) to view the Data Analysis Solutions!