
-- add the new column
ALTER TABLE vehicles
ADD COLUMN inventory_added_date date;

-- AI helped me find the INTERVAL part but I can explain
UPDATE vehicles v
SET inventory_added_date = s.first_sale_date - INTERVAL '1 day' -- find the sale date by joining the sales table and
FROM (															-- make the inventory_added_date the day before that
	SELECT
		vehicle_id,
		MIN(purchase_date) AS first_sale_date -- find the first time the car was sold if it was sold more than once
	FROM sales
	GROUP BY vehicle_id
) s		
WHERE s.vehicle_id = v.vehicle_id;

-- make any unsold cars have an inventory_added_date of today just to give them a date
UPDATE vehicles
SET inventory_added_date = CURRENT_DATE
WHERE inventory_added_date IS NULL;