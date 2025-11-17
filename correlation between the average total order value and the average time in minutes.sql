--You have been asked to investigate whether there is a correlation between the average total order value and the average time in minutes between placing an order and having it delivered per restaurant.

--CREATE TABLE
-- Drop the table if it already exists (safety step)
DROP TABLE IF EXISTS delivery_details;

-- Create the delivery_details table
CREATE TABLE delivery_details (
    customer_placed_order_datetime   DATETIME,
    placed_order_with_restaurant_datetime DATETIME,
    driver_at_restaurant_datetime DATETIME,
    delivered_to_consumer_datetime   DATETIME,
    driver_id BIGINT,
    restaurant_id BIGINT,
    consumer_id BIGINT,
    is_new TINYINT,
    delivery_region VARCHAR(255),
    is_asap TINYINT,
    order_total FLOAT,
    discount_amount FLOAT,
    tip_amount FLOAT,
    refunded_amount FLOAT
);

-- Insert sample data into delivery_details
INSERT INTO delivery_details (
    customer_placed_order_datetime,
    placed_order_with_restaurant_datetime,
    driver_at_restaurant_datetime,
    delivered_to_consumer_datetime,
    driver_id,
    restaurant_id,
    consumer_id,
    is_new,
    delivery_region,
    is_asap,
    order_total,
    discount_amount,
    tip_amount,
    refunded_amount
) VALUES
('2024-02-01 12:00:00', '2024-02-01 12:05:00', '2024-02-01 12:15:00', '2024-02-01 12:30:00', 101, 1, 1001, 1, 'New York', 1, 50.00, 5.00, 3.00, 0.00),
('2024-02-01 13:10:00', '2024-02-01 13:15:00', '2024-02-01 13:25:00', '2024-02-01 13:50:00', 102, 2, 1002, 0, 'Los Angeles', 0, 75.00, 10.00, 5.00, 2.00),
('2024-02-01 14:30:00', '2024-02-01 14:40:00', '2024-02-01 14:50:00', '2024-02-01 15:05:00', 103, 1, 1003, 1, 'New York', 1, 60.00, 8.00, 4.00, 0.00),
('2024-02-01 15:00:00', '2024-02-01 15:05:00', '2024-02-01 15:15:00', '2024-02-01 15:45:00', 104, 3, 1004, 0, 'Chicago', 0, 90.00, 15.00, 6.00, 5.00),
('2024-02-01 16:20:00', '2024-02-01 16:25:00', '2024-02-01 16:35:00', '2024-02-01 16:50:00', 105, 2, 1005, 1, 'Los Angeles', 1, 110.00, 20.00, 8.00, 0.00);


-- SQL Query

WITH restaurant_stats AS (
    SELECT
        restaurant_id,
        AVG(order_total - discount_amount - refunded_amount + tip_amount) AS avg_net_order_total,
        AVG(DATEDIFF(MINUTE, customer_placed_order_datetime, delivered_to_consumer_datetime)) AS avg_delivery_time_min
    FROM delivery_details
    GROUP BY restaurant_id
),
stats AS (
    SELECT 
        COUNT(*) AS n,
        SUM(avg_net_order_total) AS sum_x,
        SUM(avg_delivery_time_min) AS sum_y,
        SUM(avg_net_order_total * avg_delivery_time_min) AS sum_xy,
        SUM(POWER(avg_net_order_total, 2)) AS sum_x2,
        SUM(POWER(avg_delivery_time_min, 2)) AS sum_y2
    FROM restaurant_stats
)
SELECT 
    ROUND(
        (n * sum_xy - sum_x * sum_y) /
        SQRT((n * sum_x2 - POWER(sum_x, 2)) * (n * sum_y2 - POWER(sum_y, 2))),---Correlation= COV(X,Y)/STDDEV(X)×STDDEV(Y)
        2
    ) AS correlation
FROM stats;


	​
