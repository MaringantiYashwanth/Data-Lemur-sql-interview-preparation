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

--  Average Post Hiatus 
SELECT 
	user_id,
	MAX(post_date::DATE) - MIN(post_date::DATE) AS days_between
FROM posts
WHERE DATE_PART('year', post_date::DATE) = 2021
GROUP BY user_id
HAVING
	COUNT(post_id) > 1;
	
-- Method 2
SELECT 
	user_id, EXTRACT(DAY FROM (MAX(post_date) - MIN(post_date))) AS "days_between"
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING count(post_id) > 1;

-- Method 3
SELECT 
	user_id, EXTRACT(DAY FROM (MAX(post_date) - MIN(post_date))) AS "days_between"
FROM posts,
WHERE EXTRACT(YEAR FROM post_date) = '2021'
GROUP BY user_id
HAVING COUNT(post_id) > 1;

-- App Click-Through Rate (CTR)
SELECT 
  app_id,
  ROUND((SUM(CASE WHEN event_type='click' THEN 1 ELSE 0 END)) * 100.0
  /
  (SUM(CASE WHEN event_type='impression' THEN 1 ELSE 0 END)), 2) AS ctr_rate
FROM events
WHERE timestamp >= '2022-01-01'
  AND timestamp < '2023-01-01'
GROUP BY app_id;

-- Well Paid Employees FANG
SELECT emp.employee_id, emp.name
FROM employee AS mgr -- represent's the manager's table
INNER JOIN employee AS emp -- represent's the employee's table
  ON mgr.employee_id = emp.manager_id
WHERE emp.salary > mgr.salary;


-- Second Day Confirmation
-- tiktok sql interview question
SELECT user_id
FROM emails e
INNER JOIN texts t
ON e.email_id = t.email_id
WHERE signup_action = 'Confirmed' AND t.action_date=e.signup_date + INTERVAL '1 Day';

-- IBM SQL Interview Question
-- IBM DB2 Product Analytics
WITH employee_queries AS (
  SELECT 
    e.employee_id,
    COALESCE(COUNT(DISTINCT q.query_id), 0) AS unique_queries
  FROM employees AS e
  LEFT JOIN queries AS q
    ON e.employee_id = q.employee_id
      AND q.query_starttime >= '2023-07-01T00:00:00Z'
      AND q.query_starttime < '2023-10-01T00:00:00Z'
  GROUP BY e.employee_id
)

SELECT
  unique_queries,
  COUNT(employee_id) AS employee_count
FROM employee_queries
GROUP BY unique_queries
ORDER BY unique_queries;