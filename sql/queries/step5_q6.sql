-- Step 5, Q6: Movies rated by students but not programmers
-- Predicted rows: 1
-- Actual rows: 1
-- Gap: None. The aggregate returned one row containing
-- 268 movies rated by students but not programmers.

SELECT COUNT(*) AS student_only_movies
FROM (
    SELECT r.movie_id
    FROM ratings AS r
    JOIN users AS u
        ON r.user_id = u.user_id
    WHERE u.occupation = 'student'

    EXCEPT

    SELECT r.movie_id
    FROM ratings AS r
    JOIN users AS u
        ON r.user_id = u.user_id
    WHERE u.occupation = 'programmer'
) AS student_only;
