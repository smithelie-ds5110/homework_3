
# Homework 3 — Writeup

## Step 0 — Describe the Raw Data

### u.user

For the u.user dataset, the shape is (943, 5) and each row represents a user and the data is tidy. 
The README leaves out the fact that the zip code should be loaded as a string to preserve leading zeros.
The README does not specify types. The README incorrectly states that the data is tab delimited when, in fact, it is pipe delimited.

### u.item

For the u.item dataset, the shape is (1682, 24). Each row represents a movie and the data is not tidy because the 
values of what should be genre are represented as their own individual columns. The README incorrectly states that the data is tab delimited when, in fact, it is pipe delimited. The README also left out the fact that the encoding used is Latin-1. The README does not specify types. There are also missing values across release date, video release date and IMDb URL.

### u.data

For the u.data dataset, the shape is (100000, 4). Each row represents a user rating for a movie. The data is tidy. The README does not specify types beyond the timestamp being epoch time.

### Chart 1 — Distribution of Ratings

![Distribution of Movie Ratings](figures/rating_distribution.png)

This chart shows us the distribution of movie ratings.
This chart suggests that ratings are skewed positively. It may be worth investigating if any groups are driving this.

### Chart 2 — Number of Users by Occupation

![Number of Users by Occupation](figures/users_by_occupation.png)

This chart shows the distribution of MovieLens users across occupations.
It can answer questions around if any particular group is overrepresented in the data. In this case, students are.

## Step 2 — Describe the Raw Data

### 2(a) - The six-table SQLite schema is documented in the [Database Schema](README.md#database-schema) section of the README.

### 2(b) - The original u.item file represents genres using 19 binary columns, with each column indicating whether a movie belongs to a particular genre.
I normalized this representation into two tables: genres, which stores the genre IDs and names, and movie_genres, which stores one row per movie–genre association. This allows a movie to belong to multiple genres without requiring a separate column for each genre.
This design is tidy because each row represents a single movie-genre association. It also avoids hardcoding the 19 genres into the table structure. The composite primary key (movie_id, genre_id) prevents duplicate associations, while foreign keys ensure that each association references an existing movie and genre.

### 2(c) - Constraints and Validation
The schema uses STRICT tables, primary and foreign keys, NOT NULL, UNIQUE and CHECK constraints to enforce the following:
- Valid ratings (1–5), positive ages and timestamps, and gender codes (M/F).
- Nonblank movie titles, ZIP codes and genre names.
- Unique IDs, genre names, user–movie rating pairs and movie–genre pairs.
- Valid references between users, occupations, movies, ratings and genres.

**Claims requiring separate validation:**
- Dataset counts: 943 users, 1,682 movies, and 100,000 ratings (COUNT(*)).
- At least 20 ratings per user (GROUP BY and HAVING).
- Complete and accurate loading of source records (compare source and database counts).

### 2(d) - I chose TEXT for zip because ZIP codes are identifiers rather than numerical values.
Storing them as numerical values may lead to leading zeros getting dropped. Using TEXT
preserves the source data as it existed in the raw data files.


## Step 3 — Load the data and keep what is refused

### 3a. Predictions (written before running `make`)

| Table | Expected rows | Source of the expectation |
|---|---|---|
| occupations | 21 | the 21 values listed in the README (`u.occupation`) |
| genres | 19 | the 19 genres in `u.genre` |
| users | 943 | README: 943 users |
| movies | 1,682 | README: 1,682 movies |
| movie_genres | not known in advance | one row per genre flag set to 1, so at least 1,682 if every movie has a genre |
| ratings | 100,000 | README: 100,000 ratings |

**Expected refusals:** none.

### 3e. Actual row counts vs. predictions

| Table | Predicted | Actual | Difference |
|---|---|---|---|
| occupations | 21 | 21 | none |
| genres | 19 | 19 | none |
| users | 943 | 943 | none |
| movies | 1,682 | 1,682 | none |
| movie_genres | unknown | 2,893 | not predictable in advance; higher than 1,682 because many movies belong to more than one genre |
| ratings | 100,000 | 100,000 | none |
| Rejected rows | 0 | 0 | none |

Every count matched the prediction and none of the rows were refused. However, there is one date `4-Feb-1971` with no leading zero. `load.py` converts every date to the ISO format (`1995-01-01`) so dates sort and are compared correctly in SQL.

## Step 4 

The README makes three claims about the dataset as a whole. A constraint on a single row or column cannot enforce them, so I wrote one query for each and ran it against the loaded database. The queries are saved in `sql/queries/` as `step4_1_totals.sql`, `step4_2_consecutive_ids.sql` and `step4_3_min_20_ratings.sql`, each with its predicted row count, actual row count and gap.

### Predictions

**Claim 1:** I predict one row showing 100,000 ratings, 943 users and 1,682 movies, because these are the numbers the README gives and our Step 3 load already produced exactly those row counts.

**Claim 2:** I predict two rows, one for users and one for movies, with a smallest id of 1 and a largest id equal to the row count, because ids are unique, so ids that start at 1 and end at the row count leave no room for a gap.

**Claim 3:** I predict one row with a smallest per-user rating count of at least 20 and no user below 20, because the README states that every user has rated at least 20 movies and our load lost no users or ratings.

### Results

**Claim 1: 100,000 ratings, 943 users, 1,682 movies.** The query returned exactly these numbers, so the claim is confirmed. They also match the Step 3 load counts.

**Claim 2: ids are consecutive from 1.** Ids are unique, so they are consecutive exactly when the smallest id is 1 and the largest equals the row count. Users run from 1 to 943 with 943 rows, and movies from 1 to 1,682 with 1,682 rows, so the claim is confirmed. The count alone would miss a gap such as ids 1, 2, 4.

**Claim 3: every user has rated at least 20 movies.** The fewest ratings by any user is 20 and no user is below 20, so the claim is confirmed. The minimum is exactly 20 which matches the README.

All three predictions were correct, so there was no gap to explain.

## Step 5 — Answer questions in SQL

**Q1 - Ten movies with the most ratings**

Predicted rows: 10

Actual rows: 10

The query returned exactly 10 movies, matching the prediction. Star Wars (1977) received the most ratings with 583. I used COUNT(*) to count ratings per movie and sorted the results in descending order. Ties are resolved using movie_id ASC, ensuring deterministic results. There was no difference between the predicted and actual row counts.

**Q2 — Mean rating by occupation**

Predicted rows: 7

Actual rows: 7

The query returned seven occupations with at least 50 distinct raters, matching the prediction. 
Educators had the highest mean rating at 3.671, while students had the lowest among the qualifying occupations at 3.515. 
I used COUNT(DISTINCT user_id) to count unique raters rather than individual ratings. 
The minimum rater condition belongs in HAVING because it filters aggregated groups. 
WHERE would be used to filter individual records before grouping but no such filtering was needed here. 
There was no difference between the predicted and actual row counts.

**Q3 — ZIP codes that do not begin with a digit**

Predicted rows: 1  

Actual rows: 1  

Users identified: 18

The query identified 18 users whose ZIP codes do not begin with a digit. 
The predicted and actual row counts matched because the aggregate query returns one row. 
Storing ZIP codes as TEXT preserves nonnumeric characters and leading zeros. If ZIP codes had been stored as INTEGER, these values could not have been represented. 
In a STRICT SQLite table, nonnumeric ZIP codes would be rejected rather than preserved, so the original count of 18 would have disappeared.

**Q4 — Ratings by Genre**

Predicted rows: 19  
Actual rows: 19  
Gap: None.

The query returned all 19 genres, matching the prediction. Drama had the most ratings (39,895), while Film-Noir had the highest mean rating (3.922).
The sum of ratings across all genres was 212,595, compared with the 100,000 individual ratings in the MovieLens dataset. 
The difference of 112,595 occurs because movies can belong to multiple genres, so each individual rating contributes to the count of every genre associated with that movie.
This is an expected result of the many-to-many relationship between movies and genres, not duplicate ratings or a data-quality issue.

**Q5 — Ratings per Calendar Month**

Predicted rows: 12  

Actual rows: 8

Gap: 4.

I predicted 12 rows, assuming the dataset spanned one year. 
However, the query returned eight calendar months, spanning September 1997 through April 1998. November 1997 had the most ratings (23,980).
The difference occurred because the dataset covers eight calendar months rather than the full year I initially expected. 
I used SQLite's `strftime()` with the `unixepoch` argument to convert Unix timestamps into year-month values before grouping. 
The monthly counts sum to exactly 100,000, confirming that all ratings were accounted for.

















## Step 6 — Build a query from named steps

**6a. Steps and row counts**

| Step | What it does | Rows |
|---|---|---|
| movie_stats | mean and count of ratings per movie, movies with 30+ ratings are kept | 806 |
| genre_stats | mean of all ratings given to movies in each genre | 19 |
| movie_vs_genre | each of those movies joined to each of its genres | 1,610 |
| winners (final) | pairs where the mean of the movie is at least 0.5 above the mean of its genre | 147 |

**6b. Several genres per movie.** We decided to compare each movie with each of its genres. This ultimately means that a movie can appear once per genre where its average rating is at least 0.5 above the aberage of that genre. Picking only one genre wouldn't really make sense in my opinion, because the data has no "main" genre and we would susbequently throw away information. 

**6c. Nested subquery.** `step6_nested.sql` gives us the same 147 rows as the CTE version. I would rather debug the CTE version because I can run and check each named sep individually, while the in the nested version we have to start on the inside and work our way outwards.



## Step 7 — Missing Values in SQL and in pandas

### 7a.

Only the `movies` table has NULLs, in three columns:

- `release_date`: 1 NULL (movie 267, "unknown"). The release date is not known.
- `video_release_date`: 1,682 NULLs, every movie. A video release date was never recorded.
- `imdb_url`: 3 NULLs (movies 267, 1358, 1359). No URL was given in the file.

In each column NULL means unknown or not recorded, not zero or empty. No other column has NULLs.

### 7b. 

`step7_b1.sql` lists movies whose release date differs from every unknown-genre movie's release date.

- The subquery returns two values: 4-Feb-1971 and NULL.
- `x NOT IN (a, NULL)` means `x <> a AND x <> NULL`.
- Comparing to NULL gives UNKNOWN. This means the condition is never true
- Result: 0 rows , no errors

`step7_b2.sql` asks the same question with `NOT EXISTS`. It checks each movie for a matching row and never compares to NULL.
- Result: 1,681 rows, every movie except "Good Morning (1971)". This means that the date matches itself.

A NULL in the subquery breaks `NOT IN` but not `NOT EXISTS`.

The difference:
x NOT IN (a, NULL) means x <> a AND x <> NULL, and x <> NULL is UNKNOWN, so no row is ever TRUE. NOT EXISTS only checks whether a matching row exists and ignores NULL.

### 7c. 

I read `movies`, the only table with NULLs.

- `movie_id` is `int64`.
- `title`, `release_date` and `imdb_url` are `str`.
- `video_release_date` is `object`

Every value is missing, so pandas has nothing to infer a type from. Missing counts match SQLite
- `release_date` 1, `video_release_date` 1,682, - - `imdb_url` 3
- NULL in SQLite becomes NaN in pandas.

 No integer column had a NULL, so no numnber became float.

### 7d.

I redid Q2, the mean rating/occupation with at least 50 raters. 

The counts do not differ:
- The pandas result has the same 7 rows, counts and means as the SQL query, so there was no difference to investigate.
- Means: educator 3.671, administrator 3.636, programmer 3.568, librarian 3.561, other 3.552, engineer 3.541, student 3.515.
- I counted raters with `nunique`. Counting rows would count ratings instead.
- I merged with `validate="m:1"`, so a duplicated key raises an error instead of silently changing the row count.


## Step 8 — Where SQL earns its place

The Step 6 query would have been the most awkward in pandas. The genres are present in a separate table, which means that Pandas would need several merges and `groupby`s. Additionally, each merge can accidentally duplicate rows which is not ideal. In SQL, on the other hand, the joins and grouping follow a clear sequence of named steps. This makes our life a lot easier in the sense that we can count the rows after each step to ensure that the join between movies and genres is correct.
