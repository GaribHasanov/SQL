insert into ext_collection_hist_clndr_tb (calendar,oid,lcoid,c_type,cr_timestamp,login,division,uuid )
select calendar,oid,lcoid,c_type,cr_timestamp,login,division,uuid 
from (
select date(calendar)calendar,row_number() over (partition by acda1.oid,acda1.lcoid,calendar order by acda1.cr_timestamp desc)rn,
acda1.*
from
(

SELECT t.day::date as calendar
FROM   
generate_series(timestamp '2021-07-23',  date(now()), interval  '1 day') AS t(day)
) usr 
join
(

select c.oid,lc.oid lcoid,lc.c_type,acda.cr_timestamp,ls.login,acda.division,c.uuid,lc.end_timestamp 
from lcase lc  
join addon_coll_case acc on lc.uuid = acc.bus_case 
join contract c on   acc.loan_uuid = c.uuid  
join addon_coll_division_assign acda on acc.uuid = acda.case_uuid 
left join luser ls on acda.user_uuid = ls.uuid 
--where c.oid = 'R0002040'
	--'R0010736'

  ---Loan ID	R0002040
)acda1
on usr.calendar >= date(acda1.cr_timestamp)
)aa
where rn = 1
and  (calendar <= date(end_timestamp) or date(end_timestamp) is null ) 
except
select * from ext_collection_hist_clndr_tb

