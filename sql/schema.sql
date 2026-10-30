PRAGMA foreign_keys = ON;

CREATE TABLE occupations (
    occupation TEXT PRIMARY KEY
) STRICT;

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    age INTEGER NOT NULL CHECK (age > 0),
    gender TEXT NOT NULL CHECK (gender IN ('M', 'F')),
    occupation TEXT NOT NULL REFERENCES occupations(occupation),
    zip_code TEXT NOT NULL CHECK (length(trim(zip_code)) > 0)
) STRICT;

CREATE TABLE movies (
    movie_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL CHECK (length(trim(title)) > 0),
    release_date TEXT,
    video_release_date TEXT,
    imdb_url TEXT
) STRICT;

CREATE TABLE genres (
    genre_id INTEGER PRIMARY KEY,
    genre_name TEXT NOT NULL UNIQUE CHECK (length(trim(genre_name)) > 0)
) STRICT;

CREATE TABLE ratings (
    user_id INTEGER NOT NULL REFERENCES users(user_id),
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    timestamp INTEGER NOT NULL CHECK (timestamp > 0),
    PRIMARY KEY (user_id, movie_id)
) STRICT;

CREATE TABLE movie_genres (
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    genre_id INTEGER NOT NULL REFERENCES genres(genre_id),
    PRIMARY KEY (movie_id, genre_id)
) STRICT;
