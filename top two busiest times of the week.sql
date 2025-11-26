--To find your top two busiest times of the week, you must first segment your data into the specified time blocks: Morning (before 12 p.m.), Early afternoon (12 p.m. to 3 p.m.), and Late afternoon (after 3 p.m.) for each day of the week. Then, calculate the total activity for each of the 21 unique time-of-day segments (e.g., Monday Morning, Monday Early afternoon, etc.) and identify the two segments with the highest volume. 
--Step 1: Segment your data
--For each day of the week, categorize your activity data into the following time segments: 
--Morning: All activity before 12:00 p.m.
--Early afternoon: All activity between 12:00 p.m. and 3:00 p.m. (inclusive)
--Late afternoon: All activity after 3:00 p.m. 


CREATE TABLE sales_log
(
    order_id BIGINT PRIMARY KEY,
    product_id BIGINT,
    timestamp DATETIME
);
INSERT INTO sales_log (order_id, product_id, timestamp) VALUES
(1, 101, '2024-12-15 09:30:00'),
(2, 102, '2024-12-15 11:45:00'),
(3, 103, '2024-12-15 12:10:00'),
(4, 104, '2024-12-15 13:15:00'),
(5, 105, '2024-12-15 14:20:00'),
(6, 106, '2024-12-15 15:30:00'),
(7, 107, '2024-12-15 16:40:00'),
(8, 108, '2024-12-16 09:50:00'),
(9, 109, '2024-12-16 10:30:00'),
(10, 110, '2024-12-16 12:05:00'),
(11, 111, '2024-12-16 13:50:00'),
(12, 112, '2024-12-16 14:15:00'),
(13, 113, '2024-12-16 15:30:00'),
(14, 114, '2024-12-17 09:45:00'),
(15, 115, '2024-12-17 11:20:00'),
(16, 116, '2024-12-17 12:25:00'),
(17, 117, '2024-12-17 13:30:00'),
(18, 118, '2024-12-17 14:55:00'),
(19, 119, '2024-12-17 15:10:00'),
(20, 120, '2024-12-18 10:40:00');


--SQL Query


WITH Labeled AS
(
    SELECT
        DATENAME(WEEKDAY, timestamp) AS weekday_name,
        CASE
            WHEN DATEPART(HOUR, timestamp) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, timestamp) BETWEEN 12 AND 15 THEN 'Early afternoon'
            ELSE 'Late afternoon'
        END AS time_of_day
    FROM sales_log
),
Counts AS
(
    SELECT
        weekday_name,
        time_of_day,
        COUNT(*) AS order_count
    FROM Labeled
    GROUP BY weekday_name, time_of_day
),
Ranked AS
(
    SELECT
        weekday_name,
        time_of_day,
        order_count,
        DENSE_RANK() OVER(ORDER BY order_count DESC) AS rk
    FROM Counts
)
SELECT weekday_name, time_of_day, order_count
FROM Ranked
WHERE rk <= 2
ORDER BY order_count DESC, weekday_name, time_of_day;
