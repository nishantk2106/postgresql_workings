Greater Manchester Crime Dataset. 

-- QUESTION 1
-- Write an SQL Query to find all of the crimes recorded in Greater Manchester in an LSOA containing the name Manchester and which occuredin the final hour of the 2nd last day of August 2018. The Moodle quiz will 
-- as you to provide the number of rows returned by this query. 
-- 2 rows. 
-- As stated in the assessment sheet the data is from 2018 so you can optionally include 2018 in the query. 
SELECT * from greatermanchestercrime where date_part('day',CrimeTS) = 30 and date_part('hour',CrimeTS) = 23  and date_part('year',CrimeTS) = 2018  and (lsoa ~ '.*Manchester.*');
SELECT * from greatermanchestercrime where date_part('day',CrimeTS) = 30 and date_part('hour',CrimeTS) = 23 and (lsoa ~'.*Manchester.*');

--QUESTION 2
-- Look at the structure of the crimeid field in the database table. Write an SQL query to extract the following rows from the table where 
-- the first 3 blocks of the crimeid contain only alphabetical characters and the outcome contains the text 'no suspect identified'. The Moodle Quiz requires you to type in the crimeid 
-- of the most recent (by crime ts) of these crimes. "FF:BD:CA:B5:C4:17"
-- rows returned 8

SELECT * from greatermanchestercrime where crimeid ~ '^[A-Z]{2}:[A-Z]{2}:[A-Z]{2}.*$' and (outcome ~ '^.*no suspect identified.*$') order by crimets desc;

-- QUESTION 2A
--The first block of characters and the last block of characters
--are composed of PRIME NUMBER digits (but the two digits together do not need to
--make a PRIME NUMBER). The
-- Using prime numbers in queries
-- 17 ROWS 
select crimeid from greatermanchestercrime where crimeid ~ '^(2|3|5|7){2}:.*:(2|3|5|7){2}$';

-- using even or odd digits in queries
-- Question 2b
-- We need to specifically target the 2nd and 3rd blocks. This means that we need to specify the position in the string
-- so we look at the first block then period and then we look for only even digits in the 2nd and 3rd block 
-- rows returned 51 
-- example "F3:66:42:68:10:8B"
-- example  "D7:88:04:3F:05:F0"
--51 ROWS 
select crimeid from greatermanchestercrime where crimeid ~ '^([A-Z]|[0-9]){2}:(2|4|6|8|0){2}:(2|4|6|8|0){2}.*$';



-- QUESTION 3
-- The Old Trafford Football Stadium in Manchester has latitude,longitude (53.463056, -2.291389). Write an SQL query to return all of the rows (crimes) which are recorded less than or equal to 2000 meters of this exact coordinate position. Moodle will ask you to specify the number of rows returned. You are encouraged to use UTM ESPG:32630 for the UK in your calculations. 
--67 rows returned  
SELECT * from greatermanchestercrime where ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.291389 53.463056)',4326),32630)) <= 2000;

-- QUESTION 4
-- Manchester Picadilly is the largest railway station in Manchester. Coordinates (Lat, Lon): 53.477013,-2.229452. Unfortunately the area 
-- around the station is a particularly frequent location of crime. Write an SQL query which returns all of the rows (crimes) recorded within 2000 meters of this precise location. Only return rows which have the word 'theft' (case insensitive) in the crime type column. 
-- Moodle will require you to specify the number of rows returned. 
-- 143 rows

SELECT * from greatermanchestercrime where ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.229452 53.477013)',4326),32630)) <= 2000 and (type ~* '^.*theft.*$') ;

-- QUESTION 5
-- On the 19th of August 2018 at 13:30 Manchester City played Huddersfield Town in a football game at the City of Manchester Stadium (coordinates (lat, long): 	53.483056, -2.200278
-- Write an SQL query to extract all crimes which occured between noon and just before 6pm on the day of this game. Any crime which occured within 5KM of the exact stadium location should be returned. Moodle will require the number of rows returned. 
-- 13 rows
SELECT * from greatermanchestercrime where ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.200278 53.483056)',4326),32630)) <= 5000 and date_part('day',crimets) = 19 and date_part('month',crimets) = 8 and date_part('hour',crimets) >= 12 and date_part('hour',crimets) <= 18;

-- QUESTION 5A
-- A researcher is investigating a specific area in Manchester. They have provided you with the following pieces of geo data: St_GeomFromText('POINT(-2.255501 53.482794)',4326) and St_GeomFromText('POINT(-2.242498 53.488106)',4326) which represent the coordinates of Salford and Manchester Victoria train stations. Write a query which returns all 
-- crimes recorded within 800m of both of these locations on or after the 20th of August 2018. The Moodle quiz will require you to specify the number of rows returned.  
-- ROWS = 11
SELECT ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.255501 53.482794)',4326),32630)),
ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.242498 53.488106)',4326),32630)),
* from greatermanchestercrime where ((ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.255501 53.482794)',4326),32630)) <= 800) and
(ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.242498 53.488106)',4326),32630)) <= 800)) 
and date_part('day',crimets) >= 20 order by crimets;

-- QUESTION 6
-- updates and deletes. 
-- Write an SQL query to delete any crime which was recorded as occuring in LSOA   "Rochdale 012D". Moodle will require the number of rows affected. 
-- 12 rows 

SELECT * from greatermanchestercrime where LSOA = 'Rochdale 012D';

-- QUESTION 7
-- Write an SQL query where the crimeid field only contains digits in the blocks. Moodle will require the number of rows affected. 
-- 18 rows. There are a few different ways you could write the regex expression. 
SELECT * from greatermanchestercrime where crimeid ~* '^\d{2}:\d{2}:\d{2}:\d{2}:\d{2}:\d{2}$'; 
SELECT * from greatermanchestercrime where crimeid ~* '^(\d{2}:{0,1}){6}.*$'; 

-- QUESTION 8
-- 2 rows affected. 

SELECT * from greatermanchestercrime where (lsoa = 'Bolton 022E') and (location ~ '^.*Cyril Street.*$') and (type = 'Shoplifting');

-- QUESTION 9
-- Write an SQL statement to return all of the rows in the database which have the following criteria. The theGeom location is within 5KM of St_GeomFromText('POINT(-2.234566 53.47924)',4326)
-- and the numerical total of the hour, minute and second of the crimeTS field is equal to 100. Moodle will require you to specify how many rows are affected by this deletion. 
-- 16 rows
SELECT (date_part('hour',crimets) + date_part('minute',crimets) + date_part('second',crimets)),* from greatermanchestercrime where ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.234566 53.47924)',4326),32630)) <= 5000 and (date_part('hour',crimets) + date_part('minute',crimets) + date_part('second',crimets)) = 100;

-- QUESTION 10
-- Write an SQL Statement to return all crimes which happened at one minute to five in the morning (ignoring the seconds) on any day of August and the crime type was Burglary. Moodle will require the number of rows affected. 
-- 1 rows  

Select * from greatermanchestercrime where date_part('hour',crimets) = 4 and date_part('minute',crimets) = 59 and  date_part('month',crimets) = 8 and (type = 'Burglary');


-- QUESTION 11
----Write a query which returns all rows in the database table which
--have lsoa and location with the following pattern. The lsoa field ends with 3 even
--digits followed by an upper case letter A to C (inclusive). The location field ends
--with the word ‘Street’. Moodle will require the number of rows affected.
--176 rows 
select lsoa, location from greatermanchestercrime 
where (lsoa ~ '.*((0|2|4|6|8){3})[A-C]$') 
and (location ~ '^.*Street$');



