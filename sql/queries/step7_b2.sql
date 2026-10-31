-- predicted rows: 1681
-- actual rows: 1681
-- gap: none; every movie qualifies except Good Morning (1971), whose release date matches itself.
SELECT title
FROM   movies m
WHERE NOT EXISTS (SELECT 1
                  FROM   movies m2
                  JOIN   movie_genres mg USING (movie_id)
                  WHERE  mg.genre_id = 0
                    AND  m2.release_date = m.release_date);
