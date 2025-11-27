--Estimate the growth of Airbnb each year using the number of hosts registered as the growth metric. The rate of growth is calculated by taking ((number of hosts registered in the current year - number of hosts registered in the previous year) / the number of hosts registered in the previous year) * 100. Output the year, number of hosts in the current year, number of hosts in the previous year, and the rate of growth. Round the rate of growth to the nearest percent and order the result in the ascending order based on the year. 

--Assume that the dataset consists only of unique hosts, meaning there are no duplicate hosts listed.


CREATE TABLE airbnb_search_details (
    id INT PRIMARY KEY,
    price FLOAT,
    property_type VARCHAR(100),
    room_type VARCHAR(100),
    amenities VARCHAR(MAX),
    accommodates INT,
    bathrooms INT,
    bed_type VARCHAR(50),
    cancellation_policy VARCHAR(50),
    cleaning_fee BIT,
    city VARCHAR(100),
    host_identity_verified VARCHAR(10),
    host_response_rate VARCHAR(10),
    host_since DATETIME,
    neighbourhood VARCHAR(100),
    number_of_reviews INT,
    review_scores_rating FLOAT,
    zipcode INT,
    bedrooms INT,
    beds INT
);


INSERT INTO airbnb_search_details 
(id, price, property_type, room_type, amenities, accommodates, bathrooms, bed_type, 
 cancellation_policy, cleaning_fee, city, host_identity_verified, host_response_rate, 
 host_since, neighbourhood, number_of_reviews, review_scores_rating, zipcode, bedrooms, beds)
VALUES
(7, 150, 'House', 'Entire home/apt', 'WiFi, Kitchen', 5, 2, 'Queen Bed', 'Flexible', 1, 'Seattle', 'Yes', '90%', '2019-05-30', 'Capitol Hill', 200, 4.6, 98102, 2, 3),
(8, 60, 'Apartment', 'Shared room', 'WiFi', 1, 1, 'Single Bed', 'Moderate', 0, 'Boston', 'Yes', '80%', '2018-04-18', 'Beacon Hill', 50, 4.2, 2108, 1, 1),
(9, 90, 'House', 'Private room', 'WiFi, Parking', 3, 2, 'King Bed', 'Strict', 1, 'Denver', 'No', '85%', '2021-02-10', 'Downtown', 75, 4.0, 80202, 1, 2),
(10, 250, 'Villa', 'Entire home/apt', 'Pool, WiFi, Kitchen', 8, 4, 'King Bed', 'Flexible', 1, 'Las Vegas', 'Yes', '95%', '2022-06-15', 'The Strip', 400, 4.9, 89109, 4, 5);


-- SQL Query 

-- Count hosts per registration year
WITH yearly_counts AS (
    SELECT 
        YEAR(host_since) AS year,
        COUNT(id) AS hosts_in_year
    FROM airbnb_search_details
    GROUP BY YEAR(host_since)
),

-- Use LAG to bring previous year's host counts
growth_calc AS (
    SELECT 
        year,
        hosts_in_year,
        LAG(hosts_in_year, 1) OVER (ORDER BY year) AS prev_year_hosts
    FROM yearly_counts
)

-- Final growth calculation
SELECT
    year,
    hosts_in_year AS current_year_hosts,
    prev_year_hosts AS previous_year_hosts,
   CASE 
        WHEN prev_year_hosts IS NULL THEN NULL        -- first year has no previous
        WHEN prev_year_hosts = 0 THEN NULL            -- avoid divide-by-zero
        ELSE ROUND(((hosts_in_year - prev_year_hosts) * 100.0 / prev_year_hosts), 0)
    END AS growth_rate_percent
FROM growth_calc
ORDER BY year;
