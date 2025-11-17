--Write a query to calculate the distribution of comments by the count of users that joined Meta/Facebook between 2018 and 2020, for the month of January 2020.

--The output should contain a count of comments and the corresponding number of users that made that number of comments in Jan-2020. For example, you'll be counting how many users made 1 comment, 2 comments, 3 comments, 4 comments, etc in Jan-2020. Your left column in the output will be the number of comments while your right column in the output will be the number of users. Sort the output from the least number of comments to highest.

DROP TABLE IF EXISTS fb_users;

CREATE TABLE fb_users (
    city_id BIGINT,
    device BIGINT,
    id BIGINT PRIMARY KEY,
    joined_at DATETIME,
    name VARCHAR(255)
);
INSERT INTO fb_users (city_id, device, id, joined_at, name) VALUES
(101, 1, 1, '2019-06-15', 'Alice'),
(102, 2, 2, '2020-03-10', 'Bob'),
(103, 1, 3, '2018-11-25', 'Charlie'),
(104, 3, 4, '2017-09-05', 'David'),
(105, 1, 5, '2019-01-20', 'Eve'),
(106, 2, 6, '2020-01-05', 'Frank');
DROP TABLE IF EXISTS fb_comments;

CREATE TABLE fb_comments (
    body VARCHAR(MAX),
    created_at DATETIME,
    user_id BIGINT FOREIGN KEY REFERENCES fb_users(id)
);
INSERT INTO fb_comments (body, created_at, user_id) VALUES
('Great post!', '2020-01-01 10:00:00', 1),
('Interesting article', '2020-01-02 12:30:00', 1),
('Thanks for sharing!',  '2020-01-05 08:20:00', 2),
('Nice update',          '2020-01-08 15:45:00', 3),
('Good job',             '2020-01-12 14:00:00', 3),
('Helpful content',      '2020-01-14 09:00:00', 3),
('Loved it!',            '2020-01-18 11:10:00', 5),
('Noted',                '2020-01-20 17:40:00', 6),
('Cool!',                '2020-01-22 08:55:00', 6),
('Agreed',               '2020-01-25 19:30:00', 6),
('Well written',         '2020-01-28 20:45:00', 1),
('Informative',          '2020-01-30 13:50:00', 5),
('Awesome',              '2019-12-31 23:59:00', 2);



-- SQL Query

WITH valid_users AS (
    SELECT *
    FROM fb_users
    WHERE joined_at BETWEEN '2018-01-01' AND '2020-12-31'
),
valid_comments AS (
    SELECT 
        c.user_id,
        c.created_at
    FROM fb_comments c
    INNER JOIN valid_users u
        ON c.user_id = u.id
    WHERE 
        c.created_at BETWEEN '2020-01-01' AND '2020-01-31'
        AND c.created_at >= u.joined_at
),
comment_counts AS (
    SELECT 
        user_id,
        COUNT(*) AS total_comments
    FROM valid_comments
    GROUP BY user_id
)
SELECT 
    total_comments,
    COUNT(*) AS number_of_users
FROM comment_counts
GROUP BY total_comments
ORDER BY total_comments;
