
-- Step 5, Q4: Ratings by genre
-- Predicted rows: 19
-- Actual rows: 19
-- Gap: None. All 19 genres were returned.
--
-- The genre counts total 212,595, exceeding the 100,000
-- ratings because movies can belong to multiple genres.
-- Each rating is counted once for every genre assigned
-- to its movie.

SELECT
    g.genre_name AS genre,
    COUNT(r.rating) AS rating_count,
    ROUND(AVG(r.rating), 3) AS mean_rating,
    SUM(COUNT(r.rating)) OVER () AS total_genre_ratings
FROM genres AS g
JOIN movie_genres AS mg
    ON g.genre_id = mg.genre_id
JOIN ratings AS r
    ON mg.movie_id = r.movie_id
GROUP BY g.genre_id, g.genre_name
ORDER BY rating_count DESC;
