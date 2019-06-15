#1  It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 

DELETE FROM highschooler
WHERE grade = 12;
Q2 (PENDING TO CHECK IF H1, H2 CAN BE REMOVED)
DELETE FROM likes
WHERE ID1 IN (SELECT DISTINCT h1.ID
FROM highschooler AS h1, friend AS f1, highschooler as h2, likes AS l1
WHERE h1.ID = f1.ID1 AND
h2.ID = f1.ID2 AND
h1.ID = l1.ID1 AND
h2.ID = l1.ID2 AND
h1.ID NOT IN (SELECT ID2
FROM likes
WHERE ID1 = h2.ID));

#2  If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 

DELETE FROM Likes
WHERE ID1 IN (SELECT ID1
FROM Friend AS f1
WHERE f1.ID1 = Likes.ID1 AND
f1.ID2 = Likes.ID2)
AND ID2 NOT IN (SELECT l1.ID1
FROM Likes AS l1
WHERE Likes.ID1 = l1.ID2 AND
Likes.ID2 = l1.ID1);

#3 For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 

INSERT INTO friend (ID1, ID2) 
SELECT ID1, ID3
FROM(
SELECT DISTINCT h1.ID AS ID1, h3.ID AS ID3
FROM highschooler as h1, friend as f1, highschooler as h2, friend as f2, highschooler AS h3
WHERE h1.ID = f1.ID1 AND
h2.ID = f1.ID2 AND
h2.ID = f2.ID1 AND
h3.ID = f2.ID2 AND
h3.ID != h1.ID AND
h1.ID NOT IN (SELECT f3.ID2
FROM friend as f3
WHERE h3.ID = f3.ID1)
);
