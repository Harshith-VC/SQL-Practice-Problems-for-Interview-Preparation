--Find the most profitable location. Write a query that calculates the average signup duration and average transaction amount for each location, and then compare these two measures together by taking the ratio of the average transaction amount and average duration for each location


CREATE TABLE signups (
    signup_id INT PRIMARY KEY,
    signup_start_date DATETIME,
    signup_stop_date DATETIME,
    plan_id INT,
    location VARCHAR(100)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    signup_id INT,
    transaction_start_date DATETIME,
    amt FLOAT,
    FOREIGN KEY (signup_id) REFERENCES signups(signup_id)
);
INSERT INTO signups (signup_id, signup_start_date, signup_stop_date, plan_id, location) VALUES
(1, '2020-01-01 10:00:00', '2020-01-01 12:00:00', 101, 'New York'),
(2, '2020-01-02 11:00:00', '2020-01-02 13:00:00', 102, 'Los Angeles'),
(3, '2020-01-03 10:00:00', '2020-01-03 14:00:00', 103, 'Chicago'),
(4, '2020-01-04 09:00:00', '2020-01-04 10:30:00', 101, 'San Francisco'),
(5, '2020-01-05 08:00:00', '2020-01-05 11:00:00', 102, 'New York');

INSERT INTO transactions (transaction_id, signup_id, transaction_start_date, amt) VALUES
(1, 1, '2020-01-01 10:30:00', 50.00),
(2, 1, '2020-01-01 11:00:00', 30.00),
(3, 2, '2020-01-02 11:30:00', 100.00),
(4, 2, '2020-01-02 12:00:00', 75.00),
(5, 3, '2020-01-03 10:30:00', 120.00),
(6, 4, '2020-01-04 09:15:00', 80.00),
(7, 5, '2020-01-05 08:30:00', 90.00);



--SQL Query
-- 1) Calculate signup duration in minutes for each signup
WITH signup_durations AS (
    SELECT
        signup_id,
        location,
        DATEDIFF(MINUTE, signup_start_date, signup_stop_date) AS duration_minutes
    FROM signups
),

-- 2) Combine durations with transactions
joined_data AS (
    SELECT
        s.location,
        s.duration_minutes,
        t.amt
    FROM signup_durations s
    LEFT JOIN transactions t
        ON s.signup_id = t.signup_id
)

-- 3) Aggregate by location
SELECT
    location,
    AVG(duration_minutes) AS avg_duration,
    AVG(amt) AS avg_transaction_amount,
    AVG(amt) / AVG(duration_minutes) AS ratio
FROM joined_data
GROUP BY location
ORDER BY ratio DESC;
