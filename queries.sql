-----------------------------------------------------
-- Section 2: Inventory Intelligence
-----------------------------------------------------

-- 2.1 Inventory Count by Model
-- Business Question: In our current inventory, show the count of each vehicle model in stock.

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

-- 2.2 Inventory Count by Make
-- Business Question: In our inventory, show the count of each vehicle make in stock.

SELECT
    vt.make AS "Make",
    COUNT(*) AS "Total Count",
    CAST(AVG(CURRENT_DATE - v.inventory_added_date) AS int) AS "Avg Days in Inventory", -- today's date - inventory_added_date, and then get the average, and then make the decimal an integer
    TO_CHAR(SUM(v.msr_price), 'L999,999,990.00') AS "Total Value" -- Thank you for the formatting Hannah!
FROM vehicles v
JOIN vehicletypes vt
    ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_sold = FALSE -- make sure it hasn't been sold yet
GROUP BY vt.make
ORDER BY "Total Count" DESC, "Avg Days in Inventory" DESC;


-- 2.3 Inventory Count by Body Type
-- Business Question: In our inventory, show the count of each body type in stock.


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


-- 2.4 Slow-Moving Inventory
-- Business Question: Which vehicles have been in inventory the longest without selling?

SELECT
    'V-' || v.vehicle_id AS "Vehicle ID",  -- add 'V-' prefix
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
    