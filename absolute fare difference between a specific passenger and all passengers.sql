--Find the average absolute fare difference between a specific passenger and all passengers that belong to the same pclass, both are non-survivors and age difference between two of them is 5 or less years. Do that for each passenger (that satisfy above mentioned coniditions). Output the result along with the passenger name.



DROP TABLE IF EXISTS titanic;

CREATE TABLE titanic (
    passengerid BIGINT PRIMARY KEY,
    name VARCHAR(255),
    pclass BIGINT,
    survived BIGINT,
    age FLOAT,
    fare FLOAT,
    cabin VARCHAR(50),
    embarked VARCHAR(1),
    parch BIGINT,
    sibsp BIGINT,
    ticket VARCHAR(50),
    sex VARCHAR(10)
);
INSERT INTO titanic 
(passengerid, name, pclass, survived, age, fare, cabin, embarked, parch, sibsp, ticket, sex)
VALUES
(1, 'John Smith', 1, 0, 35, 71.28, 'C85', 'C', 0, 1, 'PC 17599', 'male'),
(2, 'Mary Johnson', 1, 0, 30, 53.1, 'C123', 'C', 0, 0, 'PC 17601', 'female'),
(3, 'James Brown', 1, 1, 40, 50.0, NULL, 'S', 0, 0, '113803', 'male'),
(4, 'Anna Davis', 2, 0, 28, 13.5, NULL, 'S', 0, 1, '250644', 'female'),
(5, 'Robert Wilson', 2, 0, 32, 13.5, NULL, 'S', 0, 1, '250655', 'male'),
(6, 'Emma Moore', 3, 0, 25, 7.25, NULL, 'S', 0, 0, '349909', 'female'),
(7, 'William Taylor', 3, 0, 27, 7.75, NULL, 'Q', 0, 0, 'STON/O 2. 3101282', 'male'),
(8, 'Sophia Anderson', 3, 1, 22, 8.05, NULL, 'S', 0, 0, '347082', 'female'),
(9, 'David Thomas', 1, 0, 36, 71.28, 'C85', 'C', 0, 1, 'PC 17599', 'male'),
(10, 'Alice Walker', 1, 0, 33, 53.1, 'C123', 'C', 0, 0, 'PC 17601', 'female');


--SQL Query
WITH base AS (
    SELECT 
        passengerid,
        name,
        pclass,
        age,
        fare
    FROM titanic
    WHERE survived = 0
),
pairs AS (
    SELECT 
        a.passengerid AS p1,
        b.passengerid AS p2,
        a.name AS p1_name,
        ABS(a.fare - b.fare) AS fare_diff
    FROM base a
    JOIN base b
        ON a.pclass = b.pclass
       AND a.passengerid <> b.passengerid
       AND ABS(a.age - b.age) <= 5
)
SELECT 
    p1_name AS passenger_name,
    AVG(fare_diff) AS avg_abs_fare_difference
FROM pairs
GROUP BY p1_name
ORDER BY p1_name;
