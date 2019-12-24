

-- QUESTION 1
BEGIN;
SELECT * from LabExam2 where (rating > 3.5) and (cuisine = 'Breakfast');
UPDATE LabExam2 set rating = rating + 0.25 where (cuisine = 'Breakfast') and (rating > 3.5);

COMMIT;
ROLLBACK;



-- QUESTION 2
BEGIN;  
SELECT * from LabExam2 where (price >= 20) and (price <= 35) and (cuisine = 'Buffet');
DELETE from LabExam2 where (price >= 20) and (price <= 35) and (cuisine = 'Buffet');

COMMIT;
ROLLBACK;

-- QUESTION 3
BEGIN;
SELECT * from LabExam2 where (date_part('hour',rated) >= 10) and (date_part('hour', rated) <= 22) and (date_part('year', rated) =2019);
DELETE from LabExam2 where  (date_part('hour',rated) >= 10) and (date_part('hour', rated) <= 22) and (date_part('year', rated) =2019);
COMMIT;
ROLLBACK;

-- QUESTION 4
BEGIN;
SELECT * from LabExam2 where ST_Distance(ST_Transform(thegeom,3857),St_Transform(St_GeomFromText('POINT(-92.397 40.998)',4326),3857)) <= 88000;
UPDATE LabExam2 set price = price*1.23 where ST_Distance(ST_Transform(thegeom,3857),St_Transform(St_GeomFromText('POINT(-92.397 40.998)',4326),3857)) <= 88000;
COMMIT;
ROLLBACK;

-- QUESTION 5

SELECT cuisine,count(*) from LabExam2 group by cuisine;

BEGIN;
SELECT * from LabExam2 where (cuisine = 'Greek') or ST_Distance(ST_Transform(thegeom,3857),St_Transform(St_GeomFromText('POINT(-89.595 40.412)',4326),3857)) <= 10000;
DELETE from LabExam2 where (cuisine = 'Greek') or ST_Distance(ST_Transform(thegeom,3857),St_Transform(St_GeomFromText('POINT(-89.595 40.412)',4326),3857)) <= 10000;
COMMIT;
ROLLBACK;

-- QUESTION 6
Select count(*) from LabExam2;



----Lab Exam 2 – PART B – QGIS and Choropleth Mapping

ALTER TABLE ke2017 DROP COLUMN IF EXISTS NumberVoters;
ALTER TABLE ke2017 ADD COLUMN NumberVoters INTEGER DEFAULT 0.0;

-- perform the analysis

With PolygonQuery as (
    SELECT ke.id,count(*) as NumberVoters
    FROM voters as v, ke2017 as ke
    where ST_CONTAINS(ke.geom,v.geom)
    GROUP BY ke.id
)
UPDATE ke2017 SET NumberVoters = (PolygonQuery.NumberVoters)
FROM PolygonQuery 
WHERE ke2017.id = PolygonQuery.id;


SELECT * from ke2017 LIMIT 5;
---

ALTER TABLE ke2017 DROP COLUMN IF EXISTS VoterDensity;
ALTER TABLE ke2017 ADD COLUMN VoterDensity REAL DEFAULT 0.0;


With PolygonQuery as (
    SELECT ke.id,count(*) as NumberVoters
    FROM voters as v, ke2017 as ke
    where ST_CONTAINS(ke.geom,v.geom)
    GROUP BY ke.id
)
UPDATE ke2017 
SET VoterDensity = (PolygonQuery.NumberVoters/(ST_Area(ST_Transform(geom,32629))/1000000)) 
FROM PolygonQuery 
WHERE ke2017.id = PolygonQuery.id;




