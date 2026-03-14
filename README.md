# Team Project: Carnival Reporting Challenge

## Overview

Your team has successfully designed the Carnival database (or inherited a well-designed one). Now Carnival's business leadership needs insights! The executive team, sales managers, and operations directors are asking for comprehensive reports to make data-driven decisions about the dealership business.

This collaborative project challenges your team to translate business questions into complex SQL queries, optimize report performance, and present actionable insights to stakeholders.

## Learning Objectives

By completing this team project, you will:
- **Collaborate** on complex query development with teammates
- **Apply** advanced SQL techniques: joins, aggregation, subqueries, CTEs, and window functions
- **Translate** business questions into technical SQL queries
- **Optimize** query performance for real-world reporting needs
- **Present** data-driven insights to business stakeholders
- **Practice** code review and collaborative problem-solving

## Project Context

### The Carnival Business Challenge

Carnival has grown significantly! The leadership team is now data-driven and making critical business decisions based on analytics. They've hired top-notch business analysts and product managers who need YOU to create sophisticated reports about:

- **Sales Performance:** Who are the top performers? Which vehicles sell best?
- **Inventory Management:** What's in stock? What's moving slowly?
- **Employee Recognition:** Which employees generate the most revenue?
- **Customer Intelligence:** Who are the highest-value customers? Where are they located?
- **Dealership Performance:** Which locations are most profitable?
- **Trend Analysis:** How do sales patterns change over time?

### Your Database

You should now have the Carnival database populated with data:
- The ERD you designed in Class 4 (or a provided schema)
- Imported data from CSV files
- All relationships properly established with foreign keys

**If you don't have a complete Carnival database yet, your instructor will provide a populated database to use for this project.**

## Deliverables

Your team must deliver:

1. **SQL Query Portfolio** (shared GitHub repo or document)
   - All queries formatted and documented
   - Comments explaining logic
   - Sample output for each query

2. **Business Insights Report** (Google Slides, PowerPoint, or PDF)
   - Answers to all required business questions
   - Visualizations or formatted results
   - Key findings highlighted
   - Actionable recommendations

3. **Team Presentation** (15-20 minutes)
   - Present key findings to class (your "stakeholders")
   - Demonstrate 2-3 most complex queries
   - Share insights and recommendations
   - Discuss technical challenges overcome

## Required Reports

Your team must complete **all required reports** in Sections 1-4. Section 5 contains optional bonus reports for teams that want an extra challenge.

### Section 1: Sales Performance Analysis

#### 1.1 Top Sales Performers (Employees)
**Business Question:** Who are our top 5 employees generating the most sales revenue?

**Required Output:**
| Employee Name | Total Sales Revenue | Number of Sales | Average Sale Value |
|--------------|-------------------|----------------|-------------------|
| John Smith | $456,789 | 23 | $19,860 |
| ... | ... | ... | ... |

---

#### 1.2 Top Sales Performers (Dealerships)
**Business Question:** Which 5 dealerships generate the most sales income?

**Required Output:**
| Dealership Name | Location | Total Sales Revenue | Number of Sales |
|----------------|----------|-------------------|----------------|
| Carnival Downtown | Nashville, TN | $1,234,567 | 89 |
| ... | ... | ... | ... |


---

#### 1.3 Best-Selling Vehicle Models
**Business Question:** Which vehicle model generated the most total sales income?

**Required Output:**
| Make | Model | Total Revenue | Units Sold | Avg Sale Price |
|------|-------|--------------|-----------|---------------|
| Ford | F-150 | $890,456 | 34 | $26,190 |
| ... | ... | ... | ... | ... |

---

#### 1.4 Employee Performance by Dealership
**Business Question:** Which employees generate the most income per dealership?

**Required Output:**
| Dealership | Employee Name | Total Sales | Rank at Dealership |
|-----------|--------------|------------|-------------------|
| Carnival Downtown | Jane Doe | $234,567 | 1 |
| Carnival Downtown | John Smith | $198,432 | 2 |
| ... | ... | ... | ... |

---

### Section 2: Inventory Intelligence

#### 2.1 Inventory Count by Model
**Business Question:** In our current inventory, show the count of each vehicle model in stock.

**Required Output:**
| Make | Model | Count in Stock | Oldest Vehicle Date | Newest Vehicle Date |
|------|-------|---------------|-------------------|-------------------|
| Toyota | Camry | 12 | 2020-03-15 | 2024-08-22 |
| ... | ... | ... | ... | ... |

**Note:** Run [`inventory_added_date.sql`](inventory_added_date.sql) for the missing date column.

**Query:**
```sql

-- Report 2.1: Inventory Count by Model
-- Author: Jen
-- Date: 2026-03-14 happy pi day

SELECT
    vt.make AS "Make",
    vt.model AS "Model",
    COUNT(*) AS "Count in Stock",
    MIN(v.inventory_added_date) AS "Oldest Vehicle Date",
    MAX(v.inventory_added_date) AS "Newest Vehicle Date"
FROM vehicles v
JOIN vehicletypes vt
    ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_sold = FALSE
GROUP BY vt.make, vt.model
ORDER BY "Count in Stock" DESC, vt.make, vt.model;
```

**Sample Output:**

| Make | Model | Count in Stock | Oldest Vehicle Date | Newest Vehicle Date |
|------|-------|----------------|---------------------|---------------------|
| Nissan | Maxima | 606 | 2008-10-09 | 2026-03-14 |
| Nissan | Altima | 423 | 2008-10-17 | 2026-03-14 |
| Ford | Fusion | 413 | 2008-10-19 | 2026-03-14 |
| Volkswagen | Passat | 404 | 2008-10-13 | 2026-03-14 |
| Chevrolet | Blazer | 398 | 2008-10-05 | 2026-03-14 |

**Key Finding:**
Nissan has 2 models at the top that have been in inventory the longest

**Actionable Recommendation:**
I'm guessing they'll want to sell these models that have been hanging around on the lot longer


---

#### 2.2 Inventory Count by Make
**Business Question:** In our inventory, show the count of each vehicle make in stock.

**Required Output:**
| Make | Total Count | Avg Days in Inventory | Total Value |
|------|------------|---------------------|------------|
| Ford | 45 | 67 | $1,234,567 |
| ... | ... | ... | ... |

**Query:**
```sql

-- Report 2.2: Inventory Count by Make
-- Author: Jen
-- Date: 2026-03-14

SELECT
    vt.make AS "Make",
    COUNT(*) AS "Total Count",
    CAST(AVG(CURRENT_DATE - v.inventory_added_date) AS int) AS "Avg Days in Inventory", -- today's date minus inventory_added_date, and then get the average, and then make the decimal an integer
    TO_CHAR(SUM(v.msr_price), 'L999,999,990.00') AS "Total Value" -- Thank you Hannah!
FROM vehicles v
JOIN vehicletypes vt
    ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_sold = FALSE -- make sure it hasn't been sold yet
GROUP BY vt.make
ORDER BY "Total Count" DESC, "Avg Days in Inventory" DESC;
```

**Sample Output:**

| Make | Total Count | Avg Days in Inventory | Total Value |
|------|-------------|----------------------|-------------|
| Nissan | 1398 | 511 | $24,372,510.00 |
| Chevrolet | 1164 | 547 | $20,330,690.00 |
| Ford | 1063 | 644 | $18,541,067.00 |
| Mazda | 828 | 484 | $14,473,922.00 |
| Volkswagen | 607 | 535 | $10,577,718.00 |

**Key Finding:**
Shows how much money can be made / has not been made from old inventory and which makes have been around the longest. Nissan is at the top again.

**Actionable Recommendation:**
Same as 2.1? Clear older cars?

---

#### 2.3 Inventory Count by Body Type
**Business Question:** In our inventory, show the count of each body type in stock.

**Required Output:**
| Body Type | Count | Percentage of Inventory | Avg Price |
|-----------|-------|----------------------|----------|
| SUV | 67 | 34.5% | $42,345 |
| Sedan | 54 | 27.8% | $28,956 |
| ... | ... | ... | ... |

**Query:**
```sql

-- Report 2.3: Inventory Count by Body Type
-- Author: Jen
-- Date: 2026-03-14

SELECT
    vt.body_type AS "Body Type",
    COUNT(*) AS "Count",
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER ()) * 100.0, 1) || '%' AS "Percentage of Inventory",
    -- (count of this body type / total cars in inventory) * 100
    -- Then round to 1 decimal place and add a % sign
    TO_CHAR(AVG(v.msr_price), 'L999,999,990.00') AS "Avg Price" -- Thank you again Hannah!
FROM vehicles v
JOIN vehicletypes vt
    ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_sold = FALSE -- make sure car hasn't been sold yet
GROUP BY vt.body_type
ORDER BY
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER ()) * 100.0, 1) DESC, -- I couldn't get it to sort right using the alias
    "Avg Price" DESC;
```

**Sample Output:**

| Body Type | Count | Percentage of Inventory | Avg Price |
|-----------|-------|-------------------------|-----------|
| Car | 2663 | 52.6% | $17,434.38 |
| SUV | 1202 | 23.8% | $17,447.07 |
| Truck | 969 | 19.2% | $17,492.74 |
| Van | 226 | 4.5% | $17,461.61 |

**Key Finding:**
Cars show up as the issue again here. I bet they are Nissans, too!

**Actionable Recommendation:**
Run a sale on car body types.

---

#### 2.4 Slow-Moving Inventory
**Business Question:** Which vehicles have been in inventory the longest without selling?

**Required Output:**
| Vehicle ID | Make | Model | Year | Days in Inventory | Purchase Price | Asking Price |
|-----------|------|-------|------|------------------|---------------|-------------|
| V-4582 | Chevrolet | Suburban | 2019 | 342 | $38,500 | $42,000 |
| ... | ... | ... | ... | ... | ... | ... |

**Query:**

-- Report 2.4: Slow-Moving Inventory
-- Author: Jen
-- Date: 2026-03-14

```sql
SELECT
    'V-' || v.vehicle_id AS "Vehicle ID", -- add 'V-' prefix
    vt.make AS "Make",
    vt.model AS "Model",
    v.year_of_car AS "Year",
    CURRENT_DATE - v.inventory_added_date AS "Days in Inventory", -- today minus date
    TO_CHAR(v.msr_price, 'FML999,999,990.00') AS "Purchase Price", -- formatting for $ price
    TO_CHAR(v.floor_price, 'FML999,999,990.00') AS "Asking Price" -- formatting for $ price
FROM vehicles v
JOIN vehicletypes vt
    ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_sold = FALSE
ORDER BY
    "Days in Inventory" DESC, v.floor_price DESC;
```

**Sample Output:**

| Vehicle ID | Make | Model | Year | Days in Inventory | Purchase Price | Asking Price |
|------------|------|-------|------|-------------------|----------------|--------------|
| V-178 | Chevrolet | Blazer | 2021 | 6369 | $19,834.00 | $33,947.00 |
| V-543 | Mazda | MX-5 Miata | 2021 | 6369 | $16,464.00 | $31,261.00 |
| V-116 | Nissan | Maxima | 2019 | 6365 | $16,841.00 | $34,127.00 |
| V-997 | Chevrolet | Corvette | 2024 | 6365 | $18,064.00 | $32,813.00 |
| V-572 | Volkswagen | Passat | 2024 | 6361 | $18,097.00 | $28,007.00 |

**Key Finding:**
Some cars have been in inventory for a very long time. 

(And the database does some time travelling. The dates are weird because actual vehicle year dates & sale dates don't make sense. )

**Actionable Recommendation:**
Added incentives / extra sales to move the inventory.

---

### Section 3: Customer Intelligence

#### 3.1 Highest Average Purchase Price by State
**Business Question:** Which U.S. state has customers with the highest average vehicle purchase price?

**Required Output:**
| State | Avg Purchase Price | Number of Customers | Total Sales |
|-------|-------------------|-------------------|------------|
| California | $45,678 | 234 | $10,688,652 |
| ... | ... | ... | ... |

---

#### 3.2 Top 5 States by Customer Purchasing Power
**Business Question:** Which 5 states have customers with the highest average purchase price?

**Required Output:**
| Rank | State | Avg Purchase Price | Customer Count | Total Revenue |
|------|-------|-------------------|---------------|--------------|
| 1 | California | $45,678 | 234 | $10,688,652 |
| ... | ... | ... | ... | ... |

---

#### 3.3 Repeat Customers
**Business Question:** Which customers have purchased multiple vehicles? Who are our most loyal customers?

**Required Output:**
| Customer Name | Number of Purchases | Total Spent | Avg Purchase Price | First Purchase | Most Recent |
|--------------|-------------------|------------|-------------------|---------------|------------|
| Robert Johnson | 4 | $156,789 | $39,197 | 2019-03-12 | 2024-08-15 |
| ... | ... | ... | ... | ... | ... |

---

#### 3.4 Customer Lifetime Value Analysis
**Business Question:** Calculate customer lifetime value and identify high-value customer segments.

**Required Output:**
| Customer Segment | Avg Lifetime Value | Customer Count | Avg Time Between Purchases |
|-----------------|-------------------|---------------|--------------------------|
| Premium Buyers | $125,456 | 45 | 18 months |
| Regular Buyers | $42,789 | 178 | 36 months |
| Single Purchase | $35,124 | 1,234 | N/A |

---

### Section 4: Advanced Analytics

#### 4.1 Sales Trends Over Time
**Business Question:** How have monthly sales changed over the past year?

**Required Output:**
| Year-Month | Number of Sales | Total Revenue | Avg Sale Price | Change from Previous Month |
|-----------|----------------|--------------|---------------|-------------------------|
| 2024-08 | 45 | $1,234,567 | $27,435 | +12.3% |
| 2024-07 | 40 | $1,098,765 | $27,469 | -3.2% |
| ... | ... | ... | ... | ... |

---

#### 4.2 Employee Sales Rankings with Running Totals
**Business Question:** Show employee sales rankings with running totals throughout the year.

**Required Output:**
| Employee | Month | Monthly Sales | Running Total | Rank This Month |
|---------|-------|--------------|--------------|----------------|
| Jane Doe | 2024-08 | $123,456 | $987,654 | 1 |
| Jane Doe | 2024-07 | $98,765 | $864,198 | 2 |
| ... | ... | ... | ... | ... |

---

#### 4.3 Vehicle Turnover Rate
**Business Question:** How quickly are different vehicle types selling (days from inventory to sale)?

**Required Output:**
| Make | Model | Avg Days to Sale | Fastest Sale | Slowest Sale | Units Sold |
|------|-------|-----------------|-------------|-------------|-----------|
| Honda | Civic | 23 | 7 | 89 | 34 |
| ... | ... | ... | ... | ... | ... |

---

### Section 5: Bonus Challenges (Optional)

#### 5.1 Dealership Performance Dashboard

Create a comprehensive view combining:
- Sales by dealership
- Employee count per dealership
- Inventory levels per dealership
- Average sale price per dealership
- Year-over-year growth

**Skills Applied:** Complex CTEs, Multiple aggregations, Subqueries

---

#### 5.2 Vehicle Profitability Analysis

Calculate profit margin for each sold vehicle:
- Purchase price vs. sale price
- Days to sale (carrying cost)
- Identify most and least profitable models

**Skills Applied:** Calculations, Window functions, Aggregation

---

#### 5.3 Sales Forecasting Data Preparation

Prepare data for forecasting:
- Sales by month for past 24 months
- Seasonal patterns (by quarter)
- Trend analysis

**Skills Applied:** Date functions, Window functions, Complex aggregation

---

## SQL Tips and Best Practices

### Query Organization
```sql
-- Good: Organized with comments
-- Report 1.1: Top 5 Sales Performers
-- Author: Jane Doe
-- Date: 2024-11-10
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    SUM(s.sale_price) AS total_revenue,
    COUNT(s.sale_id) AS number_of_sales,
    AVG(s.sale_price) AS avg_sale_value
FROM employees e
INNER JOIN sales s ON e.employee_id = s.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_revenue DESC
LIMIT 5;
```

### Using CTEs for Complex Queries
```sql
-- Break complex queries into readable CTEs
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(sale_price) AS revenue
    FROM sales
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
),
previous_month AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly_sales
)
SELECT
    month,
    revenue,
    prev_revenue,
    ROUND(((revenue - prev_revenue) / prev_revenue * 100), 2) AS percent_change
FROM previous_month
ORDER BY month DESC;
```

### Window Functions for Rankings
```sql
-- Rank employees by sales within each dealership
SELECT
    d.dealership_name,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    SUM(s.sale_price) AS total_sales,
    RANK() OVER (
        PARTITION BY d.dealership_id
        ORDER BY SUM(s.sale_price) DESC
    ) AS rank_at_dealership
FROM dealerships d
INNER JOIN dealership_employees de ON d.dealership_id = de.dealership_id
INNER JOIN employees e ON de.employee_id = e.employee_id
INNER JOIN sales s ON e.employee_id = s.employee_id
GROUP BY d.dealership_id, d.dealership_name, e.employee_id, e.first_name, e.last_name
ORDER BY d.dealership_name, rank_at_dealership;
```

### Date Calculations
```sql
-- Calculate days in inventory
SELECT
    v.vehicle_id,
    vm.model_name,
    DATEDIFF(CURDATE(), v.date_added_to_inventory) AS days_in_inventory
FROM vehicles v
INNER JOIN vehicle_models vm ON v.model_id = vm.model_id
WHERE v.sale_id IS NULL  -- Not yet sold
ORDER BY days_in_inventory DESC;
```

## Presentation Tips

- **Tell a story** with the data, don't just show numbers
- **Use visuals** - formatted tables, charts if possible
- **Explain business impact** - why does this insight matter?
- **Demo live queries** - show you really understand the SQL
- **Be honest** about challenges and limitations
