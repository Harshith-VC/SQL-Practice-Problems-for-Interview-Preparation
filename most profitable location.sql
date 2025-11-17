--Find the most profitable location. Write a query that calculates the average signup duration and average transaction amount for each location, and then compare these two measures together by taking the ratio of the average transaction amount and average duration for each location.

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'cust_signups_u1')
BEGIN
    CREATE TABLE cust_signups_u1 
    (
        location VARCHAR(100),
        plan_id BIGINT,
        signup_id BIGINT PRIMARY KEY,
        signup_start_date DATETIME,
        signup_stop_date DATETIME
    );
END;

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'cust_transactions_u1')
BEGIN
    CREATE TABLE cust_transactions_u1 
    (
        amt FLOAT,
        signup_id BIGINT,
        transaction_id BIGINT PRIMARY KEY,
        transaction_start_date DATETIME
    );
END;
DELETE FROM cust_transactions_u1;
DELETE FROM cust_signups_u1;
INSERT INTO cust_signups_u1 VALUES
('New York', 101, 1, CONVERT(DATETIME, '20250101', 112), CONVERT(DATETIME, '20250131', 112)),
('San Francisco', 102, 2, CONVERT(DATETIME, '20250105', 112), CONVERT(DATETIME, '20250205', 112)),
('Los Angeles', 103, 3, CONVERT(DATETIME, '20250110', 112), CONVERT(DATETIME, '20250120', 112)),
('New York', 104, 4, CONVERT(DATETIME, '20250201', 112), CONVERT(DATETIME, '20250228', 112)),
('Los Angeles', 105, 5, CONVERT(DATETIME, '20250115', 112), CONVERT(DATETIME, '20250125', 112));
INSERT INTO cust_transactions_u1 VALUES
(100.50, 1, 1001, CONVERT(DATETIME, '20250110', 112)),
(200.75, 1, 1002, CONVERT(DATETIME, '20250120', 112)),
(150.00, 2, 1003, CONVERT(DATETIME, '20250115', 112)),
(300.00, 3, 1004, CONVERT(DATETIME, '20250112', 112)),
(400.00, 4, 1005, CONVERT(DATETIME, '20250215', 112)),
(250.00, 5, 1006, CONVERT(DATETIME, '20250120', 112));



--SQL Query

WITH signup_durations AS
(
    SELECT 
        signup_id,
        location,
        DATEDIFF(day, signup_start_date, signup_stop_date) AS duration_days
    FROM cust_signups_u1
),
joined_data AS
(
    SELECT 
        s.location,
        s.duration_days,
        t.amt
    FROM signup_durations s
    JOIN cust_transactions_u1 t
    ON s.signup_id = t.signup_id
)
SELECT 
    location,
    AVG(duration_days) AS avg_duration,
    AVG(amt) AS avg_transaction,
    AVG(amt) / AVG(duration_days) AS ratio
FROM joined_data
GROUP BY location
ORDER BY ratio DESC;
