--============================================================================================
-- 3.1 Highest Average Purchase Price by State
--
-- Business Question: Which U.S. state has customers with the highest average vehicle purchase price?
--============================================================================================

select
    distinct c.state as "State",
    '$ ' || round(avg(s.price) over (partition by c.state), 2) as "Avg Purchase Price",
    count(s.customer_id) over (partition by c.state) as "Customers",
    '$ ' || round(sum(s.price) over(partition by c.state), 2) as "Total Sales Revenue"
from sales s
    join customers c on s.customer_id = c.customer_id
group by c.state, s.customer_id , s.price
order by c.state

-- OUTPUT:
/*
| State | Avg Purchase Price | Customers | Total Sales Revenue |
| AK | $ 64701.68 | 17 | $ 1099928.52 |
| AL | $ 60299.62	112 | $ 6753557.43 |
| AR | $ 53728.26	15 | $ 805923.97 |
 */

--============================================================================================
-- 3.2 Top 5 States by Customer Purchasing Power
--
-- Business Question: Which 5 states have customers with the highest average purchase price?
--============================================================================================

with
    state_purchases
    as
    (
        select
            distinct c.state as "State",
            '$ ' || round(avg(s.price) over (partition by c.state), 2) as "Avg Purchase Price",
            count(s.customer_id) over (partition by c.state) as "Customers",
            '$ ' || round(sum(s.price) over(partition by c.state), 2) as "Total Sales Revenue",
            round(avg(s.price) over (partition by c.state), 2) as state_avg
        from sales s
            join customers c on s.customer_id = c.customer_id
    )
select
    "State",
    "Avg Purchase Price",
    "Customers",
    "Total Sales Revenue",
    rank() over (order by state_avg desc) as "Rank"
from state_purchases
order by "Total Sales Revenue"

-- OUTPUT:
/*
| State | Avg Purchase Price | Customers | Total Sales Revenue | Rank |
|---|---|---|---|---|
| IL | $ 59203.97 | 173 | $ 10242286.27 | 23 |
| AK | $ 64701.68 | 17 | $ 1099928.52 | 5 |
| RI | $ 52823.18 | 23 | $ 1214933.14 | 47 |
 */

--============================================================================================
-- 3.3 Repeat Customers
--
-- Business Question: Which customers have purchased multiple vehicles? Who are our most loyal customers?
--============================================================================================

select
    c.customer_id,
    count(s.vehicle_id) over (partition by c.customer_id) as vehicles_per_customer
from customers c
    join sales s on c.customer_id = s.customer_id

-- OUTPUT:
/*
 
 */
--============================================================================================
-- 3.4 Customer Lifetime Value Analysis
--
-- Business Question: Calculate customer lifetime value and identify high-value customer segments.
--============================================================================================

-- OUTPUT:
/*
 
 */

