#1  Find the names of all reviewers who rated Gone with the Wind. 

SELECT DISTINCT name
FROM reviewer AS rev, movie AS m, rating AS r
WHERE rev.rID = r.rID AND
      m.mID = r.mID AND
      title = 'Gone with the Wind';

#2 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 

SELECT name, title, stars
FROM reviewer AS rev, movie AS m, rating AS r
WHERE rev.rID = r.rID AND
      m.mID = r.mID AND
      rev.name = m.director;

#3 Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 

SELECT name AS "Names and movies"
FROM reviewer
UNION 
SELECT title
FROM movie
ORDER BY name;

#4 Find the titles of all movies not reviewed by Chris Jackson. 

SELECT DISTINCT title
FROM movie
WHERE mID NOT IN (SELECT movie.mID 
            FROM movie, reviewer, rating 
            WHERE movie.mID = rating.mID AND 
                  reviewer.rID = rating.rID AND 
                  name = 'Chris Jackson');

#5 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 

SELECT DISTINCT rev1.name, rev2.name
FROM rating AS r1, rating AS r2, reviewer AS rev1, reviewer AS rev2
WHERE r1.mID = r2.mID AND
      rev1.name < rev2.name AND
      rev1.rID = r1.rID AND
      rev2.rID = r2.rID
ORDER BY rev1.name;

#6 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 

SELECT name, title, stars 
FROM movie AS m, reviewer AS rev, rating AS r
WHERE m.mID = r.mID AND
      rev.rID = r.rID AND
      r.stars = (SELECT MIN(stars) FROM rating);

#7 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 

SELECT title, AVG(stars)
FROM movie AS m, rating AS r
WHERE m.mID = r.mID
GROUP BY title
ORDER BY AVG(stars) DESC, title;

#8 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 

SELECT name
FROM reviewer AS rev, rating AS r
WHERE rev.rID = r.rID 
GROUP BY rev.rID
HAVING COUNT(stars) >= 3;

#9 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 

SELECT m.title, dirs.director
FROM movie AS m, (SELECT director
                    FROM movie
                    GROUP BY director
                    HAVING COUNT(director) > 1) AS dirs
WHERE m.director = dirs.director
ORDER BY dirs.director, title;

#10 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 

SELECT m.title, avg(r.stars) as avg_st
FROM movie m, rating AS r
WHERE m.mID = r.mID
GROUP BY m.mID
HAVING avg_st = (SELECT avg(r2.stars) avg_st2
                             FROM rating as r2
                             GROUP BY mID
                             ORDER BY avg_st2
                             DESC LIMIT 1)
                             
 # Option 2                            

SELECT title, AVG(stars) as rat
FROM movie, rating
WHERE movie.mID = rating.mID
GROUP BY title
HAVING rat IN (SELECT MAX(rat)
               FROM(SELECT title, AVG(stars) as rat
                    FROM movie, rating
                    WHERE movie.mID = rating.mID
                    GROUP BY title) as avg_st) 

#11 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 

SELECT m.title, AVG(r2.stars) as avg_st2
FROM rating AS r2, movie AS m
WHERE r2.mID = m.mID
GROUP BY r2.mID
HAVING avg_st2 = (SELECT AVG(stars) as avg_st
                 FROM rating AS r
                 GROUP BY r.mID
                 ORDER BY avg_st ASC LIMIT 1)

#12 For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 

SELECT director, title, MAX(stars)
FROM movie as m, rating AS r
WHERE director IS NOT NULL AND
      m.mID = r.mID
GROUP BY director;
