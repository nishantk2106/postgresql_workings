-- Lab Exam 3a Q1
-- Write an SQL query which returns the ID of the object in the labex3poly table which is farthest away (in meters) from any object
-- in the labex3traffic table. Moodle will require the ID of this object. 

-- 10014
SELECT t.id,t.name, b.id, b.name, ST_Distance(ST_Transform(t.geom,3035),ST_Transform(b.geom,3035)) as Distance
FROM labex3traffic as t, labex3poly as b
ORDER BY Distance desc;

SELECT t.id,t.name, b.id, b.name, ST_Transform(t.geom,3035)<->ST_Transform(b.geom,3035) as Distance
FROM labex3traffic as t, labex3poly as b
ORDER BY Distance desc;

-- Lab Exam 3a Q2
-- Write an SQL query which returns the distance between the two points in the LabExam3traffic table which are closest to each other, measured in meters. You shoud provide this distance to Moodle. 
-- You should round down to the nearest integer.

-- ANS = 10 

SELECT t.id,t.name, t1.id, t1.name, ST_Distance(ST_Transform(t.geom,3035),ST_Transform(t1.geom,3035)) as Distance
FROM labex3traffic as t, labex3traffic as t1
WHERE (t1.id != t.id) and (t1.name < t.name)
ORDER BY Distance asc;

SELECT t.id,t.name, t1.id, t1.name, ST_Transform(t.geom,3035)<-> ST_Transform(t1.geom,3035) as Distance
FROM labex3traffic as t, labex3traffic as t1
WHERE (t1.id != t.id) and (t1.name < t.name)
ORDER BY Distance asc;


-- Lab Exam3a Q3
-- Using a SELF-JOIN write a query which returns the distance measurement between the two objects in the LabExamPoly table which are farthest away from each other. 
-- YOu should use ST_Distance to measure the distance. You should provide your answer, correct to the nearest integer. 

-- 492 or 493 are accepted. 

SELECT p1.id,p1.name,p2.id,p2.name, ST_Distance(ST_Transform(p1.geom,3035),ST_Transform(p2.geom,3035)) as Distance
FROM LabEx3Poly as p1, LabEx3Poly as p2
WHERE (p1.id != p2.id) and (p1.name > p2.name)
ORDER BY Distance desc;

-- this will give incorrect values depending on the version of postgis. 
SELECT p1.id,p1.name,p2.id,p2.name, ST_Transform(p1.geom,3035) <->ST_Transform(p2.geom,3035) as Distance
FROM LabEx3Poly as p1, LabEx3Poly as p2
WHERE (p1.id != p2.id) and (p1.name > p2.name)
ORDER BY Distance desc;


-- Lab Exam3a Q4
-- -- Using a SELF-JOIN write a query which returns the distance measurement between the two objects in the LabExamPoly table which are farthest away from 
-- each other. The names of the two polygon objects must begin with one UPPERCASE alphabetical character. YOu should use ST_Distance to measure the distance. You should provide your answer, correct to the nearest integer. 

-- 300 OR 301 ARE ACCEPTED
SELECT p1.id,p1.name,p2.id,p2.name, ST_Distance(ST_Transform(p1.geom,3035),ST_Transform(p2.geom,3035)) as Distance
FROM LabEx3Poly as p1, LabEx3Poly as p2
WHERE (p1.id != p2.id) and (p1.name < p2.name) and (p1.name ~ '^[A-Z].*$') and (p2.name ~ '^[A-Z].*$')
ORDER BY Distance desc;

-- Lab Exam3a Q5
-- Using a SELF-JOIN write a query which returns the number of pairs of buildings in the LabEx3Poly table which have bounding boxes/rectangles which intersect each other. 
-- You will need to supply the number of rows returned to Moodle. 
-- 1 row
SELECT p1.id,p1.name,p2.id,p2.name, (p1.geom && p2.geom)
FROM LabEx3Poly as p1, LabEx3Poly as p2
WHERE (p1.id != p2.id) and (p1.name > p2.name) and (p1.geom && p2.geom)

-- LabExam3a Q6
-- Write an SQL query to find the ID of the road segment in the LabExam3Roads table which has the largest number of points. You must provide the ID of the object and NOT the number
-- of points. 
-- ANS 19444
-- 
SELECT r.id, ST_NPoints(r.geom) as n
FROM LabEx3Roads as r
order by n desc;


-- LabExam3a Q7
-- Write an SQL query to find number of building objects in the LabExam3Poly table which contain less than then points or nodes. The Moodle Quiz will require you specify how many such objects are in the LabExam3Poly table. 
-- ANS 10019
-- 13 OBJECTS 
SELECT r.id, ST_NPoints(r.geom) as n
FROM LabEx3Poly as r
WHERE ST_NPoints(r.geom) < 10
order by n desc;



