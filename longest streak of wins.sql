--You are given a table of tennis players and their matches that they could either win (W) or lose (L). Find the longest streak of wins. A streak is a set of consecutive won matches of one player. The streak ends once a player loses their next match. Output the ID of the player or players and the length of the streak.
DROP TABLE players_results;

CREATE TABLE players_results 
(
    match_date DATETIME,
    match_result VARCHAR(1),
    player_id BIGINT
);

INSERT INTO players_results (match_date, match_result, player_id) VALUES
('20230101', 'W', 1),
('20230102', 'W', 1),
('20230103', 'L', 1),
('20230104', 'W', 1),

('20230101', 'L', 2),
('20230102', 'W', 2),
('20230103', 'W', 2),
('20230104', 'W', 2),
('20230105', 'L', 2),

('20230101', 'W', 3),
('20230102', 'W', 3),
('20230103', 'W', 3),
('20230104', 'W', 3),
('20230105', 'L', 3);


-- SQL Query
WITH cte AS (
    SELECT
        player_id,
        match_result,
        match_date,
        ROW_NUMBER() OVER (
            PARTITION BY player_id, match_result
            ORDER BY match_date ASC
        ) AS rn
    FROM players_results
),
grouped AS (
    SELECT
        player_id,
        COUNT(rn) AS total_wins
    FROM cte
    WHERE match_result = 'W'
    GROUP BY player_id
),
max_win AS (
    SELECT MAX(total_wins) AS max_wins
    FROM grouped
)
SELECT
    g.player_id,
    g.total_wins
FROM grouped g
JOIN max_win m
    ON g.total_wins = m.max_wins;



--Alternative Solution 
WITH ordered_matches AS
(
    SELECT 
        player_id,
        match_date,
        match_result,
        SUM(CASE WHEN match_result = 'L' THEN 1 ELSE 0 END)
            OVER(PARTITION BY player_id ORDER BY match_date) AS loss_counter
    FROM players_results
),
win_streaks AS
(
    SELECT 
        player_id,
        loss_counter,
        COUNT(*) AS streak_length
    FROM ordered_matches
    WHERE match_result = 'W'
    GROUP BY player_id, loss_counter
),
max_streak_per_player AS
(
    SELECT 
        player_id,
        MAX(streak_length) AS longest_streak
    FROM win_streaks
    GROUP BY player_id
),
final_result AS
(
    SELECT 
        player_id,
        longest_streak
    FROM max_streak_per_player
    WHERE longest_streak = 
    (
        SELECT MAX(longest_streak) FROM max_streak_per_player
    )
)
SELECT * FROM final_result;


