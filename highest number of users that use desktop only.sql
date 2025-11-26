--Write a query that returns the company (customer id column) with highest number of users that use desktop only.


CREATE TABLE fact_events (
    id INT PRIMARY KEY,
    time_id DATETIME,
    user_id VARCHAR(50),
    customer_id VARCHAR(50),
    client_id VARCHAR(50),
    event_type VARCHAR(50),
    event_id INT
);
INSERT INTO fact_events (id, time_id, user_id, customer_id, client_id, event_type, event_id) VALUES  
(1, '2024-12-01 10:00:00', 'U1', 'C1', 'desktop', 'click', 101), 
(2, '2024-12-01 11:00:00', 'U2', 'C1', 'mobile', 'view', 102), 
(3, '2024-12-01 12:00:00', 'U3', 'C2', 'desktop', 'click', 103), 
(4, '2024-12-01 13:00:00', 'U1', 'C1', 'desktop', 'click', 104), 
(5, '2024-12-01 14:00:00', 'U2', 'C1', 'tablet', 'view', 105), 
(6, '2024-12-01 15:00:00', 'U4', 'C3', 'desktop', 'click', 106), 
(7, '2024-12-01 16:00:00', 'U3', 'C2', 'desktop', 'click', 107), 
(8, '2024-12-01 17:00:00', 'U5', 'C4', 'desktop', 'click', 108), 
(9, '2024-12-01 18:00:00', 'U6', 'C4', 'mobile', 'view', 109), 
(10, '2024-12-01 19:00:00', 'U7', 'C5', 'desktop', 'click', 110);



--SQL Query
-- Step 1: Identify desktop-only users
WITH DesktopOnlyUsers AS (
    SELECT 
        user_id,
        customer_id
    FROM fact_events
    GROUP BY user_id, customer_id
    HAVING 
        COUNT(CASE WHEN client_id = 'desktop' THEN 1 END) = COUNT(*)  -- all events are desktop
),

-- Step 2: Count desktop-only users per customer
UserCount AS (
    SELECT 
        customer_id,
        COUNT(*) AS desktop_only_user_count
    FROM DesktopOnlyUsers
    GROUP BY customer_id
)

-- Step 3: Return the customer with highest count
SELECT TOP 1 
    customer_id,
    desktop_only_user_count
FROM UserCount
ORDER BY desktop_only_user_count DESC;



--Examples from the dataset
--✅ U1 (C1)

--Desktop events: 2

--Total events: 2
--✔ Desktop-only

--❌ U2 (C1)

--Desktop events: 0

--Total events: 2
--✘ Not desktop-only

--✅ U3 (C2)

--Desktop events: 2

--Total events: 2
--✔ Desktop-only