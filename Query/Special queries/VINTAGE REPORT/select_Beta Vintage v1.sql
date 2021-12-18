select distinct 
concat(date_part('year',(select kdate)),'-',date_part('month',(select kdate)) )Il_ay_uzre,
gdate PortfelDate,all_loan, all_arrear , concat (cast(divi as decimal(18,0)), ' %' )divi
from (
select gdate,kdate,all_loan,all_arrear, cast( all_loan as decimal(18,2)) / cast(all_arrear as decimal(18,2))  * 100 divi
from (
select distinct g.date gdate, k.date kdate,
count (k.kod) over ( partition by g.date, date_part('year',(select k.date)),date_part('month',(select k.date)) ) all_loan,
count (g.kod) over (partition by g.date  ) all_arrear


from 
(select distinct  ls.login,coalesce (dl.lo,dl.underwriter)olLO,dl.id kod,
dkf.outstanding_balance,dkf.days_in_arrear,dkf.date,a.calendar, 
CONCAT(ls.lastname,' ', ls.firstname,' ',ls.midname)currentLO 
from me_disb_loans dl join me_loan ml on dl.id = ml.oid 
join me_daily_key_figures dkf on ml.uuid = dkf.loan 
join contract c on dl.id = c.oid join luser ls on c.responsible_uuid = ls.uuid 
join ( select date(calendar)calendar from 
	  (select distinct  cast('2020-01-31' as date) + (n || 'month')::INTERVAL as calendar      
from generate_series(0, 35) n )a     )a on  dkf.date = a.calendar 
where dkf.days_in_arrear > 1 and dkf.kf_type = 'E') g

	left join 
	
	(select coalesce (dl.lo,dl.underwriter)LO,dl.id kod,dl.disb_date date, -- disb_loan
dl.loan_amount,ml.status ,dl.shop 
from me_disb_loans dl   
join me_loan ml on dl.id = ml.oid) k on g.kod = k.kod
)a

)b
--where kdate is not null
order by PortfelDate desc


