USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    COUNT(*) AS No_of_rows_Names
FROM
    names;
-- Coclusion :Number of Rows in Names : 25735

SELECT 
    COUNT(*) AS No_of_rows_Director_mapping
FROM
    director_mapping;
-- Coclusion :Number of Rows in Director mapping : 3867

SELECT 
    COUNT(*) AS No_of_rows_Role_mapping
FROM
    role_mapping;
-- Conclusion :Number of Rows in Role mapping : 15615

SELECT 
    COUNT(*) AS No_of_rows_Genre
FROM
    genre;
-- Conclusion :Number of Rows in Genre : 14662

SELECT 
    COUNT(*) AS No_of_rows_Movie
FROM
    movie;
-- Conclusion :Number of Rows in Movie : 7997

SELECT 
    COUNT(*) AS No_of_rows_Ratings
FROM
    ratings;
-- Conclusion :Number of Rows in Ratings : 7997

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- To Count how many null values and which column as null values 
SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS ID_NULL_COUNT,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_NULL_COUNT,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_NULL_COUNT,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_NULL_COUNT,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_NULL_COUNT,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_NULL_COUNT,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worlwide_gross_income_NULL_COUNT,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_NULL_COUNT,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_NULL_COUNT
FROM
    movie; 

-- Conclusion - Column with null values - Country, world_gross_income, languages, production_company

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Output for first part question :
-- Finding Year Count using GROUP BY :
SELECT 
    Year, COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY Year
ORDER BY Year;

-- Conclusion : Year 2017 released most highest number of movies : 3052 movies

-- Output for second part question :
-- Finding movie count using GROUP BY and arranging in Month wise using ORDER BY :
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(title) AS number_of_movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);

-- Conclusion : Month - March month released most highest number of movies : 824 movies

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Finding Country using LIKE Operator 
SELECT 
    COUNT(title) AS No_of_movies, Year
FROM
    movie
WHERE
    (country LIKE '%INDIA%'
        OR country LIKE '%USA%')
        AND year = 2019; 

-- Conclusion : Total Movies produced in USA (or) India on Year 2019 : 1059
-- Note : Using LIKE Operator because in Data base found two countries for each Title

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Finding Unique genre using DISTINCT Keyword

SELECT DISTINCT
    (genre) AS Unique_genre
FROM
    genre;

-- Conclusion : Number of Genre present in Data : 13


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Genre produced with Highest number of Movie : Drama
-- Finding Highest Movies in Genre by using ORDER BY DESC with LIMIT 
SELECT 
    genre AS Genre, COUNT(movie_id) AS No_of_Movies
FROM
    genre
GROUP BY genre
ORDER BY COUNT(movie_id) DESC
LIMIT 1;

-- Genre : Drama produced Highest number of Movies : 4285

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Number of movies with single genre :
-- Number of Movies found using COUNT along with HAVING Operator :
WITH No_of_single_movies AS (
SELECT movie_id , COUNT(movie_id) AS No_of_movie_for_genre
FROM genre
GROUP BY movie_id 
HAVING COUNT(movie_id) = 1
)
SELECT COUNT(*) AS No_of_movies_single_genre
FROM No_of_single_movies ;

-- Conclusion :Number of movies with single genre :3289

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Finding Average duration comparing with Genre from another table using INNER JOIN :
SELECT 
    genre AS Genre, ROUND(AVG(duration), 2) AS avg_duration
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
GROUP BY genre
ORDER BY ROUND(AVG(duration), 2) DESC; 

-- Conclusion : Action genre movies has highest average duration of 112.88 mins with next place with Romance with 109.53 mins.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Rank found with RANK Function which done with ORDER BY and GROUP BY Function 
WITH Genre_Movie AS (
SELECT genre, 
       Count(movie_id) AS movie_count ,
       Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
FROM genre                                 
GROUP BY   genre )
SELECT *
FROM Genre_Movie
WHERE  genre = "Thriller" ;

-- Conclusion : Thriller Genre movies placed in 3rd Rank with Movie count : 1484 

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

--  Finding Minimum and Maximum using min and max :

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;

-- Conclusion : All minimum and maximum vales found using MIN and MAX function .

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


-- Top 10 movies found using DENSE_RANK : 

SELECT title , ROUND((avg_rating),1) AS avg_rating, 
	   DENSE_RANK() OVER(ORDER BY ROUND((avg_rating),1) DESC ) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
ORDER BY ROUND((avg_rating),1) DESC
LIMIT 10;

-- OR -- With using RANK Function :

SELECT title , ROUND((avg_rating),1) AS avg_rating, 
	   RANK() OVER(ORDER BY ROUND((avg_rating),1) DESC ) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
ORDER BY ROUND((avg_rating),1) DESC
LIMIT 10;

-- Top 10 movies with Ranking done with RANK and DENSE_RANK Function

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Median Rating Count done with COUNT for counting Movie Count
-- Top Ratings check by ORDER BY with DESC descending Function 

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY COUNT(movie_id) DESC;

-- Median Rating 7 found to highest number of Movies : 2257


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


WITH production_company_hits AS (
SELECT production_company, COUNT(id) AS movie_count,
       DENSE_RANK () OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM movie AS m 
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE avg_rating > 8 AND production_company IS NOT null
GROUP BY production_company
)
SELECT * 
FROM production_company_hits
WHERE prod_company_rank = 1;

-- Conclusion : Highest Hit Production company is Dream Warrier and National Theatre Live

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Highest movie count found using INNER JOIN for more than 2 table 

SELECT 
    genre, COUNT(m.id) AS movie_count
FROM
    movie AS m
        INNER JOIN
    genre AS g ON g.movie_id = m.id
        INNER JOIN
    ratings AS r ON r.movie_id = m.id
WHERE
    year = 2017
        AND MONTH(date_published) = 3
        AND country LIKE '%USA%'
        AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC; 

-- Conclusion : Highest Movie count based on Genre is Drama with 24 movie ( In USA in March 2017 with votes more than 1000 votes )

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    title, avg_rating, genre
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    title LIKE 'THE%' AND avg_rating > 8
ORDER BY avg_rating DESC;

-- Conclusion : There total 8 movies starts with 'The' and 'The Brighton Miracle' movie has highest rating of 9.5 


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- Movies released between year found using BETWEEN Condition in Query 

SELECT 
    COUNT(*) AS movie_count, median_rating
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON r.movie_id = m.id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- Conclusion : Total 361 movies released between '2018-04-01' and '2019-04-01' with median rating is 8


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Total Votes can be found using SUM Function 

SELECT 
    country, SUM(total_votes) AS Total_vote
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    country IN ('Germany' , 'Italy')
GROUP BY country;

-- Conclusion : Germany has Total votes - 106710 and Italy has Total votes - 77965 ( Germany > Italy )
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Null values found with each individual columns 

SELECT 
    COUNT(*) AS name_nulls
FROM
    names
WHERE
    name IS NULL;
-- Conclusion : Total Null in name columns : 0

SELECT 
    COUNT(*) AS height_nulls
FROM
    names
WHERE
    height IS NULL;
-- Conclusion : Total Null in height columns : 17335

SELECT 
    COUNT(*) AS date_of_birth_nulls
FROM
    names
WHERE
    date_of_birth IS NULL;
-- Conclusion : Total Null in date_of_birth columns : 13431

SELECT 
    COUNT(*) AS known_for_movies_nulls
FROM
    names
WHERE
    known_for_movies IS NULL;
-- Conclusion : Total Null in known_for_movies columns : 15226


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH Top_3_genre AS (
	SELECT genre, COUNT(g.movie_id) as movie_count 
    FROM genre AS g 
		INNER JOIN ratings AS r 
			ON g.movie_id=r.movie_id 
    WHERE avg_rating > 8 
    GROUP BY genre 
    ORDER BY movie_count DESC
    LIMIT 3
)
SELECT 
    name AS director_name, COUNT(dm.movie_id) AS movie_count
FROM
    director_mapping AS dm
	INNER JOIN names AS n 
		ON dm.name_id = n.id
	INNER JOIN ratings AS r 
		ON dm.movie_id = r.movie_id
	INNER JOIN genre AS g 
		ON dm.movie_id = g.movie_id
	INNER JOIN Top_3_genre AS t 
		ON g.genre = t.genre
WHERE
    avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;

-- Conclusion : James Mangold has highest number of movies with 4 movies count 

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Finding Top two Actors names 

WITH Actor_name AS (
	SELECT name_id AS nid, COUNT(rp.movie_id) AS movie_count 
    FROM role_mapping AS rp 
		INNER JOIN ratings AS r 
			ON rp.movie_id = r.movie_id 
    WHERE category = 'actor' AND median_rating >= 8 
    GROUP BY nid
)
SELECT name AS actor_name, movie_count 
FROM Actor_name AS act 
	INNER JOIN names AS n 
		ON act.nid = n.id  
ORDER BY movie_count DESC 
LIMIT 2;


-- Conclusion : Top two actors are - 1.Mammootty     2.Mohanlal 

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Find Top 3 Production house name :

SELECT production_company , SUM(total_votes) AS vote_count, 
	   RANK() OVER(ORDER BY SUM(total_votes) DESC ) AS prod_comp_rank
FROM movie AS m
	INNER JOIN ratings AS r
		ON m.id = r.movie_id
WHERE production_company IS NOT NULL 
GROUP BY production_company 
ORDER BY vote_count DESC 
LIMIT 3; 

-- Conclusion - Top Production House with Maximum number of votes is Marvel studios with 2656967 votes. 

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_summary AS (
SELECT     n.NAME AS actor_name,
		   SUM(total_votes) AS total_votes,
		   COUNT(r.movie_id) AS movie_count,
           ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating
FROM movie AS m
	INNER JOIN ratings AS r
		ON m.id=r.movie_id
	INNER JOIN role_mapping AS rm
		ON m.id = rm.movie_id
	INNER JOIN names AS n
		ON rm.name_id = n.id
WHERE  category = 'ACTOR'
       AND country = "INDIA"
GROUP  BY NAME
HAVING movie_count >= 5
)
SELECT *,
       Rank() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_summary ; 

-- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS (
SELECT     n.NAME AS actress_name,
		   SUM(total_votes) AS total_votes,
		   COUNT(r.movie_id) AS movie_count,
           ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating
FROM movie AS m
	INNER JOIN ratings AS r
		ON m.id=r.movie_id
	INNER JOIN role_mapping AS rm
		ON m.id = rm.movie_id
	INNER JOIN names AS n
		ON rm.name_id = n.id
WHERE category = 'ACTRESS'
	  AND country = "INDIA"
	  AND languages LIKE '%HINDI%'
GROUP BY NAME
HAVING movie_count >= 3 
)
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM actress_summary LIMIT 5;

-- Conclusion -Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Thirller movie category done with CASE 

SELECT title AS movie_name, avg_rating,
	CASE 
		WHEN avg_rating > '8' THEN 'Superhit movies'
        WHEN avg_rating BETWEEN '7' AND '8' THEN 'Hit movies'
		WHEN avg_rating BETWEEN '5' AND '7' THEN  'One-time-watch movies'
		ELSE 'Flop movies'
	END AS thriller_movie_classification
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id=g.movie_id 
INNER JOIN ratings AS r 
ON g.movie_id = r.movie_id 
WHERE genre = 'Thriller';

-- Conclusion - Additional column added as thriller_movie_classification for Movie classification

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- genre-wise running total and moving average of the average movie duration is calculated with unbounded preceding
 
SELECT genre, 
       ROUND(AVG(duration),3) AS avg_duration, 
	   ROUND(SUM(AVG(duration)) OVER( ORDER BY genre ROWS UNBOUNDED PRECEDING),3) AS running_total_duration, 
       ROUND(AVG(AVG(duration)) OVER( ORDER BY genre ROWS UNBOUNDED PRECEDING),3) AS moving_avg_duration  
FROM movie AS m 
	INNER JOIN genre AS g 
		ON m.id = g.movie_id 
GROUP BY genre 
ORDER BY genre;

-- Conclusion - Action genre has highest average duration among all genre

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

SELECT * 
FROM ( WITH genre_based AS (
	SELECT genre 
    FROM genre 
    GROUP BY genre 
    ORDER BY COUNT(movie_id) DESC 
    LIMIT 3
)
SELECT genre, 
       year, 
       title, 
       worlwide_gross_income, 
       DENSE_RANK() OVER(PARTITION BY  genre, year ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank 
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id = g.movie_id 
WHERE genre IN (SELECT * FROM genre_based)
) AS main WHERE main.movie_rank < 6;

--  Conclusion - Based on Top 3 genre ( Comedy , Drama, Thriller ) in year-wise found top 5 movies highest gross income 

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- top two production houses that have produced with among multilingual movies is found using LIKE Operator 

SELECT production_company, 
	   COUNT(id) as movie_count, 
       DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank 
FROM movie AS m 
INNER JOIN ratings AS r 
ON m.id = r.movie_id 
WHERE median_rating >= 8 
	  AND production_company is not null 
      AND languages LIKE '%,%' 
GROUP BY production_company 
LIMIT 2;

-- Conclusion - Top two production house are - 1. Star Cinema    2. Twentieth century fox

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT name AS actress_name, 
       SUM(total_votes) AS total_votes, 
       COUNT(rm.movie_id) AS movie_count, 
       ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
       ROW_NUMBER() OVER ( ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actress_rank 
FROM role_mapping AS rm 
	INNER JOIN names AS n 
		ON rm.name_id = n.id 
	INNER JOIN ratings AS r 
		ON rm.movie_id = r.movie_id 
	INNER JOIN genre AS g 
		ON rm.movie_id = g.movie_id 
WHERE category = 'actress' 
     AND genre = 'Drama' 
     AND avg_rating > 8 
GROUP BY actress_name LIMIT 3;

-- Conclusion - Top 3 actresses based on number of Super Hit movies are Sangeetha Bhat, Fathmire Sahiti, Adrianan Matoshi


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_details AS (
SELECT name_id AS director_id, 
       name AS director_name, 
       dm.movie_id AS movie_id, 
       avg_rating, 
       date_published, 
       LEAD(date_published,1) over(PARTITION BY name_id ORDER BY date_published) AS next_movie_date, 
       DATEDIFF(lead(date_published,1) OVER(PARTITION BY name_id ORDER BY date_published),date_published) AS inter_movie_days, 
	   duration, 
       total_votes 
FROM director_mapping AS dm 
INNER JOIN movie AS m 
ON dm.movie_id = m.id 
INNER JOIN names AS n 
ON dm.name_id = n.id 
INNER JOIN ratings AS r 
ON dm.movie_id = r.movie_id 
ORDER BY director_id
)
SELECT director_id, 
	   director_name, 
       COUNT(movie_id) AS number_of_movies, 
       ROUND(AVG(inter_movie_days)) AS avg_inter_movie_days, 
       SUM(avg_rating * total_votes)/SUM(total_votes) AS avg_rating, 
       SUM(total_votes) AS total_votes, 
       MIN(avg_rating) AS Min_rating, 
       MAX(avg_rating) AS Max_rating, 
       SUM(duration) AS total_duration 
FROM director_details 
GROUP BY Director_id 
ORDER BY number_of_movies DESC LIMIT 9;

-- 	Conclusion - Director details with id and name and other details taken using common table expression.
