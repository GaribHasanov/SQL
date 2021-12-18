-- Example 1
DECLARE @StartDate  date = '2020-01-01';
DECLARE @EndDate date = '2020-02-01';
;WITH seq(n) AS
(
    SELECT 0 
	UNION ALL 
	SELECT n + 1 FROM seq --n deyeri where sertinde tarixlerin gun ferqinden kicik oldugu muddetce nin uzerine 1 gel
    WHERE n < DATEDIFF(DAY, @StartDate, @EndDate) -- start ve enddate arasindaki gun ferqi boyuk olsun n-in deyerinden.Yeni 0-dan
)
,
d(d) AS
(
    SELECT DATEADD(DAY, n, @StartDate) FROM seq --startDate-in uzerine n-in deyerini gel.
)

SELECT * FROM d
OPTION (MAXRECURSION 0); --- rekursiv cte-nin max heddini teyin edir. 0 yazmaqla unlimited teyin ede bilerik



--Example 2
create table SalesDate
( SalesDate date primary key
)

declare @i int,
        @date datetime;
		set @i = 1;
		set @date = '20210101'
		
		while @i <= 30
		begin
		insert into SalesDate values (@date);
		set @date = @date+1;
		set @i = @i+1;
		end
