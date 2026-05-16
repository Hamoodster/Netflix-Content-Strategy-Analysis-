-- creating tables

CREATE TABLE IF NOT EXISTS staging_netflix (
    show_id       VARCHAR(10),
    type          VARCHAR(20),
    title         TEXT,
    director      TEXT,
    "cast"        TEXT,
    country       TEXT,
    date_added    TEXT,
    release_year  INT,
    rating        VARCHAR(20),
    duration      VARCHAR(20),
    listed_in     TEXT,
    description   TEXT
);

-- verifying csv was imported correctly in compliance with tables

SELECT * FROM staging_netflix LIMIT 5;

-- Type dimension (Movie or TV Show)
CREATE TABLE dim_type (
type_id   SERIAL PRIMARY KEY,
type_name VARCHAR(20) UNIQUE NOT NULL
);

-- Rating dimension (PG-13, TV-MA, etc.)
CREATE TABLE dim_rating (
rating_id   SERIAL PRIMARY KEY,
rating_name VARCHAR(20) UNIQUE NOT NULL
);

-- Country dimension
CREATE TABLE dim_country (
country_id   SERIAL PRIMARY KEY,
country_name TEXT UNIQUE NOT NULL
);
-- Genre dimension
CREATE TABLE dim_genre (
genre_id   SERIAL PRIMARY KEY,
genre_name TEXT UNIQUE NOT NULL
);

--fact table
CREATE TABLE fact_content (
    show_id      VARCHAR(10) PRIMARY KEY,
    title        TEXT NOT NULL,
    type_id      INT REFERENCES dim_type(type_id),
    rating_id    INT REFERENCES dim_rating(rating_id),
    country_id   INT REFERENCES dim_country(country_id),
    genre_id     INT REFERENCES dim_genre(genre_id),
    release_year INT,
    date_added   DATE,
    duration     VARCHAR(20),
    description  TEXT
);

--verifying eveyrthing works
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

---------------------------------------------
---------------------------------------------
---------------------------------------------
---------------------------------------------
-- ETL - Populating dimesnsion and fact tables

-- populating dim type
INSERT INTO dim_type (type_name)
SELECT DISTINCT type
FROM staging_netflix
WHERE type IS NOT NULL;

-- verifying
SELECT * FROM dim_type;

-- populate dim_rating
INSERT INTO dim_rating (rating_name)
SELECT DISTINCT rating
FROM staging_netflix
WHERE rating IS NOT NULL;

--Verify
SELECT * FROM dim_rating;

--Populate dim_country
INSERT INTO dim_country (country_name)
SELECT DISTINCT TRIM(SPLIT_PART(country, ',', 1))
FROM staging_netflix
WHERE country IS NOT NULL AND TRIM(country) != '';

--verify
SELECT * FROM dim_country LIMIT 10;

--Populate dim_genre
INSERT INTO dim_genre (genre_name)
SELECT DISTINCT TRIM(SPLIT_PART(listed_in, ',', 1))
FROM staging_netflix
WHERE listed_in IS NOT NULL AND TRIM(listed_in) != '';

--verify
SELECT * FROM dim_genre LIMIT 10;

--Populate fact_content
INSERT INTO fact_content (
show_id,
title,
type_id,
rating_id,
country_id,
genre_id,
release_year,
date_added,
duration,
description
)
SELECT
s.show_id,
s.title,
t.type_id,
r.rating_id,
c.country_id,
g.genre_id,
s.release_year,
TO_DATE(NULLIF(TRIM(s.date_added), ''), 'Month DD, YYYY'),
s.duration,
s.description
FROM staging_netflix s
LEFT JOIN dim_type t 
ON t.type_name = s.type
LEFT JOIN dim_rating r 
ON r.rating_name = s.rating
LEFT JOIN dim_country c 
ON c.country_name = TRIM(SPLIT_PART(s.country, ',', 1))
LEFT JOIN dim_genre g 
ON g.genre_name = TRIM(SPLIT_PART(s.listed_in, ',', 1));

--verify
SELECT COUNT(*) FROM fact_content;

