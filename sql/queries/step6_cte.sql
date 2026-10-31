-- 1. mean and count per movie; keep movies with 30+ ratings
WITH movie_stats AS (          
    SELECT movie_id, COUNT(*) AS n_ratings, AVG(rating) AS movie_avg
    FROM ratings
    GROUP BY movie_id
    HAVING COUNT(*) >= 30
),

-- 2. mean of every rating given to a movie in that genre
genre_stats AS (              
    SELECT mg.genre_id, AVG(r.rating) AS genre_avg
    FROM ratings r
    JOIN movie_genres mg ON mg.movie_id = r.movie_id
    GROUP BY mg.genre_id
),

-- 3. compare each movie with each of its genres
movie_vs_genre AS (            
    SELECT ms.movie_id, mg.genre_id, ms.n_ratings, ms.movie_avg, gs.genre_avg
    FROM movie_stats ms
    JOIN movie_genres mg ON mg.movie_id = ms.movie_id
    JOIN genre_stats gs ON gs.genre_id = mg.genre_id
),

-- 4. keep pairs at least 0.5 above their genre
winners AS (                   
    SELECT * FROM movie_vs_genre
    WHERE movie_avg >= genre_avg + 0.5
)

SELECT m.title, g.genre_name, w.n_ratings,
       ROUND(w.movie_avg, 2) AS movie_avg,
       ROUND(w.genre_avg, 2) AS genre_avg
FROM winners w
JOIN movies m ON m.movie_id = w.movie_id
JOIN genres g ON g.genre_id = w.genre_id
ORDER BY w.movie_avg - w.genre_avg DESC, m.title;
