--Calculate the total number of interactions and the total number of contents created for each customer. Include all interaction types and content types in your calculations. Your output should include the customer's ID, the total number of interactions, and the total number of content items.


CREATE TABLE customer_interactions 
(
    customer_id BIGINT,
    interaction_date DATETIME,
    interaction_id BIGINT,
    interaction_type VARCHAR(50)
);

INSERT INTO customer_interactions VALUES
(1, '2023-01-15 10:30:00', 101, 'Click'),
(1, '2023-01-16 11:00:00', 102, 'Purchase'),
(2, '2023-01-17 14:45:00', 103, 'View'),
(3, '2023-01-18 09:20:00', 104, 'Share'),
(3, '2023-01-18 09:25:00', 105, 'Like'),
(4, '2023-01-19 12:10:00', 106, 'Comment');


CREATE TABLE user_contents 
(
    content_id BIGINT,
    content_text VARCHAR(255),
    content_type VARCHAR(50),
    customer_id BIGINT
);

INSERT INTO user_contents VALUES
(201, 'Welcome Post', 'Blog', 1),
(202, 'Product Review', 'Review', 2),
(203, 'Event Photos', 'Photo', 3),
(204, 'Tutorial Video', 'Video', 3),
(205, 'Survey Response', 'Survey', 4);


-- SQL Query 

WITH interaction_counts AS
(
    SELECT 
        customer_id,
        COUNT(*) AS total_interactions
    FROM customer_interactions
    GROUP BY customer_id
),
content_counts AS
(
    SELECT 
        customer_id,
        COUNT(*) AS total_contents
    FROM user_contents
    GROUP BY customer_id
)
SELECT 
    COALESCE(i.customer_id, c.customer_id) AS customer_id,
    COALESCE(i.total_interactions, 0) AS total_interactions,
    COALESCE(c.total_contents, 0) AS total_contents
FROM interaction_counts i
FULL OUTER JOIN content_counts c
ON i.customer_id = c.customer_id
ORDER BY customer_id;
