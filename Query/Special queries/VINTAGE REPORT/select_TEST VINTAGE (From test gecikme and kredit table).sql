truncate gecikme
truncate kredit

select * from kredit
select * from gecikme

DROP TABLE gecikme
create table gecikme (
kod character varying(20),
date date)

insert into gecikme (kod,date) values 
('AAA', '2021-05-31'),
('BBB', '2021-05-31'),
('CCC', '2021-05-31'),
('DDD', '2021-05-31'),
('EEE', '2021-05-31'),
('JJJ', '2021-05-31'),
('III', '2021-05-31'),
('TTT', '2021-05-31'),
('KK',  '2021-05-31'),
('WWW', '2021-05-31')


insert into gecikme (kod,date) values 
('AAA', '2021-06-30'),
('BBB', '2021-06-30'),
('CCC', '2021-06-30'),
('ADD', '2021-06-30'),
('EEE', '2021-06-30'),
('JJJ', '2021-06-30'),
('IDI', '2021-06-30'),
('TTT', '2021-06-30'),
('KDK',  '2021-06-30'),
('WEW', '2021-06-30')









insert into kredit (kod,date) values 
('AAA', '2021-01-20'),
('BBB', '2021-01-10'),
('CCC', '2021-01-30'),
('DDD', '2021-01-10'),
('EEE', '2021-01-10'),
('FFF', '2021-02-10'),
('GGG', '2021-02-12'),
('HHH', '2021-02-10'),
('JJJ', '2021-02-14'),
('III', '2021-02-10')


select distinct all_loan, all_arrear , concat (cast(divi as decimal(18,0)), ' %' )divi, gdate ,
concat(date_part('year',(select kdate)),'-',date_part('month',(select kdate)) )ddd
from (
select gdate,kdate,all_loan,all_arrear, cast( all_loan as decimal(18,2)) / cast(all_arrear as decimal(18,2))  * 100 divi
from (
select distinct g.date gdate, k.date kdate,
count (k.kod) over ( partition by g.date, date_part('year',(select k.date)),date_part('month',(select k.date)) ) all_loan,
count (g.kod) over (partition by g.date  ) all_arrear


from 
gecikme g
left join kredit k on g.kod = k.kod
)a

)b
where kdate is not null
order by gdate


 
 

 
 
 select distinct g.date, --, k.*, 
 count(g.kod) over (partition by g.date)gcount,
 count(k.kod) over (partition by g.date,date_part('year',(select k.date)),date_part('month',(select k.date)))kcount,
 date_part('year',(select k.date)),date_part('month',(select k.date))
 
 from gecikme g
 left join kredit k on g.kod = k.kod
 --where k.ko
 order by g.kod
 
 

