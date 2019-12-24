-- QUESTION 1
-- Write an SQL query which returns all rows where the number of characters in the observer column is greater than 10?
-- 163 rows returned
SELECT * from CS621LabExam1 where (char_length(observer) > 10);

-- QUESTION 2
-- Write an SQL query which returns all of the observations in the table where the rainfall is between 40 and 50 millimeters inclusive and the month is May 2019. 
-- 13 ROWS RETURNED
SELECT * from CS621LabExam1 where (rainfall >= 40) and (rainfall <= 50) and date_part('month',ts) = 5;

-- QUESTION 3
-- Write an SQL query which returns all observations in the table where the only digit used in the tIndex column is the digit 3? 
-- 8 ROWS RETURNED
SELECT * from CS621LabExam1 where tindex ~ '^3333-.*-33$';

-- QUESTION 4
-- Write an SQL query which returns all observations in the table where the tIndex column contains only even digits (excluding the digit 0)?
-- 8 Rows returned
SELECT * from CS621LabExam1 where tIndex ~ '^(2|4|6|8){4}-.*-(2|4|6|8){2}$';

-- QUESTION 5
-- Write an SQL query which returns all observations in the table where the rainfall is less than 30 millimeters and the tIndex column contains at least two uppercase vowels (beside each other)?
-- 35 rows returned
SELECT * from CS621LabExam1 where tIndex ~ '^.*(A|E|I|O|U){2,}.*$' and (rainfall < 30);

-- QUESTION 6
--Given the location with longitude -0.1936 and latitude 51.4579, write an SQL query to find all observations which were made within 3KM of this location. 
-- 5 rows 
SELECT * from CS621LabExam1 where ST_Distance(ST_Transform(thegeom,27700),
ST_Transform(ST_GeomFromText('POINT(-0.1936 51.4579)',4326),27700)) <3000;

-- QUESTION 7
--vWestminister Bridge in London has coordinates (longitude,latitude) -0.121661 51.500835. Write an SQL query which finds all of the observations which were made within 10KM of this location
-- and the month is from April or after (inclusive)
-- 22 rows

SELECT * from CS621LabExam1 where ST_Distance(ST_Transform(thegeom,27700),
ST_Transform(ST_GeomFromText('POINT(-0.121661 51.500835)',4326),27700)) <10000 and date_part('month',ts) >= 4 order by ts desc;

-- QUESTION 8
-- Suppose you are provided with a geolocation expressed as Well Known Text POINT(-0.1926 51.4556). Write an SQL query to satisfy the following criteria. Return all observations
-- made within 8.5 KM of this location with the hour of the timestamp (on any day) or the rainfall amount being greater or equal to 20. 
-- 27 rows
SELECT * from CS621LabExam1 where ST_Distance(ST_Transform(thegeom,27700),
ST_Transform(ST_GeomFromText('POINT(-0.1926 51.4556)',4326),27700)) <8500 and ((date_part('hour',ts) >= 20) or (rainfall >= 20.0));

-- QUESTION 9
-- Write an SQL query which returns observations matching the following criteria. The tIndex column ends in an odd number and the observer column also ends in an odd number
-- rows 57
SELECT * From CS621LabExam1 where tIndex ~ '^.*\d(1|3|5|7|9)$' and (observer ~ '^.*(1|3|5|7|9)$');
SELECT * From CS621LabExam1 where tIndex ~ '^.*\d(0|2|4|6|8)$' and (observer ~ '^.*\d{0,1}(0|2|4|6|8)$');

-- QUESTION 10
-- Write an SQL which allows us to find the names of observers who measured rainfall observations greater than 40mm in April. What is the name of the observer who measured the 
-- 3rd observation (in chronological) order, according to these criterion? The Moodle quiz will require the name of the observer. 
--- dhumesy
SELECT observer,ts,rainfall From CS621LabExam1 where (date_part('month',ts) = 4) and (rainfall > 40) order by ts asc;

-- QUESTION 11
-- Write an SQL query which returns all observations where the observation was made in February and the sum of the hour, minute and second of the observation is greater than 10 times the rainfall measured. 
-- 13 rows 

SELECT * from CS621LabExam1 where ((date_part('hour',ts) + date_part('min',ts) + date_part('second',ts)) > 10*rainfall) and (date_part('month',ts) = 2);





-- QUESTION 12
-- Write an SQL query which returns all observations where the name in the observer field does not contain any vowels (regardless of case). 
--SELECT * From CS621LabExam1 where NOT(tIndex ~ '^\d\d\d\d-.*(A|E|I|O|U){1,}.*-.*(a|e|i|o|u){1,}.*-\d\d$'); 
SELECT observer from CS621LabExam1 where NOT(observer ~ '^.*(a|e|i|o|u){1,}.*$');




