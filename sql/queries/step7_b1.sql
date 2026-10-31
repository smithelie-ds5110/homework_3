-- predicted rows: 0
-- actual rows: 0
-- gap: none; the subquery returns a NULL, so NOT IN is never TRUE and no row comes back.
SELECT title
FROM   movies
WHERE  release_date NOT IN (SELECT m2.release_date
                            FROM   movies m2
                            JOIN   movie_genres mg USING (movie_id)
                            WHERE  mg.genre_id = 0);
