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
    TO_CHAR(SUM(v.msr_price), 'L999,999,990.00') AS "Total Value" -- Thank you Hannah!
FROM vehicles v
JOIN vehicletypes vt
    ON v.vehicle_type_id = vt.vehicle_type_id
WHERE v.is_sold = FALSE -- make sure it hasn't been sold yet
GROUP BY vt.make
ORDER BY "Total Count" DESC, "Avg Days in Inventory" DESC;


-- 2.3 Inventory Count by Body Type
-- Business Question: In our inventory, show the count of each body type in stock.



-- 2.4 Slow-Moving Inventory
-- Business Question: Which vehicles have been in inventory the longest without selling?
