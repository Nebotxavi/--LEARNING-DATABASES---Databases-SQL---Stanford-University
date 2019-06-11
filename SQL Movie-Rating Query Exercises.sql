#1 Find the titles of all movies directed by Steven Spielberg. 

SELECT title
FROM movie
WHERE director = 'Steven Spielberg';

#2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

SELECT DISTINCT year
FROM movie AS m, rating AS r
WHERE m.mID = r.mID AND
      stars >= 4
ORDER BY year;

#3 Find the titles of all movies that have no ratings. 

SELECT title
FROM movie
WHERE mID NOT IN (SELECT mID FROM rating);

#4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 

SELECT name
FROM reviewer AS rev, rating AS r
WHERE rev.rID = r.rID AND
      ratingDate IS NULL;

#5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

SELECT name, title, stars, ratingDate
FROM reviewer AS rev, movie AS m, rating AS r
WHERE rev.rID = r.rID AND
      m.mID = r.mID 
ORDER BY name, title, stars;

#6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 

SELECT DISTINCT name, title
FROM reviewer AS rev, movie AS m, rating AS r1, rating AS r2
WHERE rev.rID = r1.rID AND
      m.mID = r1.mID AND
      r1.rID = r2.rID AND
      r1.mID = r2.mID AND
      r1.stars > r2.stars AND
      r1.ratingDate > r2.ratingDate;

#7 For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

SELECT title, stars
FROM movie, rating
WHERE movie.mID = rating.mID
GROUP BY title
ORDER BY title;

#8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

SELECT title, max(stars) - min(stars) as str
FROM movie AS m, rating AS r1
WHERE m.mID = r1.mID  
GROUP BY title
ORDER BY str DESC, title;

#9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

SELECT AVG(avg_old.avg_rating) - AVG(avg_new.avg_rating)
FROM (SELECT AVG(stars) as avg_rating
      FROM rating AS r, movie AS m
      WHERE r.mID = m.mID AND
            year < 1980
      GROUP BY r.mID) AS avg_old, 
     (SELECT AVG(stars) AS avg_rating
      FROM rating AS r, movie AS m
      WHERE r.mID = m.mID AND
            year > 1980
      GROUP BY r.mID) as avg_new;
