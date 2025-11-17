--To determine the number of days in a month with no sales, one must first extract the date information from all transaction IDs, generate a complete calendar for the relevant month, and then compare the two data sets to identify and count the missing dates. 


DROP TABLE IF EXISTS transactions;
GO

CREATE TABLE transactions (
    txn_date DATE
);
GO

INSERT INTO transactions VALUES ('2024-01-01');
INSERT INTO transactions VALUES ('2024-01-03');
INSERT INTO transactions VALUES ('2024-01-05');
INSERT INTO transactions VALUES ('2024-01-07');
INSERT INTO transactions VALUES ('2024-01-10');
INSERT INTO transactions VALUES ('2024-01-12');
INSERT INTO transactions VALUES ('2024-01-15');
INSERT INTO transactions VALUES ('2024-01-20');
INSERT INTO transactions VALUES ('2024-01-25');

INSERT INTO transactions VALUES ('2024-02-01');
INSERT INTO transactions VALUES ('2024-02-04');
INSERT INTO transactions VALUES ('2024-02-05');
INSERT INTO transactions VALUES ('2024-02-11');
INSERT INTO transactions VALUES ('2024-02-20');
INSERT INTO transactions VALUES ('2024-02-22');
GO



--- SQL Query

WITH months AS (
    SELECT DISTINCT DATETRUNC(month, txn_date) AS month_start
    FROM transactions
),
num AS (
    SELECT TOP 31 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
SELECT 
    m.month_start,
    COUNT(*) AS no_sales_days
FROM months m
CROSS JOIN num n
LEFT JOIN transactions t
    ON DATEADD(day, n.n - 1, m.month_start) = t.txn_date
WHERE DATEADD(day, n.n - 1, m.month_start) < DATEADD(month, 1, m.month_start)
  AND t.txn_date IS NULL
GROUP BY m.month_start
ORDER BY m.month_start;


-- Alternate Solution 

WITH date_series AS (
    SELECT MIN(txn_date) AS dt, MAX(txn_date) AS max_dt
    FROM transactions
    
    UNION ALL
    
    SELECT DATEADD(day, 1, dt), max_dt
    FROM date_series
    WHERE dt < max_dt
),

final AS (
    SELECT 
        dt,
        DATETRUNC(month, dt) AS month_start,
        t.txn_date
    FROM date_series d
    LEFT JOIN transactions t
        ON d.dt = t.txn_date
)
SELECT
    month_start,
    COUNT(*) AS no_sales_days
FROM final
WHERE txn_date IS NULL
GROUP BY month_start
ORDER BY month_start
OPTION (MAXRECURSION 0);
