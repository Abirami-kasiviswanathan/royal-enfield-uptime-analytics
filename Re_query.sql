--om nama shivaya

DROP VIEW IF EXISTS vw_connected_features_deep_dive;
DROP VIEW IF EXISTS vw_aging_buckets;
DROP VIEW IF EXISTS vw_kpi_summary;
DROP VIEW IF EXISTS vw_open_by_model;
DROP VIEW IF EXISTS vw_issue_breakdown;
DROP VIEW IF EXISTS vw_service_centre_backlog;
DROP VIEW IF EXISTS vw_overall_average_backlog;

DROP TABLE IF EXISTS job_cards CASCADE;
CREATE TABLE job_cards (
    job_card_id SERIAL PRIMARY KEY,
    bike_model VARCHAR(50),      
    is_connected_bike BOOLEAN,   
    issue_type VARCHAR(50),      
    priority VARCHAR(20),        
    status VARCHAR(20),          
    service_centre VARCHAR(50),  
    region VARCHAR(30),          
    days_open INTEGER,         
    created_date DATE
);


--synthetic data

INSERT INTO job_cards (bike_model, is_connected_bike, issue_type, priority, status, service_centre, region, days_open, created_date) VALUES

('Himalayan 450', true, 'Connected Features', 'High', 'Open', 'RE Company Store Saket', 'North', 12, '2026-06-02'),
('Classic 350', false, 'Mechanical', 'High', 'Open', 'RE Service Karol Bagh', 'North', 9, '2026-06-05'),
('Himalayan 450', true, 'Electrical', 'High', 'Open', 'RE Service Gurugram', 'North', 15, '2026-05-30'),
('Bullet 350', false, 'Engine', 'High', 'Open', 'RE Chandigarh Hub', 'North', 3, '2026-06-11'),
('Hunter 350', false, 'Electrical', 'Medium', 'Open', 'RE Jaipur Service', 'North', 5, '2026-06-09'),
('Meteor 350', true, 'Connected Features', 'Medium', 'Closed', 'RE Company Store Saket', 'North', 4, '2026-06-10'),
('Classic 350', false, 'Body & Paint', 'Low', 'Closed', 'RE Service Karol Bagh', 'North', 2, '2026-06-12'),
('Shotgun 650', true, 'Connected Features', 'Low', 'Pending', 'RE Gurugram', 'North', 6, '2026-06-08'),
('Himalayan 450', true, 'Mechanical', 'Medium', 'Closed', 'RE Chandigarh Hub', 'North', 1, '2026-06-13'),


('Classic 350', false, 'Mechanical', 'Medium', 'Open', 'RE OMR Chennai', 'South', 14, '2026-05-31'),
('Himalayan 450', true, 'Connected Features', 'High', 'Open', 'RE Jayanagar Bangalore', 'South', 8, '2026-06-06'),
('Meteor 350', true, 'Connected Features', 'High', 'Open', 'RE Kochi Central', 'South', 2, '2026-06-12'),
('Hunter 350', false, 'Electrical', 'Low', 'Open', 'RE OMR Chennai', 'South', 1, '2026-06-13'),
('Shotgun 650', true, 'Electrical', 'High', 'Open', 'RE Jayanagar Bangalore', 'South', 19, '2026-05-26'),
('Classic 350', false, 'Engine', 'Medium', 'Pending', 'RE Hyderabad Hub', 'South', 6, '2026-06-08'),
('Bullet 350', false, 'Mechanical', 'Low', 'Closed', 'RE Kochi Central', 'South', 3, '2026-06-11'),
('Himalayan 450', true, 'Connected Features', 'Medium', 'Closed', 'RE Jayanagar Bangalore', 'South', 4, '2026-06-10'),
('Classic 350', false, 'Electrical', 'Low', 'Closed', 'RE OMR Chennai', 'South', 2, '2026-06-12'),
('Hunter 350', false, 'Body & Paint', 'Low', 'Closed', 'RE Hyderabad Hub', 'South', 1, '2026-06-13'),


('Meteor 350', true, 'Connected Features', 'High', 'Open', 'RE Bandra Mumbai', 'West', 11, '2026-06-03'),
('Classic 350', false, 'Engine', 'High', 'Open', 'RE Pune Central', 'West', 8, '2026-06-06'),
('Himalayan 450', true, 'Mechanical', 'Medium', 'Open', 'RE Ahmedabad Hub', 'West', 4, '2026-06-10'),
('Hunter 350', false, 'Electrical', 'Medium', 'Open', 'RE Bandra Mumbai', 'West', 2, '2026-06-12'),
('Bullet 350', false, 'Mechanical', 'Low', 'Pending', 'RE Pune Central', 'West', 7, '2026-06-07'),
('Shotgun 650', true, 'Connected Features', 'High', 'Closed', 'RE Bandra Mumbai', 'West', 5, '2026-06-09'),
('Classic 350', false, 'Body & Paint', 'Low', 'Closed', 'RE Ahmedabad Hub', 'West', 3, '2026-06-11'),
('Meteor 350', true, 'Electrical', 'Medium', 'Closed', 'RE Pune Central', 'West', 1, '2026-06-13'),


('Bullet 350', false, 'Mechanical', 'High', 'Open', 'RE Kolkata Hub', 'East', 16, '2026-05-29'),
('Himalayan 450', true, 'Connected Features', 'High', 'Open', 'RE Guwahati Central', 'East', 10, '2026-06-04'),
('Classic 350', false, 'Electrical', 'Medium', 'Open', 'RE Bhubaneswar Hub', 'East', 3, '2026-06-11'),
('Hunter 350', false, 'Mechanical', 'Low', 'Open', 'RE Kolkata Hub', 'East', 2, '2026-06-12'),
('Meteor 350', true, 'Connected Features', 'Low', 'Pending', 'RE Guwahati Central', 'East', 5, '2026-06-09'),
('Classic 350', false, 'Engine', 'Medium', 'Closed', 'RE Kolkata Hub', 'East', 4, '2026-06-10'),
('Bullet 350', false, 'Body & Paint', 'Low', 'Closed', 'RE Bhubaneswar Hub', 'East', 2, '2026-06-12'),


('Himalayan 450', true, 'Connected Features', 'High', 'Open', 'RE Jayanagar Bangalore', 'South', 22, '2026-05-23'),
('Classic 350', false, 'Mechanical', 'High', 'Open', 'RE OMR Chennai', 'South', 3, '2026-06-11'),
('Shotgun 650', true, 'Electrical', 'Medium', 'Open', 'RE Company Store Saket', 'North', 1, '2026-06-13'),
('Meteor 350', true, 'Connected Features', 'Medium', 'Open', 'RE Bandra Mumbai', 'West', 0, '2026-06-14'),
('Hunter 350', false, 'Mechanical', 'Low', 'Closed', 'RE Pune Central', 'West', 4, '2026-06-10'),
('Classic 350', false, 'Electrical', 'Low', 'Closed', 'RE Kolkata Hub', 'East', 5, '2026-06-09');

--understanding data
--Total open job cards by bike model
SELECT 
    bike_model, count(*) as open_cards
FROM job_cards
WHERE status ILIKE 'open'
group by bike_model
order by open_cards;

--Issue type breakdown with open, closed, pending counts
--select issue_type, status, row_number() over (order by status)
SELECT 
    issue_type,
    COUNT(*) AS total_cards,
    COUNT(*) FILTER (WHERE status = 'Open') AS open_cards,
    COUNT(*) FILTER (WHERE status = 'Closed') AS closed_cards,
    COUNT(*) FILTER (WHERE status = 'Pending') AS pending_cards
FROM job_cards
GROUP BY issue_type
ORDER BY total_cards DESC;

---- 3. Service centres with open cards above average
with service_center_open as (
select job_cards.service_centre, count(*) open_cards
from job_cards 
where status ilike 'open'
group by job_cards.service_centre)
select service_center_open.service_centre
from service_center_open
WHERE open_cards > (SELECT AVG(open_cards) FROM service_center_open)
ORDER BY open_cards DESC;
--------------------------------------------------------------------------------
--view 1 - used count with filter
--for flash cards
CREATE VIEW vw_kpi_summary AS
SELECT
    COUNT(*) FILTER (WHERE status = 'Open') AS total_open,
    COUNT(*) FILTER (WHERE status = 'Closed') AS total_closed,
    COUNT(*) FILTER (WHERE status = 'Pending') AS total_pending,
    ROUND(AVG(days_open), 1) AS avg_days_open,
    ROUND(COUNT(*) FILTER (WHERE status = 'Closed') * 100.0 / COUNT(*), 1) AS percentage_resolved
FROM job_cards;

--view 2 - open_model - count, group by and order by 
--for bar chart - horizontal
CREATE VIEW vw_open_by_model AS
SELECT bike_model, COUNT(*) AS open_cards
FROM job_cards
WHERE status = 'Open'
GROUP BY bike_model
ORDER BY open_cards DESC;

--view 3 - issue_due to what problem in bike - used count with filter
--for side by side chart
CREATE VIEW vw_issue_breakdown AS
SELECT 
    issue_type,
    COUNT(*) AS total_cards,
    COUNT(*) FILTER (WHERE status = 'Open') AS open_cards,
    COUNT(*) FILTER (WHERE status = 'Closed') AS closed_cards,
    COUNT(*) FILTER (WHERE status = 'Pending') AS pending_cards
FROM job_cards
GROUP BY issue_type
ORDER BY total_cards DESC;

--view 4 -service_center view
--subquerry
--regular table
CREATE VIEW vw_service_centre_backlog AS
WITH centre_open AS (
    SELECT service_centre, region, COUNT(*) AS open_cards
    FROM job_cards
    WHERE status = 'Open'
    GROUP BY service_centre, region
)
SELECT service_centre, region, open_cards
FROM centre_open
WHERE open_cards > (SELECT AVG(open_cards) FROM centre_open)
ORDER BY open_cards DESC;

-- Calculate the true average of open cards across all service centres
--for flash card
Create view vw_overall_average_backlog as 
SELECT ROUND(AVG(open_cards), 1) AS overall_average_backlog
FROM (
    SELECT COUNT(*) AS open_cards 
    FROM job_cards 
    WHERE status = 'Open' 
    GROUP BY service_centre
) AS final_check_subquery;

--trying days open and trying using group by and 
--order by without appearing in the column and using min
CREATE VIEW vw_aging_buckets AS
SELECT
    region,
    CASE
        WHEN days_open BETWEEN 0 AND 5 THEN '0-5 days'
        WHEN days_open BETWEEN 6 AND 10 THEN '6-10 days'
        WHEN days_open BETWEEN 11 AND 15 THEN '11-15 days'
        ELSE '15+ days'
    END AS aging_bucket,
    COUNT(*) AS card_count,
    MIN(days_open) AS sort_key
FROM job_cards
WHERE status = 'Open'
GROUP BY region, 2
ORDER BY region, sort_key;
--Connected vs not connected bike open cards
CREATE VIEW vw_connected_features_deep_dive AS
SELECT 
    CASE 
        WHEN is_connected_bike THEN 'Connected Fleet (IoT)'
        ELSE 'Traditional Fleet (Mechanical)' 
    END AS bike_type, 
    COUNT(*) AS total_cards, 
    COUNT(*) FILTER (WHERE status = 'Open') AS open_backlog,
    -- Tracks how many open tickets have blown past the 7-day threshold
    COUNT(*) FILTER (WHERE status = 'Open' AND days_open > 7) AS sla_breached_cards,
    ROUND(AVG(days_open) FILTER (WHERE status = 'Open'), 1) AS avg_days_open_backlog
FROM job_cards 
GROUP BY is_connected_bike;
		
  ---error
  DROP VIEW IF EXISTS vw_aging_buckets;

CREATE VIEW vw_aging_buckets AS
SELECT
    region,
    CASE
        WHEN days_open BETWEEN 0 AND 5  THEN '0-5 days'
        WHEN days_open BETWEEN 6 AND 10 THEN '6-10 days'
        WHEN days_open BETWEEN 11 AND 15 THEN '11-15 days'
        ELSE '15+ days'
    END AS aging_bucket,
    COUNT(*) AS card_count,
    MIN(days_open) AS sort_key
FROM job_cards
WHERE status = 'Open'
GROUP BY region, 2
ORDER BY region, sort_key;


------------
DROP VIEW IF EXISTS
    vw_connected_features_deep_dive,
    vw_aging_buckets,
    vw_kpi_summary,
    vw_open_by_model,
    vw_issue_breakdown,
    vw_service_centre_backlog,
    vw_overall_average_backlog
CASCADE;

DROP TABLE IF EXISTS job_cards CASCADE;

CREATE TABLE job_cards (
    job_card_id SERIAL PRIMARY KEY,
    bike_model VARCHAR(50),      
    is_connected_bike BOOLEAN,   
    issue_type VARCHAR(50),      
    priority VARCHAR(20),        
    status VARCHAR(20),          
    service_centre VARCHAR(50),  
    region VARCHAR(30),          
    days_open INTEGER,         
    created_date DATE
);


--synthetic data

INSERT INTO job_cards (bike_model, is_connected_bike, issue_type, priority, status, service_centre, region, days_open, created_date) VALUES

('Himalayan 450', true, 'Connected Features', 'High', 'Open', 'RE Company Store Saket', 'North', 12, '2026-06-02'),
('Classic 350', false, 'Mechanical', 'High', 'Open', 'RE Service Karol Bagh', 'North', 9, '2026-06-05'),
('Himalayan 450', true, 'Electrical', 'High', 'Open', 'RE Service Gurugram', 'North', 15, '2026-05-30'),
('Bullet 350', false, 'Engine', 'High', 'Open', 'RE Chandigarh Hub', 'North', 3, '2026-06-11'),
('Hunter 350', false, 'Electrical', 'Medium', 'Open', 'RE Jaipur Service', 'North', 5, '2026-06-09'),
('Meteor 350', true, 'Connected Features', 'Medium', 'Closed', 'RE Company Store Saket', 'North', 4, '2026-06-10'),
('Classic 350', false, 'Body & Paint', 'Low', 'Closed', 'RE Service Karol Bagh', 'North', 2, '2026-06-12'),
('Shotgun 650', true, 'Connected Features', 'Low', 'Pending', 'RE Gurugram', 'North', 6, '2026-06-08'),
('Himalayan 450', true, 'Mechanical', 'Medium', 'Closed', 'RE Chandigarh Hub', 'North', 1, '2026-06-13'),


('Classic 350', false, 'Mechanical', 'Medium', 'Open', 'RE OMR Chennai', 'South', 14, '2026-05-31'),
('Himalayan 450', true, 'Connected Features', 'High', 'Open', 'RE Jayanagar Bangalore', 'South', 8, '2026-06-06'),
('Meteor 350', true, 'Connected Features', 'High', 'Open', 'RE Kochi Central', 'South', 2, '2026-06-12'),
('Hunter 350', false, 'Electrical', 'Low', 'Open', 'RE OMR Chennai', 'South', 1, '2026-06-13'),
('Shotgun 650', true, 'Electrical', 'High', 'Open', 'RE Jayanagar Bangalore', 'South', 19, '2026-05-26'),
('Classic 350', false, 'Engine', 'Medium', 'Pending', 'RE Hyderabad Hub', 'South', 6, '2026-06-08'),
('Bullet 350', false, 'Mechanical', 'Low', 'Closed', 'RE Kochi Central', 'South', 3, '2026-06-11'),
('Himalayan 450', true, 'Connected Features', 'Medium', 'Closed', 'RE Jayanagar Bangalore', 'South', 4, '2026-06-10'),
('Classic 350', false, 'Electrical', 'Low', 'Closed', 'RE OMR Chennai', 'South', 2, '2026-06-12'),
('Hunter 350', false, 'Body & Paint', 'Low', 'Closed', 'RE Hyderabad Hub', 'South', 1, '2026-06-13'),


('Meteor 350', true, 'Connected Features', 'High', 'Open', 'RE Bandra Mumbai', 'West', 11, '2026-06-03'),
('Classic 350', false, 'Engine', 'High', 'Open', 'RE Pune Central', 'West', 8, '2026-06-06'),
('Himalayan 450', true, 'Mechanical', 'Medium', 'Open', 'RE Ahmedabad Hub', 'West', 4, '2026-06-10'),
('Hunter 350', false, 'Electrical', 'Medium', 'Open', 'RE Bandra Mumbai', 'West', 2, '2026-06-12'),
('Bullet 350', false, 'Mechanical', 'Low', 'Pending', 'RE Pune Central', 'West', 7, '2026-06-07'),
('Shotgun 650', true, 'Connected Features', 'High', 'Closed', 'RE Bandra Mumbai', 'West', 5, '2026-06-09'),
('Classic 350', false, 'Body & Paint', 'Low', 'Closed', 'RE Ahmedabad Hub', 'West', 3, '2026-06-11'),
('Meteor 350', true, 'Electrical', 'Medium', 'Closed', 'RE Pune Central', 'West', 1, '2026-06-13'),


('Bullet 350', false, 'Mechanical', 'High', 'Open', 'RE Kolkata Hub', 'East', 16, '2026-05-29'),
('Himalayan 450', true, 'Connected Features', 'High', 'Open', 'RE Guwahati Central', 'East', 10, '2026-06-04'),
('Classic 350', false, 'Electrical', 'Medium', 'Open', 'RE Bhubaneswar Hub', 'East', 3, '2026-06-11'),
('Hunter 350', false, 'Mechanical', 'Low', 'Open', 'RE Kolkata Hub', 'East', 2, '2026-06-12'),
('Meteor 350', true, 'Connected Features', 'Low', 'Pending', 'RE Guwahati Central', 'East', 5, '2026-06-09'),
('Classic 350', false, 'Engine', 'Medium', 'Closed', 'RE Kolkata Hub', 'East', 4, '2026-06-10'),
('Bullet 350', false, 'Body & Paint', 'Low', 'Closed', 'RE Bhubaneswar Hub', 'East', 2, '2026-06-12'),


('Himalayan 450', true, 'Connected Features', 'High', 'Open', 'RE Jayanagar Bangalore', 'South', 22, '2026-05-23'),
('Classic 350', false, 'Mechanical', 'High', 'Open', 'RE OMR Chennai', 'South', 3, '2026-06-11'),
('Shotgun 650', true, 'Electrical', 'Medium', 'Open', 'RE Company Store Saket', 'North', 1, '2026-06-13'),
('Meteor 350', true, 'Connected Features', 'Medium', 'Open', 'RE Bandra Mumbai', 'West', 0, '2026-06-14'),
('Hunter 350', false, 'Mechanical', 'Low', 'Closed', 'RE Pune Central', 'West', 4, '2026-06-10'),
('Classic 350', false, 'Electrical', 'Low', 'Closed', 'RE Kolkata Hub', 'East', 5, '2026-06-09');

--understanding data
--Total open job cards by bike model
SELECT 
    bike_model, count(*) as open_cards
FROM job_cards
WHERE status ILIKE 'open'
group by bike_model
order by open_cards;

--Issue type breakdown with open, closed, pending counts
--select issue_type, status, row_number() over (order by status)
SELECT 
    issue_type,
    COUNT(*) AS total_cards,
    COUNT(*) FILTER (WHERE status = 'Open') AS open_cards,
    COUNT(*) FILTER (WHERE status = 'Closed') AS closed_cards,
    COUNT(*) FILTER (WHERE status = 'Pending') AS pending_cards
FROM job_cards
GROUP BY issue_type
ORDER BY total_cards DESC;

---- 3. Service centres with open cards above average
with service_center_open as (
select job_cards.service_centre, count(*) open_cards
from job_cards 
where status ilike 'open'
group by job_cards.service_centre)

select service_center_open.service_centre
from service_center_open
WHERE open_cards > (SELECT AVG(open_cards) FROM service_center_open)
ORDER BY open_cards DESC;

-- Dashboard views
-- Each view includes region plus an "All Regions" row so Streamlit can stay simple.

--view 1
CREATE VIEW vw_kpi_summary AS
SELECT
    COALESCE(region, 'All Regions') AS region,
    COUNT(*) FILTER (WHERE status = 'Open') AS total_open,
    COUNT(*) FILTER (WHERE status = 'Closed') AS total_closed,
    COUNT(*) FILTER (WHERE status = 'Pending') AS total_pending,
    ROUND(AVG(days_open) FILTER (WHERE status = 'Open'), 1) AS avg_days_open,
    ROUND(COUNT(*) FILTER (WHERE status = 'Closed') * 100.0 / NULLIF(COUNT(*), 0), 1) AS percentage_resolved,
    COUNT(*) FILTER (WHERE status = 'Open' AND days_open > 7) AS sla_breached
FROM job_cards
GROUP BY GROUPING SETS ((region), ());

--view 2
CREATE VIEW vw_open_by_model AS
SELECT
    COALESCE(region, 'All Regions') AS region,
    bike_model,
    COUNT(*) AS open_cards
FROM job_cards
WHERE status = 'Open'
GROUP BY GROUPING SETS ((region, bike_model), (bike_model))
ORDER BY region, open_cards DESC;

--view 3
CREATE VIEW vw_issue_breakdown AS
SELECT
    COALESCE(region, 'All Regions') AS region,
    issue_type,
    COUNT(*) AS total_cards,
    COUNT(*) FILTER (WHERE status = 'Open') AS open_cards,
    COUNT(*) FILTER (WHERE status = 'Closed') AS closed_cards,
    COUNT(*) FILTER (WHERE status = 'Pending') AS pending_cards
FROM job_cards
GROUP BY GROUPING SETS ((region, issue_type), (issue_type))
ORDER BY region, total_cards DESC;

--view 4
CREATE VIEW vw_aging_buckets AS
WITH bucketed_cards AS (
    SELECT
        region,
        CASE
            WHEN days_open BETWEEN 0 AND 5 THEN '0-5 days'
            WHEN days_open BETWEEN 6 AND 10 THEN '6-10 days'
            WHEN days_open BETWEEN 11 AND 15 THEN '11-15 days'
            ELSE '15+ days'
        END AS aging_bucket,
        CASE
            WHEN days_open BETWEEN 0 AND 5 THEN 1
            WHEN days_open BETWEEN 6 AND 10 THEN 2
            WHEN days_open BETWEEN 11 AND 15 THEN 3
            ELSE 4
        END AS sort_key
    FROM job_cards
    WHERE status = 'Open'
)
SELECT
    COALESCE(region, 'All Regions') AS region,
    aging_bucket,
    COUNT(*) AS card_count,
    MIN(sort_key) AS sort_key
FROM bucketed_cards
GROUP BY GROUPING SETS ((region, aging_bucket), (aging_bucket))
ORDER BY region, sort_key;

--view 5
CREATE VIEW vw_connected_features_deep_dive AS
SELECT
    COALESCE(region, 'All Regions') AS region,
    CASE
        WHEN is_connected_bike THEN 'Connected Fleet (IoT)'
        ELSE 'Traditional Fleet'
    END AS bike_type,
    COUNT(*) AS total_cards,
    COUNT(*) FILTER (WHERE status = 'Open') AS open_backlog,
    COUNT(*) FILTER (WHERE status = 'Open' AND days_open > 7) AS sla_breached_cards,
    ROUND(AVG(days_open) FILTER (WHERE status = 'Open'), 1) AS avg_days_open_backlog
FROM job_cards
GROUP BY GROUPING SETS ((region, is_connected_bike), (is_connected_bike))
ORDER BY region, bike_type;

--view 6
-- Removed the internal GROUPING SETS inside the CTE to avoid compounding 
-- real metrics with grand totals, which was falsely raising threshold filters.
CREATE VIEW vw_service_centre_backlog AS
WITH centre_open AS (
    SELECT
        region,
        service_centre,
        COUNT(*) AS open_cards
    FROM job_cards
    WHERE status = 'Open'
    GROUP BY region, service_centre
),
average_backlog AS (
    SELECT
        region,
        AVG(open_cards) AS avg_open_cards
    FROM centre_open
    GROUP BY region
)
SELECT
    c.region,
    c.service_centre,
    c.open_cards
FROM centre_open c
JOIN average_backlog a ON c.region = a.region
WHERE c.open_cards > a.avg_open_cards

UNION ALL

-- Appends the global rollup row cleanly at the end without polluting the calculation above
SELECT 
    'All Regions' AS region,
    co.service_centre,
    co.open_cards
FROM centre_open co
WHERE co.open_cards > (SELECT AVG(open_cards) FROM centre_open)

ORDER BY region, open_cards DESC;


-- ── VIEW 7: OVERALL AVERAGE BACKLOG (FIXED) ────────────────────────────────
-- Cleaned up subquery dependencies to calculate the true mathematical arithmetic 
-- mean across localized centers without stacking duplicate metrics.
CREATE VIEW vw_overall_average_backlog AS
WITH base_counts AS (
    SELECT
        region,
        service_centre,
        COUNT(*) AS open_cards
    FROM job_cards
    WHERE status = 'Open'
    GROUP BY region, service_centre
)
SELECT
    region,
    ROUND(AVG(open_cards), 1) AS overall_average_backlog
FROM base_counts
GROUP BY region

UNION ALL

SELECT
    'All Regions' AS region,
    ROUND(AVG(open_cards), 1) AS overall_average_backlog
FROM base_counts;