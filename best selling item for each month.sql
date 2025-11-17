--Find the best selling item for each month (no need to separate months by year) where the biggest total invoice was paid. The best selling item is calculated using the formula (unitprice * quantity). Output the month, the description of the item along with the amount paid.


CREATE TABLE online_retails 
(
    country VARCHAR(10),
    customerid FLOAT,
    description VARCHAR(50),
    invoicedate DATETIME,
    invoiceno VARCHAR(10),
    quantity BIGINT,
    stockcode VARCHAR(10),
    unitprice FLOAT
);
INSERT INTO online_retails 
(country, customerid, description, invoicedate, invoiceno, quantity, stockcode, unitprice) 
VALUES 
('USA', 12345, 'Product A', '2025-01-01 12:00:00', 'INV001', 5, 'A123', 10.50),
('UK', 67890, 'Product B', '2025-01-02 14:30:00', 'INV002', 2, 'B456', 20.75),
('Canada', 11223, 'Product C', '2025-01-03 16:45:00', 'INV003', 10, 'C789', 15.00);

-- SQL Query

WITH sales_calculated AS
(
    SELECT 
        DATEPART(month, invoicedate) AS sales_month,
        description,
        unitprice * quantity AS amount_paid
    FROM online_retails
),
ranked_sales AS
(
    SELECT 
        sales_month,
        description,
        amount_paid,
        ROW_NUMBER() OVER 
        (
            PARTITION BY sales_month 
            ORDER BY amount_paid DESC
        ) AS rn
    FROM sales_calculated
)
SELECT 
    sales_month AS month_number,
    description,
    amount_paid
FROM ranked_sales
WHERE rn = 1;
