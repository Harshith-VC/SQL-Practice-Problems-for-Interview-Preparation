--You need to compute monthly revenue where only positive purchase amounts count.
--Group rows by the year and month of the purchase.
--Then compute a rolling three month average of total revenue.
--For each month, the rolling window contains the revenue of the current month plus the two months before it.
--Return the year month value and the rolling average ordered from the earliest month to the latest.


CREATE TABLE amazon_purchases
(
    created_at DATETIME,
    purchase_amt BIGINT,
    user_id BIGINT
);

INSERT INTO amazon_purchases (created_at, purchase_amt, user_id) VALUES
('2023-01-05', 1500, 101),
('2023-01-15', -200, 102),
('2023-02-10', 2000, 103),
('2023-02-20', 1200, 101),
('2023-03-01', 1800, 104),
('2023-03-15', -100, 102),
('2023-04-05', 2200, 105),
('2023-04-10', 1400, 103),
('2023-05-01', 2500, 106),
('2023-05-15', 1700, 107),
('2023-06-05', 1300, 108),
('2023-06-15', 1900, 109);


--SQL Query 
WITH Cleaned AS
(
    SELECT
        created_at,
        purchase_amt
    FROM amazon_purchases
    WHERE purchase_amt > 0
),
MonthlyRevenue AS
(
    SELECT
        FORMAT(created_at, 'yyyy-MM') AS year_month,
        SUM(purchase_amt) AS monthly_rev
    FROM Cleaned
    GROUP BY FORMAT(created_at, 'yyyy-MM')
),
Rolling AS
(
    SELECT
        year_month,
        monthly_rev,
        AVG(monthly_rev) OVER(
            ORDER BY year_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_three_months
    FROM MonthlyRevenue
)
SELECT
    year_month,
    rolling_avg_three_months
FROM Rolling

