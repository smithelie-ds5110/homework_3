-- predicted rows: 19
-- actual rows: 19
-- gap: none; all 19 genres have at least one rated movie.
SELECT g.name,
       COUNT(*)                AS n_ratings,
       ROUND(AVG(r.rating), 3) AS mean_rating
FROM   ratings r
JOIN   movie_genres mg USING (movie_id)
JOIN   genres g USING (genre_id)
GROUP  BY g.genre_id
ORDER  BY n_ratings DESC, g.name;