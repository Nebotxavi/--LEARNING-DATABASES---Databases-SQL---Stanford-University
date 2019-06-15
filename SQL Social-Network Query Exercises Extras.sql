#1  For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 

SELECT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM highschooler AS h1, likes AS l1, highschooler AS h2, likes AS l2, highschooler AS h3
WHERE h1.ID = l1.ID1 AND
h2.ID = l1.ID2 AND
h2.ID = l2.ID1 AND
h1.ID != l2.ID2 AND
h3.ID = l2.ID2;

#2  Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 

SELECT h1.name, h1.grade
FROM highschooler AS h1, friend AS f1
WHERE h1.ID = f1.ID1
EXCEPT
SELECT h2.name, h2.grade
FROM highschooler AS h2, friend AS f2, highschooler AS h3
WHERE h2.ID = f2.ID1 AND
h3.ID = f2.ID2 AND
h2.grade = h3.grade;

#3  What is the average number of friends per student? (Your result should be just one number.) 

SELECT AVG(amount)
FROM (SELECT COUNT(ID2) as amount
FROM friend
GROUP BY ID1);

#4  Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 

SELECT COUNT(DISTINCT ID1)
FROM (
SELECT h1.ID as ID1, h1.name AS name1, h2.name as name2, h3.name as name3
FROM highschooler AS h1, friend as f1, highschooler AS h2, friend as f2, highschooler AS h3
WHERE h1.ID = f1.ID1 AND
h2.ID = f1.ID2 AND
h2.ID = f2.ID1 AND
h3.ID = f2.ID2
)
WHERE (name2 = 'Cassandra' OR
name3 = 'Cassandra') AND
name1 != 'Cassandra';

#5  Find the name and grade of the student(s) with the greatest number of friends. 

SELECT name, grade
FROM highschooler AS h1, friend AS f1
WHERE h1.ID = f1.ID1
GROUP BY f1.ID1
HAVING COUNT(f1.ID2) = (SELECT MAX(f_count)
FROM (SELECT COUNT(f2.ID2) as f_count
FROM friend as f2
GROUP BY f2.ID1));
