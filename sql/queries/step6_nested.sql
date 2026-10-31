-- Step 6c: the same query as nested subqueries (no CTEs).
SELECT m.title, g.genre_name, w.n_ratings,
       ROUND(w.movie_avg, 2) AS movie_avg,
       ROUND(w.genre_avg, 2) AS genre_avg
FROM (
    SELECT ms.movie_id, mg.genre_id, ms.n_ratings, ms.movie_avg, gs.genre_avg
    FROM (
        SELECT movie_id, COUNT(*) AS n_ratings, AVG(rating) AS movie_avg
        FROM ratings
        GROUP BY movie_id
        HAVING COUNT(*) >= 30
    ) ms
    JOIN movie_genres mg ON mg.movie_id = ms.movie_id
    JOIN (
        SELECT mg2.genre_id, AVG(r.rating) AS genre_avg
        FROM ratings r
        JOIN movie_genres mg2 ON mg2.movie_id = r.movie_id
        GROUP BY mg2.genre_id
    ) gs ON gs.genre_id = mg.genre_id
    WHERE ms.movie_avg >= gs.genre_avg + 0.5
) w
JOIN movies m ON m.movie_id = w.movie_id
JOIN genres g ON g.genre_id = w.genre_id
ORDER BY w.movie_avg - w.genre_avg DESC, m.title;
