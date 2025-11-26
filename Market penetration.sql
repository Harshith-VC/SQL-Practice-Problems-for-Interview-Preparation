--Identify active users using three rules.
--Last active date on or after 2024 January 01.
--Sessions at least five.
--Listening hours at least ten.
--Then compute active users divided by total users for each country and round the result to two decimals.


CREATE TABLE penetration_analysis
(
    country VARCHAR(20),
    last_active_date DATETIME,
    listening_hours BIGINT,
    sessions BIGINT,
    user_id BIGINT
);
INSERT INTO penetration_analysis (country, last_active_date, listening_hours, sessions, user_id) VALUES
('USA', '2024-01-25', 15, 7, 101),
('USA', '2023-12-20', 5, 3, 102),
('USA', '2024-01-20', 25, 10, 103),
('India', '2024-01-28', 12, 6, 201),
('India', '2023-12-15', 8, 4, 202),
('India', '2024-01-15', 20, 7, 203),
('UK', '2024-01-29', 18, 9, 301),
('UK', '2023-12-30', 9, 4, 302),
('UK', '2024-01-22', 30, 12, 303),
('Canada', '2024-01-01', 11, 6, 401),
('Canada', '2023-11-15', 3, 2, 402),
('Canada', '2024-01-15', 22, 8, 403),
('Germany', '2024-01-10', 14, 7, 501),
('Germany', '2024-01-30', 10, 5, 502),
('Germany', '2024-01-01', 5, 3, 503);



--SQL Query

WITH ActiveCheck AS
(
    SELECT
        country,
        user_id,
        CASE
            WHEN last_active_date >= '2024-01-01'
             AND sessions >= 5
             AND listening_hours >= 10
            THEN 1
            ELSE 0
        END AS is_active
    FROM penetration_analysis
),
Agg AS
(
    SELECT
        country,
        COUNT(*) AS total_users,
        SUM(is_active) AS active_users
    FROM ActiveCheck
    GROUP BY country
)
SELECT
    country,
    ROUND(active_users * 1.0 / total_users, 2) AS active_user_penetration_rate
FROM Agg
ORDER BY country;

