-- predicted rows: 1
-- actual rows: 1
-- gap: none. Result: fewest ratings by one user is 20 and 0 users are below 20, so the README claim is confirmed.
-- SUM(n < 20) counts users below the cutoff (the comparison is 1 when true, 0 when false); it should be 0.
SELECT MIN(n)      AS fewest_ratings_by_one_user,
       SUM(n < 20) AS users_below_20
FROM (SELECT user_id, COUNT(*) AS n FROM ratings GROUP BY user_id);
