﻿
-- question 1
select * from cs621week3ex1 where (country = 'India') and (char_length(fullname) > 10) order by fullname desc;

-- question 2
select * from cs621week3ex1 where (mobilephone ~'^\d{6}\s.*$');

-- question 3
-- There can be some interpretation for this question. "at least two number 9 appearing consecutively". 
-- So we can have 99 and no other digit 9
-- or we can have 999 or 9999 and so on. 
-- So at minimum we need to capture the 99 - if there are more than that is no problem. Our regex will deal with that. 
select * from cs621week3ex1 where (mobilephone ~'^.*9{2,}.*$');

--question 4
select * from cs621week3ex1 where company_name ~* '^.*\sand\s.*$';

--question 5
select * from cs621week3ex1 where char_length(company_name) > 10 and mobilephone like '087%' and country = 'Ireland';


--question 6 
select * from cs621week3ex1 where not (company_name ~* '^.*\s{1,}.*$');

--question 7
select * from cs621week3ex1 where fullname ~* '^.*\s{1,}.*\s{1,}.*$';

-- question 8

SELECT * From cs621week3ex1 where char_length(username) <= 5 order by username asc;
