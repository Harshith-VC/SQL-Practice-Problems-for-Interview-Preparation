--You need to compute sales per quarter for Q1 and Q2 of year 2020.
--Sales come from multiple currencies.
--You must convert all sales into USD using the exchange rate that matches the sale date and currency.
--Then sum the converted values by quarter.


CREATE TABLE sf_exchange_rate
(
    date DATE,
    exchange_rate FLOAT,
    source_currency VARCHAR(10),
    target_currency VARCHAR(10)
);

CREATE TABLE sf_sales_amount
(
    currency VARCHAR(10),
    sales_amount BIGINT,
    sales_date DATE
);
INSERT INTO sf_exchange_rate (date, exchange_rate, source_currency, target_currency) VALUES
('2020-01-15', 1.1, 'EUR', 'USD'),
('2020-01-15', 1.3, 'GBP', 'USD'),
('2020-02-05', 1.2, 'EUR', 'USD'),
('2020-02-05', 1.35, 'GBP', 'USD'),
('2020-03-25', 1.15, 'EUR', 'USD'),
('2020-03-25', 1.4, 'GBP', 'USD'),
('2020-04-15', 1.2, 'EUR', 'USD'),
('2020-04-15', 1.45, 'GBP', 'USD'),
('2020-05-10', 1.1, 'EUR', 'USD'),
('2020-05-10', 1.3, 'GBP', 'USD'),
('2020-06-05', 1.05, 'EUR', 'USD'),
('2020-06-05', 1.25, 'GBP', 'USD');

INSERT INTO sf_sales_amount (currency, sales_amount, sales_date) VALUES
('USD', 1000, '2020-01-15'),
('EUR', 2000, '2020-01-20'),
('GBP', 1500, '2020-02-05'),
('USD', 2500, '2020-02-10'),
('EUR', 1800, '2020-03-25'),
('GBP', 2200, '2020-03-30'),
('USD', 3000, '2020-04-15'),
('EUR', 1700, '2020-04-20'),
('GBP', 2000, '2020-05-10'),
('USD', 3500, '2020-05-25'),
('EUR', 1900, '2020-06-05'),
('GBP', 2100, '2020-06-10');


--SQL Query

WITH Joined AS
(
    SELECT
        s.sales_date,
        s.currency,
        s.sales_amount,
        CASE
            WHEN s.currency = 'USD' THEN s.sales_amount
            ELSE s.sales_amount * e.exchange_rate
        END AS sales_in_usd
    FROM sf_sales_amount s
    LEFT JOIN sf_exchange_rate e
        ON s.sales_date = e.date
       AND s.currency = e.source_currency
),
Quartered AS
(
    SELECT
        CASE
            WHEN DATEPART(QUARTER, sales_date) = 1 THEN 'Q1'
            WHEN DATEPART(QUARTER, sales_date) = 2 THEN 'Q2'
        END AS quarter_name,
        sales_in_usd
    FROM Joined
    WHERE DATEPART(QUARTER, sales_date) IN (1, 2)
)
SELECT
    quarter_name,
    SUM(sales_in_usd) AS total_sales_usd
FROM Quartered
GROUP BY quarter_name
ORDER BY quarter_name;
