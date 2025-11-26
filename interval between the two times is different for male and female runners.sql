--You need to find whether the delay between gun time and net time differs for male and female runners.
--Compute the average of the absolute difference (gun_time minus net_time) for males and females separately.
--Then compute the absolute difference between these two averages and return that value.


CREATE TABLE marathon_male
(
    age BIGINT,
    div_tot TEXT,
    gun_time BIGINT,
    hometown TEXT,
    net_time BIGINT,
    num BIGINT,
    pace BIGINT,
    person_name TEXT,
    place BIGINT
);

CREATE TABLE marathon_female
(
    age BIGINT,
    div_tot TEXT,
    gun_time BIGINT,
    hometown TEXT,
    net_time BIGINT,
    num BIGINT,
    pace BIGINT,
    person_name TEXT,
    place BIGINT
);
INSERT INTO marathon_male VALUES
(25, '1/100', 3600, 'New York', 3400, 101, 500, 'John Doe', 1),
(30, '2/100', 4000, 'Boston', 3850, 102, 550, 'Michael Smith', 2),
(22, '3/100', 4200, 'Chicago', 4150, 103, 600, 'David Johnson', 3);

INSERT INTO marathon_female VALUES
(28, '1/100', 3650, 'San Francisco', 3600, 201, 510, 'Jane Doe', 1),
(26, '2/100', 3900, 'Los Angeles', 3850, 202, 530, 'Emily Davis', 2),
(24, '3/100', 4100, 'Seattle', 4050, 203, 590, 'Anna Brown', 3);

