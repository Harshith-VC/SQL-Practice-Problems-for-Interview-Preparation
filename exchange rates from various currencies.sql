--You are given a list of exchange rates from various currencies to US Dollars (USD) in different months. Show how the exchange rate of all the currencies changed in the first half of 2020. Output the currency code and the difference between values of the exchange rate between July 1, 2020 and January 1, 2020.

CREATE TABLE sf_exchange_rates 
(
    date DATETIME,
    exchange_rate FLOAT,
    source_currency VARCHAR(10),
    target_currency VARCHAR(10)
);
INSERT INTO sf_exchange_rates VALUES
('20200101', 1.12, 'EUR', 'USD'),
('20200101', 1.31, 'GBP', 'USD'),
('20200101', 109.56, 'JPY', 'USD'),
('20200701', 1.17, 'EUR', 'USD'),
('20200701', 1.29, 'GBP', 'USD'),
('20200701', 109.66, 'JPY', 'USD'),
('20200101', 0.75, 'AUD', 'USD'),
('20200701', 0.73, 'AUD', 'USD'),
('20200101', 6.98, 'CNY', 'USD'),
('20200701', 7.05, 'CNY', 'USD');



--SQL Query

WITH jan_rates AS
(
    SELECT 
        source_currency,
        exchange_rate AS jan_rate
    FROM sf_exchange_rates
    WHERE date = '20200101'
),
jul_rates AS
(
    SELECT 
        source_currency,
        exchange_rate AS jul_rate
    FROM sf_exchange_rates
    WHERE date = '20200701'
)
SELECT 
    j.source_currency AS currency,
    j.jan_rate,
    r.jul_rate,
    r.jul_rate - j.jan_rate AS rate_change
FROM jan_rates j
JOIN jul_rates r
ON j.source_currency = r.source_currency
ORDER BY currency;


