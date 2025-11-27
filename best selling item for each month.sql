--Find the best selling item for each month (no need to separate months by year) where the biggest total invoice was paid. The best selling item is calculated using the formula (unitprice * quantity). Output the month, the description of the item along with the amount paid.

CREATE TABLE online_retail (invoiceno VARCHAR(50),stockcode VARCHAR(50),description VARCHAR(255),quantity INT,invoicedate DATETIME,unitprice FLOAT,customerid FLOAT,country VARCHAR(100));

INSERT INTO online_retail (invoiceno, stockcode, description, quantity, invoicedate, unitprice, customerid, country)VALUES('536365', '85123A', 'WHITE HANGING HEART T-LIGHT HOLDER', 10, '2021-01-15 10:00:00', 2.55, 17850, 'United Kingdom'),('536366', '71053', 'WHITE METAL LANTERN', 5, '2021-02-10 12:00:00', 3.39, 13047, 'United Kingdom'),('536367', '84406B', 'CREAM CUPID HEARTS COAT HANGER', 8, '2021-03-05 15:00:00', 2.75, 17850, 'United Kingdom'),('536368', '22423', 'REGENCY CAKESTAND 3 TIER', 2, '2021-04-12 16:30:00', 12.75, 13047, 'United Kingdom'),('536369', '85123A', 'WHITE HANGING HEART T-LIGHT HOLDER', 15, '2021-05-18 11:00:00', 2.55, 13047, 'United Kingdom'),('536370', '21730', 'GLASS STAR FROSTED T-LIGHT HOLDER', 12, '2021-06-25 14:00:00', 4.25, 17850, 'United Kingdom');
-- 1) Compute each line's line_total (unitprice * quantity).
-- 2) Compute invoice total per invoiceno and month (month only, ignoring year).
-- 3) For each month find invoice(s) with the max invoice_total.
-- 4) For those invoice(s), pick the line item(s) with the largest line_total.
-- 5) Return month name, description, and the amount paid for that item.


---SQL Query


WITH lines AS (
    SELECT
        invoiceno,
        description,
        quantity,
        unitprice,
        invoicedate,
        -- line_total for each row
        CAST(unitprice * quantity AS DECIMAL(18,2)) AS line_total,
        -- month number (1-12) and month name
        MONTH(invoicedate) AS month_num,
        DATENAME(month, invoicedate) AS month_name
    FROM online_retail
),
invoice_totals AS (
    -- invoice total per invoice (within its month bucket)
    SELECT
        invoiceno,
        month_num,
        month_name,
        SUM(line_total) AS invoice_total
    FROM lines
    GROUP BY invoiceno, month_num, month_name
),
max_invoice_per_month AS (
    -- find maximum invoice_total per month
    SELECT
        month_num,
        month_name,
        invoice_total,
        invoiceno,
        -- rank invoices within the month by invoice_total desc (ties preserved with RANK)
        RANK() OVER (PARTITION BY month_num ORDER BY invoice_total DESC) AS inv_rank
    FROM invoice_totals
),
target_invoices AS (
    -- keep only the invoice(s) that have the max total per month (inv_rank = 1)
    SELECT month_num, month_name, invoiceno, invoice_total
    FROM max_invoice_per_month
    WHERE inv_rank = 1
),
-- join back to lines to get the line items for the selected invoices
lines_in_top_invoices AS (
    SELECT
        l.month_num,
        l.month_name,
        l.invoiceno,
        l.description,
        l.line_total
    FROM lines l
    INNER JOIN target_invoices t
        ON l.invoiceno = t.invoiceno
        AND l.month_num = t.month_num
),
-- now for each month (and invoice) find the line(s) with the highest line_total
best_item_per_month AS (
    SELECT
        month_num,
        month_name,
        description,
        line_total,
        RANK() OVER (PARTITION BY month_num ORDER BY line_total DESC) AS line_rank
    FROM lines_in_top_invoices
)
-- final output: one row per month showing the best-selling item (ties will produce multiple rows)
SELECT
    month_num,
    month_name,
    description,
    CAST(line_total AS DECIMAL(18,2)) AS amount_paid
FROM best_item_per_month
WHERE line_rank = 1
ORDER BY month_num;
