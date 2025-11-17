--You have a table of in app purchases. For each user you need to determine whether the marketing campaign caused them to make additional purchases.
--A user qualifies as influenced by the campaign only when all the following are true:


CREATE TABLE in_app_purchases 
( 
    created_at DATETIME, 
    price BIGINT, 
    product_id BIGINT, 
    quantity BIGINT, 
    user_id BIGINT
);
INSERT INTO in_app_purchases (created_at, price, product_id, quantity, user_id) VALUES
('2024-12-01 10:00:00', 500, 101, 1, 1),
('2024-12-02 11:00:00', 700, 102, 1, 1),
('2024-12-01 12:00:00', 300, 103, 1, 2),
('2024-12-03 14:00:00', 400, 103, 1, 2),
('2024-12-02 09:30:00', 200, 104, 1, 3),
('2024-12-04 15:30:00', 600, 105, 2, 3),
('2024-12-01 08:00:00', 800, 106, 1, 4),
('2024-12-05 18:00:00', 500, 107, 1, 4),
('2024-12-06 16:00:00', 700, 108, 1, 5);



--SQL Query

WITH first_purchase AS
(
    SELECT
        user_id,
        MIN(CAST(created_at AS DATE)) AS first_day
    FROM in_app_purchases
    GROUP BY user_id
),

initial_day_products AS
(
    SELECT
        p.user_id,
        p.product_id
    FROM in_app_purchases p
    JOIN first_purchase f
        ON p.user_id = f.user_id
       AND CAST(p.created_at AS DATE) = f.first_day
),

later_purchases AS
(
    SELECT
        p.user_id,
        p.product_id,
        CAST(p.created_at AS DATE) AS purchase_day
    FROM in_app_purchases p
    JOIN first_purchase f
        ON p.user_id = f.user_id
       AND CAST(p.created_at AS DATE) > f.first_day
)

SELECT COUNT(DISTINCT lp.user_id) AS users_influenced
FROM later_purchases lp
LEFT JOIN initial_day_products idp
     ON lp.user_id = idp.user_id
    AND lp.product_id = idp.product_id
WHERE idp.product_id IS NULL;
