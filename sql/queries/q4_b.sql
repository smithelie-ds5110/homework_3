-- predicted rows: 1
-- actual rows: 1
-- gap: none in row count; the genre counts sum to 212,595, which is 112,595 more than 100,000 because each rating is counted once per genre of its movie.
WITH per_genre AS (
  SELECT COUNT(*) AS n_ratings
  FROM   ratings r
  JOIN   movie_genres USING (movie_id)
  GROUP  BY genre_id)
SELECT SUM(n_ratings)          AS sum_of_genre_counts,
       100000                  AS total_ratings,
       SUM(n_ratings) - 100000 AS difference
FROM per_genre;