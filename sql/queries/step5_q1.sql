-- Step 5, Q1: Ten movies with the most ratings
-- Predicted rows: 10
-- Actual rows: 10
-- Gap: None. LIMIT 10 returns exactly ten movies
-- with movie_id ASC breaking ties

SELECT
    m.movie_id,
    m.title,
    COUNT(*) AS rating_count
FROM movies AS m
JOIN ratings AS r
    ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY
    rating_count DESC,
    m.movie_id ASC
LIMIT 10;

