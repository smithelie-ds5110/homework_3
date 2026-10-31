-- predicted rows: 2
-- actual rows: 2
-- gap: none. Result: users 1 to 943 (943 rows), movies 1 to 1682 (1682 rows), so the README claim is confirmed.
-- Ids are unique, so "consecutive from 1" holds exactly when MIN = 1 and MAX = COUNT.
SELECT 'users' AS tbl,
       MIN(user_id) AS min_id, MAX(user_id) AS max_id, COUNT(*) AS n,
       MIN(user_id) = 1 AND MAX(user_id) = COUNT(*) AS consecutive
FROM users
UNION ALL
SELECT 'movies',
       MIN(movie_id), MAX(movie_id), COUNT(*),
       MIN(movie_id) = 1 AND MAX(movie_id) = COUNT(*)
FROM movies;
