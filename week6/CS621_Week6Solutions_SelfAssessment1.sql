--QUESTION A: 
BEGIN TRANSACTION;
SELECT * From starbucksusa limit 10;
SELECT * FROM starbucksusa where (state = 'NY') or (state = 'CA');
DELETE FROM starbucksusa where (state = 'NY') or (state = 'CA');
COMMIT;
ROLLBACK;


DROP VIEW IF EXISTS SBucksQ1View;
CREATE  OR REPLACE VIEW  SBucksQ1View AS
SELECT * from starbucksusa; 

-- QUESTION B
-- Write an appropriate ST_Dwithin based query which displays all of the starbucks cafes within 5KM of the approximate center of Central Park in New York city.
-- https://www.openstreetmap.org/?mlat=40.782222&mlon=-73.965278&zoom=15&layers=M
-- You might get slightly different results depending on the precise point you choose in Central park. In exams you will be given the exact point to use. 
-- Now that NY is deleted in the previous question - we only have 4 results. 

SELECT starbuckspk,name,street, state,ST_AsText(location),
ST_Distance(ST_Transform(St_GeomFromText('POINT(-73.965278 40.782222)',4326),2163),
ST_Transform(location,2163))/1000 as TheDistanceKM 
FROM StarbucksUSA where    
ST_DWithin(ST_Transform(St_GeomFromText('POINT(-73.965278 40.782222)',4326),2163),ST_Transform(location,2163),5000) order by TheDistanceKM desc;

--QUESTION C
DROP VIEW IF EXISTS SBucksQCView;
CREATE  OR REPLACE VIEW  SBucksQCView AS
SELECT SB.*
FROM starbucksusa as SB, unitedstatespolygons as USA where
ST_Contains(USA.geom,SB.location) and (USA.name = 'Florida' or USA.name = 'Texas');


--QUESTION D
DROP VIEW  IF EXISTS StarbucksCenterView;
CREATE OR REPLACE VIEW StarbucksCenterView as 

SELECT starbuckspk,name,street, state,ST_AsText(location),location,
ST_Distance(ST_Transform(St_GeomFromText('POINT(-98.5795 39.828175)',4326),2163),
ST_Transform(location,2163))/1000 as TheDistanceKM 
FROM StarbucksUSA order by TheDistanceKM ASC   LIMIT 300;


-- QUESTION E:
DROP VIEW  IF EXISTS y1994Starbucks;
CREATE OR REPLACE VIEW y1994Starbucks as 
SELECT * from starbucksusa where yearEst = 1994;

DROP VIEW  IF EXISTS y2016Starbucks;
CREATE OR REPLACE VIEW y2016Starbucks as 
SELECT * from starbucksusa where yearEst = 2016;





