-- New York Times SQL Interview Question
-- Laptop Vs. Mobile Viewership
-- using subqueries to get the laptop and mobile views
SELECT 
	(SELECT 
		COUNT(device_type) 
	FROM viewership 
		WHERE device_type='laptop') AS laptop_views,
	
	device_type IN ('phone', 'tablet') AS mobile_views
	FROM viewership;
	
-- another way of writing subquery
SELECT 
	(SELECT 
		COUNT(device_type) 
	FROM viewership 
		WHERE device_type='laptop') AS laptop_views,
	
	COUNT(device_type) AS mobile_views
	FROM viewership
	WHERE device_type = 'phone' OR device_type='tablet';
	
-- FILTER statement in SQL
SELECT
	COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
	COUNT(*) FILTER (WHERE device_type IN ('phone', 'tablet') AS mobile_views
FROM viewership;

-- CASE statements in SQL
SELECT 
	SUM(CASE WHEN device_type='laptop' THEN 1 ELSE 0 END) AS laptop_views,
	SUM(CASE WHEN device_type IN ('phone', 'tablet') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

