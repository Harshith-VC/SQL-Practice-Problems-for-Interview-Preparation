--Join the transaction table with the store table.
--Count unique customers per area.
--Compute customer density as unique customers divided by area size.
--Return the three areas with the highest density


CREATE TABLE transaction_records
(
    customer_id BIGINT,
    store_id BIGINT,
    transaction_amount BIGINT,
    transaction_date DATETIME,
    transaction_id BIGINT PRIMARY KEY
);

CREATE TABLE stores
(
    area_name VARCHAR(20),
    area_size BIGINT,
    store_id BIGINT PRIMARY KEY,
    store_location TEXT,
    store_open_date DATETIME
);
INSERT INTO transaction_records VALUES
(101, 1, 500, '2024-01-01 10:15:00', 10001),
(102, 2, 1500, '2024-01-02 12:30:00', 10002),
(103, 1, 700, '2024-01-03 14:00:00', 10003),
(104, 3, 1200, '2024-01-04 09:45:00', 10004),
(105, 2, 800, '2024-01-05 11:20:00', 10005);

INSERT INTO stores VALUES
('Downtown', 1000, 1, 'Main Street', '2020-01-01'),
('Uptown', 1500, 2, 'Park Avenue', '2021-06-15'),
('Midtown', 1200, 3, 'Broadway', '2019-11-20'),
('Suburbs', 2000, 4, 'Elm Street', '2018-08-10');



---SQL Query

WITH Joined AS
(
    SELECT
        s.area_name,
        s.area_size,
        t.customer_id
    FROM stores s
    LEFT JOIN transaction_records t
        ON s.store_id = t.store_id
),
Agg AS
(
    SELECT
        area_name,
        area_size,
        COUNT(DISTINCT customer_id) AS unique_customers
    FROM Joined
    GROUP BY area_name, area_size
),
Density AS
(
    SELECT
        area_name,
        unique_customers * 1.0 / area_size AS customer_density
    FROM Agg
)
SELECT TOP 3
    area_name,
    customer_density
FROM Density
ORDER BY customer_density DESC;
