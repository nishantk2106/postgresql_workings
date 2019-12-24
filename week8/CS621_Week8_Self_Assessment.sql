-- The key steps is in the import of the datasets into PostGIS using 
-- the DBManager in QGIS. 

-- I have used the table names lwards2017 (for the wards file)
-- I have used the table names tfl2017 and tfl2018 respectively for the other two 
-- point geometry shapefile and geojson file. 
-- The tabelnames are up to yourself. However, you SHOULD NOT use special characters
-- or uppercase letters in DBManager - keep all of your tablenames in lowercase

-- You should also identify the primary key and the geometry column in each table. 
-- This is crucial in writing the queries correctly below. 

-- Remember to use a Transform (we use the EPSG:32630) for the meter-based calculation
-- of the area of the polygons .

-- STARTING A CHOROPLETH ANALYSIS. 

-- 1. ALTER the table lwards2017 (NEIGHBOURHOODS)
-- add a new column called StopDensity
-- Notice that StopDensity is REAL because we might get decimal values
ALTER TABLE lwards2017 DROP COLUMN IF EXISTS StopDensity;
ALTER TABLE lwards2017 ADD COLUMN StopDensity REAL DEFAULT 0.0;


-- 2 Use a Table Sub Query to do an update 
-- of the lwards2017 and the new column
-- NumStops. For DENSITY - we still have to count the 
-- number of objects (from tfl2017) in each polygon. 

-- In the UPDATE statement we now calculate the AREA of the POLYGON
-- which we are updating. 
-- lwards2017 has primary key id and geometry column called geom

With PolygonQuery as (
    SELECT lw.id,count(*) as NumStops
    FROM lwards2017 as lw, tfl2017 as tfl
    where ST_CONTAINS(lw.geom,tfl.geom)
    GROUP BY lw.id
)
UPDATE lwards2017 
SET StopDensity = (PolygonQuery.NumStops/(ST_Area(ST_Transform(geom,32630))/1000000)) 
FROM PolygonQuery 
WHERE lwards2017.id = PolygonQuery.id;



-- 1. ALTER the table lwards2017 (NEIGHBOURHOODS)
-- add a new column called StopDensity
-- Notice that StopDensity is REAL because we might get decimal values
ALTER TABLE lwards2017 DROP COLUMN IF EXISTS StopDensity2018;
ALTER TABLE lwards2017 ADD COLUMN StopDensity2018 REAL DEFAULT 0.0;


-- 2 Use a Table Sub Query to do an update 
-- of the lwards2017 and the new column
-- NumStops. For DENSITY - we still have to count the 
-- number of objects (from tfl2018) in each polygon. 

-- In the UPDATE statement we now calculate the AREA of the POLYGON
-- which we are updating. 
-- lwards2017 has primary key id and geometry column called geom

With PolygonQuery as (
    SELECT lw.id,count(*) as NumStops
    FROM lwards2017 as lw, tfl2018 as tfl
    where ST_CONTAINS(lw.geom,tfl.geom)
    GROUP BY lw.id
)
UPDATE lwards2017 
SET StopDensity2018 = (PolygonQuery.NumStops/(ST_Area(ST_Transform(geom,32630))/1000000)) 
FROM PolygonQuery 
WHERE lwards2017.id = PolygonQuery.id;


--===============
-- Part 3 - removing non bus = yes. Essentially this is everything that is null in the 
-- this column. 

delete from tfl2018 where (bus is null);
-- re do the analysis

-- recreate the columns. 
ALTER TABLE lwards2017 DROP COLUMN IF EXISTS StopDensity2018;
ALTER TABLE lwards2017 ADD COLUMN StopDensity2018 REAL DEFAULT 0.0;


-- 2 Use a Table Sub Query to do an update 
-- of the lwards2017 and the new column
-- NumStops. For DENSITY - we still have to count the 
-- number of objects (from tfl2018) in each polygon. 

-- In the UPDATE statement we now calculate the AREA of the POLYGON
-- which we are updating. 
-- lwards2017 has primary key id and geometry column called geom

With PolygonQuery as (
    SELECT lw.id,count(*) as NumStops
    FROM lwards2017 as lw, tfl2018 as tfl
    where ST_CONTAINS(lw.geom,tfl.geom)
    GROUP BY lw.id
)
UPDATE lwards2017 
SET StopDensity2018 = (PolygonQuery.NumStops/(ST_Area(ST_Transform(geom,32630))/1000000)) 
FROM PolygonQuery 
WHERE lwards2017.id = PolygonQuery.id;













