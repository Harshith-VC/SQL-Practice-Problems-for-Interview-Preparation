--For every calendar week in the dataset, compute total weekly sales.
--Sales means quantity multiplied by unitprice.
--Monday is treated as the first day of the week.
--Sunday is treated as the last day of the week.
--For each week find the proportion of weekly sales that occurred on the first day and the last day.
--Round both values to the nearest whole number.
--Return week number, percent on Monday, percent on Sunday ordered by week number.


CREATE TABLE early_sales
(
    invoicedate DATETIME,
    invoiceno BIGINT,
    quantity BIGINT,
    stockcode NVARCHAR(50),
    unitprice FLOAT
);
INSERT INTO early_sales (invoicedate, invoiceno, quantity, stockcode, unitprice) VALUES
('2023-01-01 10:00:00', 1001, 5, 'A001', 20.0),
('2023-01-01 15:30:00', 1002, 3, 'A002', 30.0),
('2023-01-02 09:00:00', 1003, 10, 'A003', 15.0),
('2023-01-02 11:00:00', 1004, 2, 'A004', 50.0),
('2023-01-08 10:30:00', 1005, 4, 'A005', 25.0),
('2023-01-08 14:45:00', 1006, 7, 'A006', 18.0),
('2023-01-15 08:00:00', 1007, 6, 'A007', 22.0),
('2023-01-15 16:00:00', 1008, 8, 'A008', 12.0),
('2023-01-22 09:30:00', 1009, 3, 'A009', 40.0),
('2023-01-22 18:00:00', 1010, 5, 'A010', 35.0),
('2023-02-01 10:00:00', 1011, 9, 'A011', 20.0),
('2023-02-01 12:00:00', 1012, 2, 'A012', 60.0),
('2023-02-05 09:30:00', 1013, 4, 'A013', 25.0),
('2023-02-05 13:00:00', 1014, 6, 'A014', 18.0),
('2023-02-12 10:00:00', 1015, 7, 'A015', 22.0),
('2023-02-12 14:00:00', 1016, 5, 'A016', 28.0);


--SQL Query
WITH Base AS
(
    SELECT
        invoicedate,
        DATEPART(WEEK, invoicedate) AS week_num,
        DATENAME(WEEKDAY, invoicedate) AS weekday_name,
        quantity * unitprice AS sales_value
    FROM early_sales
),
WeeklyTotals AS
(
    SELECT
        week_num,
        SUM(sales_value) AS total_week_sales
    FROM Base
    GROUP BY week_num
),
FirstLastDay AS
(
    SELECT
        b.week_num,
        SUM(CASE WHEN weekday_name = 'Monday' THEN sales_value END) AS monday_sales,
        SUM(CASE WHEN weekday_name = 'Sunday' THEN sales_value END) AS sunday_sales
    FROM Base b
    GROUP BY b.week_num
),
Final AS
(
    SELECT
        f.week_num,
        ROUND(f.monday_sales * 100.0 / w.total_week_sales, 0) AS percent_monday,
        ROUND(f.sunday_sales * 100.0 / w.total_week_sales, 0) AS percent_sunday
    FROM FirstLastDay f
    JOIN WeeklyTotals w
        ON f.week_num = w.week_num
)
SELECT *
FROM Final
ORDER BY week_num;
