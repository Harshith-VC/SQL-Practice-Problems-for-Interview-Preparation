--Considering a dataset that tracks user interactions with different clients, identify which clients have users who are exclusively loyal to them (i.e., they don't interact with any other clients).

----For each of these clients, calculate the number of such exclusive users. The output should include the client_id and the corresponding count of exclusive users.


CREATE TABLE meetup_events_x001 
(
    client_id VARCHAR(255),
    customer_id VARCHAR(255),
    event_id BIGINT,
    event_type VARCHAR(255),
    id BIGINT PRIMARY KEY,
    time_id DATETIME,
    user_id VARCHAR(255)
);
INSERT INTO meetup_events_x001 VALUES
('C001', 'CU001', 101, 'click', 1,
 CONVERT(DATETIME, '20250101', 112) + CAST('10:00:00' AS DATETIME), 'U001'),

('C001', 'CU002', 102, 'view', 2,
 CONVERT(DATETIME, '20250101', 112) + CAST('11:00:00' AS DATETIME), 'U002'),

('C002', 'CU003', 103, 'click', 3,
 CONVERT(DATETIME, '20250102', 112) + CAST('10:00:00' AS DATETIME), 'U003'),

('C002', 'CU003', 104, 'view', 4,
 CONVERT(DATETIME, '20250102', 112) + CAST('11:00:00' AS DATETIME), 'U003'),

('C003', 'CU004', 105, 'click', 5,
 CONVERT(DATETIME, '20250103', 112) + CAST('10:00:00' AS DATETIME), 'U004'),

('C001', 'CU001', 106, 'view', 6,
 CONVERT(DATETIME, '20250104', 112) + CAST('10:00:00' AS DATETIME), 'U001'),

('C003', 'CU005', 107, 'click', 7,
 CONVERT(DATETIME, '20250105', 112) + CAST('10:00:00' AS DATETIME), 'U005'),

('C004', 'CU006', 108, 'view', 8,
 CONVERT(DATETIME, '20250106', 112) + CAST('10:00:00' AS DATETIME), 'U006'),

('C004', 'CU006', 109, 'click', 9,
 CONVERT(DATETIME, '20250107', 112) + CAST('10:00:00' AS DATETIME), 'U006'),

('C001', 'CU007', 110, 'click', 10,
 CONVERT(DATETIME, '20250108', 112) + CAST('10:00:00' AS DATETIME), 'U007');

 ---SQL Query
 WITH user_client_count AS
(
    SELECT 
        user_id,
        COUNT(DISTINCT client_id) AS client_count
    FROM meetup_events_x001
    GROUP BY user_id
),
exclusive_users AS
(
    SELECT 
        user_id
    FROM user_client_count
    WHERE client_count = 1
)
SELECT 
    client_id,
    COUNT(DISTINCT user_id) AS exclusive_user_count
FROM meetup_events_x001
WHERE user_id IN (SELECT user_id FROM exclusive_users)
GROUP BY client_id
ORDER BY exclusive_user_count DESC;
