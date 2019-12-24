-- WEEK 6 - Updates and DELETES - Solutions. 

-- updates and deletes. 
-- Write an SQL query to delete any crime which was recorded as occuring in LSOA   "Rochdale 012D". Moodle will require the number of rows affected. 
-- 12 rows 
BEGIN;
SELECT * from greatermanchestercrime where LSOA = 'Rochdale 012D';
DELETE FROM GREATERMANCHESTERCRIME where LSOA = 'Rochdale 012D';
COMMIT;
ROLLBACK;

-- Write an SQL query which updates the OUTCOME field of all crimes to 'No further investigation' where the crimeid field only contains digits in the blocks. Moodle will require the number of rows affected. 
-- 18 rows. There are a few different ways you could write the regex expression. 
BEGIN;
SELECT * from greatermanchestercrime where crimeid ~* '^\d{2}:\d{2}:\d{2}:\d{2}:\d{2}:\d{2}$'; 
SELECT * from greatermanchestercrime where crimeid ~* '^(\d{2}:{0,1}){6}.*$'; 
UPDATE GREATERMANCHESTERCRIME SET Outcome = 'No further investigations' where crimeid ~* '^(\d{2}:{0,1}){6}$' ;
COMMIT;
ROLLBACK;

-- Due to an error in recording all crimes in lsoa Bolton 022E where the location contains cyril street must have their crime type column updated to Shoplifting. The update statement must only update crime records where the type is not already Shoplifting. Moodle will require the number of rows affected. 
-- 2 rows affected. 
BEGIN;
SELECT * from greatermanchestercrime where (lsoa = 'Bolton 022E') and (location ~ '^.*Cyril Street.*$') and (type != 'Shoplifting')
UPDATE greatermanchestercrime SET type = 'Shoplifting' where (lsoa = 'Bolton 022E') and (location ~ '^.*Cyril Street.*$') and (type != 'Shoplifting')
COMMIT;
ROLLBACK;

-- Write a delete statement to remove all of the rows in the database which have the following criteria. The theGeom location is within 5KM of St_GeomFromText('POINT(-2.234566 53.47924)',4326)
-- and the numerical total of the hour, minute and second of the crimeTS field is equal to 100. You are STRONGLY advised to write an SQL statement first before attempting this delete. Moodle will require you to specify how many rows are affected by this deletion. 
-- 16 rows
BEGIN;
SELECT (date_part('hour',crimets) + date_part('minute',crimets) + date_part('second',crimets)),* from greatermanchestercrime where ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.234566 53.47924)',4326),32630)) <= 5000 and (date_part('hour',crimets) + date_part('minute',crimets) + date_part('second',crimets)) = 100;
delete from greatermanchestercrime where ST_Distance(ST_Transform(theGeom,32630),St_Transform(St_GeomFromText('POINT(-2.234566 53.47924)',4326),32630)) <= 5000 and (date_part('hour',crimets) + date_part('minute',crimets) + date_part('second',crimets)) = 100;
COMMIT;
ROLLBACK;


-- QUESTION 5: Write a delete statement which deletes all crimes -- which happened between 3am and 6am (inclusive) in the morning, -- any time in August.
BEGIN;
SELECT * from greatermanchestercrime where (date_part('month',crimets) = 8) and (date_part('hour',crimets) >= 3) and (date_part('hour',crimets) <= 6);

DELETE from greatermanchestercrime where (date_part('month',crimets) = 8) and (date_part('hour',crimets) >= 3) and (date_part('hour',crimets) <= 6);


COMMIT;
ROLLBACK; 


