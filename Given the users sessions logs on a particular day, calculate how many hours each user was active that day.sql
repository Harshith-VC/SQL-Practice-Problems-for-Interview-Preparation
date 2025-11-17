
--Given the users' sessions logs on a particular day, calculate how many hours each user was active that day.

--Note: The session starts when state=1 and ends when state=0.



--- CREATE TABLE

-- Drop the table if it already exists
DROP TABLE IF EXISTS cust_tracking;

-- Create the table
CREATE TABLE cust_tracking (
    cust_id VARCHAR(50),
    state BIGINT,
    timestamp DATETIME
);

-- Insert sample data
INSERT INTO cust_tracking (cust_id, state, timestamp) VALUES
('101', 1, '2024-01-10 08:00:00'),
('101', 0, '2024-01-10 10:30:00'),
('101', 1, '2024-01-10 14:00:00'),
('101', 0, '2024-01-10 15:45:00'),
('102', 1, '2024-01-10 09:15:00'),
('102', 0, '2024-01-10 12:00:00'),
('103', 1, '2024-01-10 07:00:00'),
('103', 0, '2024-01-10 09:30:00'),
('103', 1, '2024-01-10 13:00:00'),
('103', 0, '2024-01-10 16:00:00');


--SQL Query 
WITH session_pairs AS (
    SELECT 
        cust_id,
        timestamp AS session_start,
        LEAD(timestamp) OVER (PARTITION BY cust_id ORDER BY timestamp) AS session_end,
        state
    FROM cust_tracking
)
SELECT 
    cust_id,
    SUM(
        CASE 
            WHEN state = 1 THEN DATEDIFF(MINUTE, session_start, session_end) 
            ELSE 0 
        END
    ) / 60.0 AS active_hours
FROM session_pairs
GROUP BY cust_id
ORDER BY cust_id;
