DECLARE @Time_in_Second INT
SET @Time_in_Second = 7200 -- seconds to hh:mm:ss
SELECT RIGHT('0' + CAST(@Time_in_Second / 3600 AS VARCHAR),2) + ':' +
RIGHT('0' + CAST((@Time_in_Second / 60) % 60 AS VARCHAR),2) + ':' +
RIGHT('0' + CAST(@Time_in_Second % 60 AS VARCHAR),2)[hh:mm:ss]
--the query will retrieve the the 7200 second as hh:mm:ss

DECLARE @Time_in_Second2 INT
SET @Time_in_Second2 = DATEDIFF(second,'01:15:00','03:15:00')--You can replace the " '01:15:00','03:15:00' " with your current time columns in DATEDIFF
SELECT RIGHT('0' + CAST(@Time_in_Second2 / 3600 AS VARCHAR),2) + ':' +
RIGHT('0' + CAST((@Time_in_Second2 / 60) % 60 AS VARCHAR),2) + ':' +
RIGHT('0' + CAST(@Time_in_Second2 % 60 AS VARCHAR),2)[hh:mm:ss]
--the query will retrieve the second difference of '01:15:00','03:15:00' time as hh:mm:ss

--You can use this method in your t-sql code to retrieve the user login and logout time difference as hh:mm:ss
--Example
SELECT username,
RIGHT('0' + CAST(DATEDIFF (second,login_time,logout_time) / 3600 AS VARCHAR),2) + ':' +
RIGHT('0' + CAST((DATEDIFF(second,login_time,logout_time) / 60) % 60 AS VARCHAR),2) + ':' +
RIGHT('0' + CAST(DATEDIFF (second,login_time,logout_time) % 60 AS VARCHAR),2)[user_logon_time]
FROM Log_Table

--Note: This code calculates only in second...............