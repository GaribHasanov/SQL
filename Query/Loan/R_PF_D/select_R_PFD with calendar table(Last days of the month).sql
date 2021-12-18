select distinct 
ls.login,coalesce (dl.lo,dl.underwriter)olLO,dl.id,dkf.outstanding_balance,dkf.days_in_arrear,dkf.date portfeldate,a.calendar,
CONCAT(ls.lastname,' ', ls.firstname,' ',ls.midname)currentLO
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
join me_daily_key_figures dkf on ml.uuid = dkf.loan
join contract c on dl.id = c.oid
join luser ls on c.responsible_uuid = ls.uuid
join (
select date(calendar)calendar
from (select distinct 
cast('2020-01-31' as date) + (n || 'month')::INTERVAL as calendar  
			from generate_series(0, 35) n )a
			
)a --- Calendar table retrieves the last days of the months

on 	dkf.date = a.calendar
where dkf.kf_type = 'E'