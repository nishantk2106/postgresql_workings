-- Question 1
-- Which object has the most points in it's geometry

SELECT ST_NPoints(geom) as n, id from icelandroads ORDER BY n desc;
SELECT ST_NPoints(geom) as n, id from icelandbuildings ORDER BY n desc;
-- 44332211 has 30 points in roads
-- ID 12 has 34 in buildings. 


-- QUESTION 2
-- What is the ID of the object in the buildings dataset which is the FARTHEST in meters from any road?
-- You need to specify the ID of the object, rather than the distance. You must use EPSG:3035 in any ST

SELECT  ib.bldtype,ib.id, ir.name,ST_Transform(ib.geom,3035) <-> ST_Transform(ir.geom,3035) as distance
FROM icelandbuildings ib, icelandroads as ir
ORDER by distance desc;

-- QUESTION 3
-- Using a self-join what are the lampid values for the two lamposts which are FARTHEST away from each other in distance measured in meters. 

SELECT l1.lampid,l2.lampid,ST_Transform(l1.geom,3035) <-> ST_Transform(l2.geom,3035) as TheDistance
FROM icelandlamposts as l1, icelandlamposts as l2
WHERE (l1.id != l2.id) and (l1.lampid < l2.lampid)
ORDER BY TheDistance desc;

-- QUESTION 4
-- The same query as Question 3 except you can only consider lamposts where the lampid field or column contains only digits. 

SELECT l1.lampid,l2.lampid,ST_Transform(l1.geom,3035) <-> ST_Transform(l2.geom,3035) as TheDistance
FROM icelandlamposts as l1, icelandlamposts as l2
WHERE (l1.id != l2.id) and (l1.lampid < l2.lampid)
AND (l1.lampid ~ '^\d+$') and (l2.lampid ~ '^\d+$')
ORDER BY TheDistance desc;

-- QUESTION 5
-- Which road and single lampost are closest to each other in distance measured in meters.
-- You should provide the lampid of the lampost and the name of the road. As practice for your written exam, think about how the choice of CRS and the accuracy of the coordinates
-- of these points and lines could affect the results of this calculation. 

SELECT l1.lampid,r1.name,ST_Transform(l1.geom,3035) <-> ST_Transform(r1.geom,3035) as TheDistance
FROM icelandlamposts as l1, icelandroads as r1
ORDER BY TheDistance asc;

-- QUESTION 6
-- Write a Self Join query to find out how many pairs of roads DO NOT intersect each other. 
SELECT r1.name,r2.name
FROM icelandroads as r1, icelandroads as r2
WHERE (r2.id != r1.id) and (r2.name < r1.name) and (ST_Intersects(r1.geom,r2.geom) = False);	

-- QUESTION 6A
-- Same question as Q6 but you should only consider roads where the name starts with a vowel. 
SELECT r1.name,r2.name
FROM icelandroads as r1, icelandroads as r2
WHERE (r2.id != r1.id) and (r2.name < r1.name) and (ST_Intersects(r1.geom,r2.geom) = False)
and (r2.name ~ '^(A|E|I|O|U).*$') and 	 (r1.name ~ '^(A|E|I|O|U).*$');

-- QUESTION 7
-- What are the name of the two roads which are closest to each other but do not intersect each other. 

SELECT r1.name,r2.name,ST_Transform(r1.geom,3035) <-> ST_Transform(r2.geom,3035) as TheDistance
FROM icelandroads as r1, icelandroads as r2
WHERE (r2.id != r1.id) and (r2.name > r1.name) and (ST_Intersects(r1.geom,r2.geom) = False)	
ORDER BY THEDISTANCE ASC;

-- QUESTION 8 
-- What are the IDs of the buildings (if any) who have bounding rectangles or boxes which intersect each other? HINT - you'll need the && operator and you'll need to use
-- the ID field to help remove duplicates. 
SELECT b1.geom && b2.geom, b1.id,b2.id
FROM icelandbuildings as b1, icelandbuildings as b2 
WHERE (b1.id != b2.id) and (b1.id < b2.id) and (b1.geom && b2.geom)

-- QUESTION 9
-- What are the IDs of the buildings which are closest to each other, as measured in meters. 
SELECT b1.id,b2.id,b1.bldtype,b2.bldtype,ST_Transform(b1.geom,3035) <-> ST_Transform(b2.geom,3035) as TheDistance
FROM icelandbuildings as b1, icelandbuildings as b2 
WHERE (b1.id != b2.id) and (b1.id > b2.id) 
ORDER BY TheDistance asc;




SELECT * from icelandroads; 
SELECT * from icelandbuildings;
select * from icelandlamposts;