
--You are given scheduled arrival and departure times for trains at a station.
--A platform is occupied from the beginning of the minute a train arrives until the end of the minute it departs.
--You must determine the minimum number of platforms needed so that no two trains overlap on the same platform.

-- Train arrivals table
CREATE TABLE train_arrivals (
    train_id INT PRIMARY KEY,
    arrival_time DATETIME
);

-- Train departures table
CREATE TABLE train_departures (
    train_id INT PRIMARY KEY,
    departure_time DATETIME
);
INSERT INTO train_arrivals (train_id, arrival_time) VALUES
(1, '2024-11-17 08:00'),(2, '2024-11-17 08:05'),(3, '2024-11-17 08:05'),
(4, '2024-11-17 08:10'),(5, '2024-11-17 08:10'),(6, '2024-11-17 12:15'),
(7, '2024-11-17 12:20'),(8, '2024-11-17 12:25'),(9, '2024-11-17 15:00'),
(10, '2024-11-17 15:00'),(11, '2024-11-17 15:00'),(12, '2024-11-17 15:06'),
(13, '2024-11-17 20:00'),(14, '2024-11-17 20:10');

INSERT INTO train_departures (train_id, departure_time) VALUES
(1, '2024-11-17 08:15'),(2, '2024-11-17 08:10'),(3, '2024-11-17 08:20'),
(4, '2024-11-17 08:25'),(5, '2024-11-17 08:20'),(6, '2024-11-17 13:00'),
(7, '2024-11-17 12:25'),(8, '2024-11-17 12:30'),(9, '2024-11-17 15:05'),
(10, '2024-11-17 15:10'),(11, '2024-11-17 15:15'),(12, '2024-11-17 15:15'),
(13, '2024-11-17 20:15'),(14, '2024-11-17 20:15');



--sql query
WITH events AS (
    -- Arrival events (+1)
    SELECT 
        arrival_time AS event_time,
        1 AS event_type
    FROM train_arrivals

    UNION ALL

    -- Departure events (-1)
    -- Adding 1 second ensures the platform is occupied
    -- until the END of the departure minute
    SELECT 
        DATEADD(SECOND, 1, departure_time) AS event_time,
        -1 AS event_type
    FROM train_departures
),
ordered_events AS (
    SELECT 
        event_time,
        event_type
    FROM events
)
SELECT MAX(running_total) AS minimum_platforms_required
FROM (
    SELECT 
        event_time,
        SUM(event_type) OVER (ORDER BY event_time ROWS UNBOUNDED PRECEDING) AS running_total
    FROM ordered_events
) AS x;


-- Logic 

--Step 1 → Turn all arrivals into +1

--Because they need a platform.

--Step 2 → Turn all departures into –1

--Because they free a platform.

--Step 3 → Sort every +1 and –1 by time

--This recreates the day minute-by-minute.

--Step 4 → Create a running total

--Running total tells us how many trains are at the station at that moment.

--Step 5 → The MAX running total = platforms needed

--Because that was the moment with the most trains present.

-- Example:
--Train A: arrives 8:00, leaves 8:10
--Train B: arrives 8:05, leaves 8:15
--Train C: arrives 8:07, leaves 8:12

--Let’s count:

--8:00 — Train A arrives → +1 (trains at station = 1)
--8:05 — Train B arrives → +1 (total = 2)
--8:07 — Train C arrives → +1 (total = 3)

--👉 Now 3 trains are at the station at the same time — so we need 3 platforms.

--8:10 — Train A leaves → –1 (total = 2)
--8:12 — Train C leaves → –1 (total = 1)
--8:15 — Train B leaves → –1 (total = 0)

--The maximum at any point was 3.

--So the station needs 3 platforms.