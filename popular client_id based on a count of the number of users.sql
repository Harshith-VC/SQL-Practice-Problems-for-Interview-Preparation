--Select the most popular client_id based on a count of the number of users who have at least 50% of their events from the following list: 'video call received', 'video call sent', 'voice call received', 'voice call sent'.

-- CREATE TABLE
-- Drop table if it already exists (safety)
DROP TABLE IF EXISTS fact_event;

-- Create fact_event table
CREATE TABLE fact_event (
    id BIGINT PRIMARY KEY,
    time_id DATETIME,
    user_id VARCHAR(50),
    customer_id VARCHAR(50),
    client_id VARCHAR(50),
    event_type VARCHAR(50),
    event_id BIGINT
);

-- Insert sample data
INSERT INTO fact_event (id, time_id, user_id, customer_id, client_id, event_type, event_id) VALUES
(1, '2024-02-01 10:00:00', 'U1', 'C1', 'CL1', 'video call received', 101),
(2, '2024-02-01 10:05:00', 'U1', 'C1', 'CL1', 'video call sent', 102),
(3, '2024-02-01 10:10:00', 'U1', 'C1', 'CL1', 'message sent', 103),
(4, '2024-02-01 11:00:00', 'U2', 'C2', 'CL2', 'voice call received', 104),
(5, '2024-02-01 11:10:00', 'U2', 'C2', 'CL2', 'voice call sent', 105),
(6, '2024-02-01 11:20:00', 'U2', 'C2', 'CL2', 'message received', 106),
(7, '2024-02-01 12:00:00', 'U3', 'C3', 'CL1', 'video call sent', 107),
(8, '2024-02-01 12:15:00', 'U3', 'C3', 'CL1', 'voice call received', 108),
(9, '2024-02-01 12:30:00', 'U3', 'C3', 'CL1', 'voice call sent', 109),
(10, '2024-02-01 12:45:00', 'U3', 'C3', 'CL1', 'video call received', 110);

--SQL Query

WITH user_event_stats AS (
    SELECT
        client_id,
        user_id,
        COUNT(*) AS total_events,
        SUM(CASE 
                WHEN event_type IN (
                    'video call received',
                    'video call sent',
                    'voice call received',
                    'voice call sent'
                ) THEN 1 ELSE 0 
            END) AS call_events
    FROM fact_event
    GROUP BY client_id, user_id
),
qualified_users AS (
    SELECT
        client_id,
        user_id
    FROM user_event_stats
    WHERE call_events >= 0.5 * total_events
)
SELECT TOP 1
    client_id,
    COUNT(DISTINCT user_id) AS qualified_user_count
FROM qualified_users
GROUP BY client_id
ORDER BY qualified_user_count DESC, client_id ASC;
