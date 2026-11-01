
-- Step 5, Q5: Number of ratings per calendar month
-- Predicted rows: 12
-- Actual rows: 8
-- Gap: Expected approximately one year of data, but ratings
-- span only eight calendar months (Sep 1997 to Apr 1998).
-- The monthly counts sum to 100,000.

SELECT
    strftime('%Y-%m', timestamp, 'unixepoch') AS month,
    COUNT(*) AS rating_count
FROM ratings
GROUP BY month
ORDER BY month;
