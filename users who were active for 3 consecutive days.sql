--Find all the users who were active for 3 consecutive days or more.
CREATE TABLE sf_events (
    date DATETIME,
    account_id VARCHAR(10),
    user_id VARCHAR(10)
);
INSERT INTO sf_events (date, account_id, user_id) VALUES
('2021-01-01', 'A1', 'U1'),
('2021-01-01', 'A1', 'U2'),
('2021-01-06', 'A1', 'U3'),
('2021-01-02', 'A1', 'U1'),
('2020-12-24', 'A1', 'U2'),
('2020-12-08', 'A1', 'U1'),
('2020-12-09', 'A1', 'U1'),
('2021-01-10', 'A2', 'U4'),
('2021-01-11', 'A2', 'U4'),
('2021-01-12', 'A2', 'U4'),
('2021-01-15', 'A2', 'U5'),
('2020-12-17', 'A2', 'U4'),
('2020-12-25', 'A3', 'U6'),
('2020-12-25', 'A3', 'U6'),
('2020-12-25', 'A3', 'U6'),
('2020-12-06', 'A3', 'U7'),
('2020-12-06', 'A3', 'U6'),
('2021-01-14', 'A3', 'U6'),
('2021-02-07', 'A1', 'U1'),
('2021-02-10', 'A1', 'U2'),
('2021-02-01', 'A2', 'U4'),
('2021-02-01', 'A2', 'U5'),
('2020-12-05', 'A1', 'U8');



--SQL Query

-- 1) Remove duplicates and extract each user's distinct active dates
WITH distinct_dates AS (
    SELECT DISTINCT
        user_id,
        CAST(date AS DATE) AS activity_date
    FROM sf_events
),

-- 2) Use LAG to check if previous day = current day - 1
streaks AS (
    SELECT
        user_id,
        activity_date,
        LAG(activity_date) OVER (PARTITION BY user_id ORDER BY activity_date) AS prev_date
    FROM distinct_dates
),

-- 3) Define a "group" for consecutive days:
--    If current_date = prev_date + 1, same streak;
--    Otherwise, start a new group.
grouped AS (
    SELECT
        user_id,
        activity_date,
        CASE 
            WHEN DATEADD(day, 1, prev_date) = activity_date THEN 0
            ELSE 1
        END AS new_group_flag
    FROM streaks
),

-- 4) Build streak groups using running SUM
grouped_with_ids AS (
    SELECT
        user_id,
        activity_date,
        SUM(new_group_flag) OVER (
            PARTITION BY user_id ORDER BY activity_date
            ROWS UNBOUNDED PRECEDING
        ) AS grp
    FROM grouped
),

-- 5) Count days per streak
streak_counts AS (
    SELECT
        user_id,
        grp,
        COUNT(*) AS streak_length
    FROM grouped_with_ids
    GROUP BY user_id, grp
)

-- 6) Final: users with a streak >= 3
SELECT DISTINCT user_id
FROM streak_counts
WHERE streak_length >= 3
ORDER BY user_id;

   
