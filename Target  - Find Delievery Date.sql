--You are given two tables.
--The first table records customer orders with the timestamp when the order was placed.
--The second table contains dates that are public holidays.

--A delivery happens exactly two business days after the order date.
--Business days exclude weekends and public holidays.

--When an order is placed on a weekend, the next business day is counted as the first day.

--Write a SQL Server query to return the order id and the delivery date for every order.

---------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Holidays;

CREATE TABLE Orders (
    order_id INT,
    order_date DATE
);

CREATE TABLE Holidays (
    holiday_date DATE
);
INSERT INTO Orders VALUES
(1, '2024-01-03'),     -- Wednesday
(2, '2024-01-05'),     -- Friday
(3, '2024-01-06'),     -- Saturday
(4, '2024-01-07'),     -- Sunday
(5, '2024-01-08');     -- Monday

INSERT INTO Holidays VALUES
('2024-01-04'),         -- Thursday holiday
('2024-01-08');         -- Monday holiday


---SQL Query
SELECT 
    order_id,order_date,
    CASE 
        WHEN DATENAME(WEEKDAY, order_date) = 'Friday' THEN DATEADD(DAY, 4, order_date)
        WHEN DATENAME(WEEKDAY, order_date) = 'Saturday' THEN DATEADD(DAY, 3, order_date)
        WHEN DATENAME(WEEKDAY, order_date) = 'Sunday' THEN DATEADD(DAY, 3, order_date)
        ELSE DATEADD(DAY, 2, order_date)
    END AS delivery_date
FROM Orders;
