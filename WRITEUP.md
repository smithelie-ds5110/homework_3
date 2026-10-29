
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

