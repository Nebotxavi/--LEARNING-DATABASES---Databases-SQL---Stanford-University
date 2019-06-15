#1  Find the names of all students who are friends with someone named Gabriel. 

SELECT h1.name
FROM highschooler AS h1, highschooler AS h2, friend AS f
WHERE h1.ID = f.ID1 AND
h2.ID = f.ID2 AND
h2.name = 'Gabriel';

#2  For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 

SELECT h1.name, h1.grade, h2.name, h2.grade
FROM highschooler AS h1, highschooler AS h2, likes AS l
WHERE h1.ID = l.ID1 AND
h2.ID = l.ID2 AND
h2.grade <= (h1.grade - 2);

#3  For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 

SELECT h1.name, h1.grade, h2.name, h2.grade
FROM highschooler AS h1, highschooler AS h2, likes AS l1, likes as l2
WHERE (h1.ID = l1.ID1 AND
h2.ID = l1.ID2) AND
(h2.ID = l2.ID1 AND
h1.ID = l2.ID2) AND
h1.name < h2.name
ORDER BY h1.name;

#4  Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 

SELECT DISTINCT name, grade
FROM highschooler
WHERE ID NOT IN (SELECT ID1 FROM likes)
AND ID NOT IN (SELECT ID2 FROM likes)
ORDER BY grade, name;

#5  For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 

SELECT h1.name, h1.grade, h2.name, h2.grade
FROM highschooler AS h1, highschooler AS h2, likes AS l1
WHERE h1.ID = l1.ID1 AND
h2.ID = l1.ID2 AND
h2.ID NOT IN (SELECT ID1 FROM likes);

#6  Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 

SELECT name, grade
FROM highschooler
EXCEPT
SELECT DISTINCT h1.name, h1.grade
FROM highschooler AS h1, highschooler AS h2, friend AS f
WHERE h1.ID = f.ID1 AND
h2.ID = f.ID2 AND
h2.grade != h1.grade
ORDER BY grade, name;

#7  For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 

SELECT DISTINCT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM highschooler AS h1, likes AS l1, highschooler AS h2, friend AS f1, highschooler AS h3, friend AS f2
WHERE h1.ID = l1.ID1 AND
h2.ID = l1.ID2 AND
h1.ID = f1.ID1 AND
h3.ID = f1.ID2 AND
h2.ID = f2.ID1 AND
h3.ID = f2.ID2 AND
h2.ID NOT IN (SELECT ID2
FROM friend
WHERE ID1 = h1.ID);

#8  Find the difference between the number of students in the school and the number of different first names. 

SELECT (SELECT count(ID) FROM highschooler) - count(name)
FROM (SELECT DISTINCT name FROM highschooler);

much simplier:
SELECT COUNT(ID) - COUNT(DISTINCT name)
FROM highschooler;

#9  Find the name and grade of all students who are liked by more than one other student. 

SELECT name, grade
FROM highschooler as h1, (
SELECT l1.ID2 as ID
FROM likes AS l1
GROUP BY l1.ID2
HAVING COUNT(l1.ID2) > 1
) as liked
WHERE h1.ID = liked.ID;
