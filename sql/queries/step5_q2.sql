-- Step 5, Q2: Mean rating by occupation
-- Predicted rows: 7
-- Actual rows: 7
-- Gap: None. Seven occupations have at least 50 distinct raters.

SELECT
    o.occupation,
    COUNT(DISTINCT u.user_id) AS raters,
    ROUND(AVG(r.rating), 3) AS mean_rating
FROM occupations AS o
JOIN users AS u
    ON o.occupation = u.occupation
JOIN ratings AS r
    ON u.user_id = r.user_id
GROUP BY o.occupation
HAVING COUNT(DISTINCT u.user_id) >= 50
ORDER BY mean_rating DESC;
