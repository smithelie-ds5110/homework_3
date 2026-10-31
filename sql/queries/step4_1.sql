-- predicted rows: 1
-- actual rows: 1
-- gap: none. Result: ratings 100000, users 943, movies 1682, so the README claim is confirmed.
SELECT (SELECT COUNT(*) FROM ratings) AS ratings,
       (SELECT COUNT(*) FROM users)   AS users,
       (SELECT COUNT(*) FROM movies)  AS movies;
