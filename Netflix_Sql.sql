use netflix_db

Create table Netflix (
		show_id Varchar(6),
		Type Varchar(10),
		Title varchar (150),
		Director varchar (208), 
		Cast varchar (1000),
		Country varchar(150),
		date_added varchar(50), 
		release_year INT,
		Rating varchar(10),
		Duration varchar (15), 
		Listed_in varchar(100),
		Description varchar(250)
);


select * from netflix_titles;

-- Count the number of movies vs tv show

select type, COUNT(type) as total_numbers
from netflix_titles
group by TYPe

-- find the most common rating for movies and tv show

select TYPE, rating 
from
(
select TYPE, rating, count(*) as total_numbers,
RANK() over(partition by type order by count(*) desc) as ranking
from netflix_titles
group by TYPE, rating
) as t1
where ranking = 1

-- list all movies released in a specific year(e.g., 2020)

select title
from Netflix_titles
where release_year = 2020 and type = 'movie';

-- Indentify the longest movie

select TYPE, MAX(duration) as longest_movie from netflix_titles
where type = 'movie' 
group by type

-- find content added in the last 5 years

SELECT *
FROM netflix_titles
WHERE TRY_CONVERT(date, date_added) >= DATEADD(year, -5, GETDATE());

-- find all the movies /TV shows by director 'Rajiv chilaka'

select TYPE,title,  director
from netflix_titles
where director like '%Rajiv chilaka%'

-- list all tv shows with more than 5 seasons

SELECT *
FROM netflix_titles
WHERE type = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;

-- count the number of content items in each genre


SELECT 
    count(show_id),
    LTRIM(RTRIM(value)) AS genre_name
FROM netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',')
group by LTRIM(RTRIM(value))

-- find each year and the average numbers of content release by India on netflix.

SELECT 
    nt.release_year,
    COUNT(*) AS total_content
FROM netflix_titles nt
CROSS APPLY STRING_SPLIT(nt.country, ',') c
WHERE LTRIM(RTRIM(c.value)) = 'India'
GROUP BY nt.release_year
ORDER BY total_content desc;

-- list all movies that are documentaries

select TYPE, title
from netflix_titles
where listed_in like '%documentaries%' and TYPE = 'movie'

-- find all content without a director

select * 
from netflix_titles
where director is null

-- find how many movies actor 'Salman Khan' appeared in last 10 years.

select *
from netflix_titles
where CAST like '%Salman Khan%' and release_year >= YEAR(Getdate()) - 10

-- find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT TOP 10
    LTRIM(RTRIM(ca.value)) AS actor_name,
    COUNT(*) AS total_movies
FROM netflix_titles nt
CROSS APPLY STRING_SPLIT(nt.country, ',') co
CROSS APPLY STRING_SPLIT(nt.cast, ',') ca
WHERE nt.type = 'Movie'
  AND LTRIM(RTRIM(co.value)) = 'India'
  AND nt.cast IS NOT NULL
GROUP BY LTRIM(RTRIM(ca.value))
ORDER BY total_movies DESC;	










select * from netflix_titles
 





-- 


