
-- select all stocknames which include a Vowel as a capital letter. 
select stockname from CS621Week3_investors where stockname ~ '^.*(A|E|I|O|U){1,}.*$';

-- select all investor IBAN where the last block is 4 digits. 
select  investoriban from CS621Week3_investors where investoriban ~ '^.*\s\d{4}$';

--select all investor IBAN where the last block is 4 digits but the first digit is 0
select  investoriban from CS621Week3_investors where investoriban ~ '^.*\s0\d{3}$';

-- select all investor IBAN where the last block is 4 digits and this block starts with a 0 or 9. The entire length of the investor IBAN should be exactly 34 characters. 
select  investoriban from CS621Week3_investors where investoriban ~ '^.*\s(0|9)\d{3}$' and char_length(investoriban) = 34;
--alternatively
select  investoriban from CS621Week3_investors where ((investoriban ~ '^.*\s0\d{3}$') or (investoriban ~ '^.*\s9\d{3}$')) and char_length(investoriban) = 34;


-- select all investor stocktimes where the sum of the hours minutes and seconds is LESS THAN the sum of the month and day for any storck time. 
select stocktime from CS621Week3_investors where date_part('hour',stocktime) + date_part('minute',stocktime) + date_part('second',stocktime) < date_part('month',stocktime) + date_part('day',stocktime);

--select all IBANS which are palindromes. 
select * from cs621week3_investors where reverse(investoriban) = investoriban;

-- select all stocks where the stockname includes a three digit number and the stock name is in the future. Use the results of your query to find which stock has the stocktime further in the future. 
select * from cs621week3_investors where stockname ~ '^.*\d{3}\s.*$' and stocktime > now() order by stocktime desc;

-- select all stocks which have a stock value that if we calculated 95% of the stockvalue it would be still greater than 180 euros. 

select * from cs621week3_investors where (stockvalue*0.95 > 180);
