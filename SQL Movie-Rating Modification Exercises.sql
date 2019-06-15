#1  Add the reviewer Roger Ebert to your database, with an rID of 209. 

INSERT INTO reviewer (name, rID) VALUES ('Roger Ebert', 209);

#2  Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 

INSERT INTO Rating (rID, mID, stars)
SELECT rID, movie.mID, 5
FROM rating, movie
WHERE rID IN (SELECT rID
FROM reviewer
WHERE name = 'James Cameron');

#3  For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) 

UPDATE movie
SET year = year + 25
WHERE mID IN (SELECT m.mID
FROM movie AS m, rating AS r
WHERE m.mID = r.mID
GROUP BY m.mID
HAVING AVG(stars) >= 4)

#4  Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. 

DELETE FROM rating
WHERE mID IN (SELECT mID
FROM movie
WHERE year > 2000 OR
year < 1970)
AND stars < 4;
