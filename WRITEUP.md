
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
