
--============================================================================================
-- 1.1 Top Sales Performers (Employees)
--
-- Business Question: Who are our top 5 employees generating the most sales revenue?
--============================================================================================

-- SANITY CHECK ---------------------------------------------
-- How many sales does employee 529 have?
select
	e.employee_id,
	count
(s.sale_id) 
from employees e
join sales s on e.employee_id = s.employee_id
where e.employee_id = 529
group by e.employee_id;  --> 2 sales

-------------------------------------------------------------

select
    e.first_name || ' ' || e.last_name as "Employee Name",
    '$' || SUM(s.price) AS "Total Sales Revenue",
    count(s.sale_id) as "Number of Sales",
    '$' || cast(AVG(s.price) as decimal(10,2)) as "Average Sale Value"
from employees e
    join sales s on e.employee_id = s.employee_id
GROUP BY "Employee Name", e.employee_id
ORDER BY "Total Sales Revenue" desc
limit 5;

-- OUTPUT:
/*
| Employee Name | Total Sales Revenue | Number of Sales | Average Sale Value |
|---|---|---|---|
| Vassily Handrok | $99289.97 | 2 | $49644.99 |
| Charline Woosnam | $98833.05 | 2 | $49416.53 |
| Roseann Prin | $97349.64 | 1 | $97349.64 |
*/

--============================================================================================
-- 1.2 Top Sales Performers (Dealerships)
--
-- Business Question: Which 5 dealerships generate the most sales income?
--============================================================================================

select
    distinct d.business_name as "Dealership Name",
    d.city || ' ' || d.state as "Location",
    '$' || to_char(sum(s.price) over(partition by d.dealership_id), 'L999,999,990.00') as "Total Sales Revenue",
    count(s.sale_id) over(partition by d.dealership_id ) as "Number of Sales"
from sales s
    join dealerships d on s.dealership_id = d.dealership_id
group by d.business_name, s.sale_id, d.dealership_id
order by "Number of Sales" desc, "Dealership Name";

-- OUTPUT:
/*
| Dealership Name | location | Total Sales Revenue | Number of Sales |
|---|---|---|---|
| Every Autos of North Carolina | Charlotte North Carolina |$ 6,932,559.82 | 120 |
| Caspell Autos of Alabama | Birmingham Alabama	| $ 6,844,921.63 | 117 |
| Hanalan Autos of Louisiana | New Orleans Louisiana | $ 6,807,296.22 | 117 |
*/

--============================================================================================
-- 1.3 Best-Selling Vehicle Models
--
-- Business Question: Which vehicle model generated the most total sales income?
--============================================================================================


-- SANITY CHECKS ----------------------------------------------
select count(s.sale_id)
from sales s
    join vehicletypes vt on s.vehicle_id = vt.vehicle_type_id
where vt.make = 'Ford';
--> 40

select count(s.sale_id)
from sales s
    join vehicletypes vt on s.vehicle_id = vt.vehicle_type_id
where vt.model = 'EcoSport';
--> 5
-------------------------------------------------------------
-- Note that `count(s.price) over (partition by vt.model)` 
-- produces the same result as `count(s.sale_id) over (partition by vt.model)`
-- because there is one vehicle per sale, so counting the price
-- per model is equivalent to counting the sales. For clarity
-- and to prevent a fragile query, we will continue to use `sale_id` for
-- the count.
-------------------------------------------------------------
-- Used two CTEs here for readability but the query could also be written:
/*
select
		distinct vt.model as model,
		count(s.sale_id) over (partition by vt.model) as sales_per_model,
		sum(s.price) over (partition by vt.model) as revenue_per_model
	from sales s
	join vehicletypes vt on s.vehicle_id = vt.vehicle_type_id
	group by vt.model, s.sale_id;
*/
-------------------------------------------------------------

with
    sales_per_model
    as
    (
        select distinct
            vt.make as make,
            vt.model as model,
            count(s.sale_id) over (partition by vt.model) as sales_per_model
        from sales s
            join vehicletypes vt on s.vehicle_id = vt.vehicle_type_id
        group by vt.model, vt.make,s.sale_id
    ),
    revenue_per_model
    as
    (
        select
            distinct vt.model as model,
            '$ ' || round(sum(s.price) over (partition by vt.model), 2) as revenue_per_model,
            '$ ' || round(avg(s.price) over (partition by vt.model), 2) as avg_sale_price
        from sales s
            join vehicletypes vt on s.vehicle_id = vt.vehicle_type_id
        group by vt.model, s.price
    )
select
    spm.make as "Make",
    spm.model as "Model",
    rpm.revenue_per_model as "Total Revenue",
    spm.sales_per_model as "Units Sold",
    rpm.avg_sale_price as "Avg Sale Price"
from sales_per_model spm
    join revenue_per_model rpm on spm.model = rpm.model
group by spm.make, spm.model, rpm.revenue_per_model, spm.sales_per_model, rpm.avg_sale_price;


-- OUTPUT:
/*
| Make | Model | Total Revenue | Units Sold| Avg Sale Price |
|---|---|---|---|---|
| Nissan | Titan |$ 545357.78 | 10 | | $ 54535.78 |
| Volkswagen | Atlas | $ 668524.10 | 10 | $ 66852.41 |
| Mazda | MX-5 Miata | $ 297645.28 | 5 | $ 59529.06 |
*/

--============================================================================================
-- 1.4 Employee Performance by Dealership
--
-- Business Question: Which employees generate the most income per dealership?
--============================================================================================

-- SANITY CHECKS ----------------------------------------------

-- ✅ Did Abbe Rattery sell $182,426.37 at Major Autos of Florida?

select * from employees e where e.last_name = 'Rattery';  --> Abbe Rattery's employee id is 170

select sum(s.price)
from sales s
where s.employee_id = 170;  --> ✅ 182,426.37

-- ❌ Was Abbe Ratter truly the top-earner at Major Autos of Florida?
select distinct
	e.employee_id as id,
	e.first_name || ' ' || e.last_name as name,
	sum(s.price) over (partition by e.employee_id) as revenue
from sales s
join employees e on e.employee_id = s.employee_id
join dealerships d on s.dealership_id = d.dealership_id
where d.business_name = 'Major Autos of Florida'; --> ❌ No, she wasn't; she ranked 20th (out of 21)
---------------------------------------------------------------

with employee_sales_per_dealership as (
select distinct
	d.business_name,
	e.first_name || ' ' || e.last_name as employee_name,
	sum(s.price) over (partition by e.employee_id) as revenue
from sales s
join employees e on e.employee_id = s.employee_id
join dealerships d on s.dealership_id = d.dealership_id
GROUP BY d.business_name, e.employee_id, e.first_name, e.last_name, s.price
)
select distinct
	espd.business_name as "Dealership",
	'$ ' || round(espd.revenue, 2) as "Total Sales Revenue",  -- Opted to name column more precisely as this represents $$ not a count.
	espd.employee_name as "Employee Name",
	rank() over (partition by espd.business_name order by espd.revenue desc) as "Rank at Dealership"
from employee_sales_per_dealership espd
order by business_name, "Rank at Dealership";
-- SANITY CHECKS 👇🏻
-- where espd.business_name = 'McCormack Autos of West Virginia'
--where espd.employee_id = 170


-- OUTPUT:
/*
| Dealership | Employee Name | Total Sales | Rank at Dealership |
|---|---|---|---|
| Alwell Autos of California | $ 518223.73 | Candra Piddock	| 1 |
| Alwell Autos of California | $ 495207.99 | Hewitt Joscelyne |2 |
| Alwell Autos of California | $ 424941.74 | Margaretha Halfpenny | 3 |
 */

---------------
