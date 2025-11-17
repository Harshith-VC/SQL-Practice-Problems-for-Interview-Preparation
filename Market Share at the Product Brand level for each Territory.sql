--Write a query to find the Market Share at the Product Brand level for each Territory, for Time Period Q4-2021. Market Share is the number of Products of a certain Product Brand brand sold in a territory, divided by the total number of Products sold in this Territory

--CREATE TABLE

-- Drop existing tables (for clean rerun)
DROP TABLE IF EXISTS fct_customer_sales;
DROP TABLE IF EXISTS map_customer_territory;
DROP TABLE IF EXISTS dim_product;

-- Create sales fact table
CREATE TABLE fct_customer_sales (
    cust_id VARCHAR(50),
    prod_sku_id VARCHAR(50),
    order_date DATETIME,
    order_value BIGINT,
    order_id VARCHAR(50)
);

-- Create customer–territory mapping table
CREATE TABLE map_customer_territory (
    cust_id VARCHAR(50),
    territory_id VARCHAR(50)
);

-- Create product dimension table
CREATE TABLE dim_product (
    prod_sku_id VARCHAR(50),
    prod_sku_name VARCHAR(255),
    prod_brand VARCHAR(100),
    market_name VARCHAR(100)
);

-- Insert sample sales records
INSERT INTO fct_customer_sales (cust_id, prod_sku_id, order_date, order_value, order_id) VALUES
('C001', 'P001', '2021-10-15', 100, 'O1001'),
('C002', 'P002', '2021-11-20', 200, 'O1002'),
('C003', 'P003', '2021-12-05', 150, 'O1003'),
('C001', 'P002', '2021-12-10', 300, 'O1004'),
('C002', 'P001', '2021-11-18', 250, 'O1005');

-- Insert customer–territory mapping data
INSERT INTO map_customer_territory (cust_id, territory_id) VALUES
('C001', 'T001'),
('C002', 'T002'),
('C003', 'T001');

-- Insert product dimension data
INSERT INTO dim_product (prod_sku_id, prod_sku_name, prod_brand, market_name) VALUES
('P001', 'Product A', 'Brand X', 'Market 1'),
('P002', 'Product B', 'Brand Y', 'Market 2'),
('P003', 'Product C', 'Brand X', 'Market 1');



-- SQL Query
WITH territory_sales AS (
    SELECT
        m.territory_id,
        p.prod_brand,
        COUNT(*) AS brand_sales
    FROM fct_customer_sales f
    JOIN map_customer_territory m
        ON f.cust_id = m.cust_id
    JOIN dim_product p
        ON f.prod_sku_id = p.prod_sku_id
    WHERE f.order_date BETWEEN '2021-10-01' AND '2021-12-31'
    GROUP BY m.territory_id, p.prod_brand
),
territory_totals AS (
    SELECT
        m.territory_id,
        COUNT(*) AS total_sales
    FROM fct_customer_sales f
    JOIN map_customer_territory m
        ON f.cust_id = m.cust_id
    WHERE f.order_date BETWEEN '2021-10-01' AND '2021-12-31'
    GROUP BY m.territory_id
)
SELECT
    ts.territory_id,
    ts.prod_brand,
    ROUND((ts.brand_sales * 100.0 / tt.total_sales), 2) AS market_share_percent
FROM territory_sales ts
JOIN territory_totals tt
    ON ts.territory_id = tt.territory_id
ORDER BY ts.territory_id, market_share_percent DESC;

