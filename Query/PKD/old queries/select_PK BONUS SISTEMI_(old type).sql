select agreement_no,oid,date_,c_date,amo,login,department
from (
 select  distinct ech.agreement_no,ech.oid,ech.date_,ech.lc_end_time,  
row_number() over (partition by ech.agreement_no,erh.amount ,erh.acc_type,erh.c_date order by ech.date_ desc )rn2,  
erh.c_date,erh.amount amo,coalesce(lus.login,'Yiyesiz')login,   
ech.name_ as Department            
from ( select * from ext_collection_hist where date_ >= '2021-07-23'
union all select c.oid,lc.oid lcoid,lc.c_type,acda.cr_timestamp,ls.login,acda.division,c.uuid,lc.end_timestamp 
from lcase lc  
join addon_coll_case acc on lc.uuid = acc.bus_case 
join contract c on   acc.loan_uuid = c.uuid  
join addon_coll_division_assign acda on acc.uuid = acda.case_uuid 
left join luser ls on acda.user_uuid = ls.uuid --where c.oid = 'R0010736'
	 )ech      
join 
(  
	 select distinct l.oid,cast(dkf.principal_in_arrear as decimal (18,2))as amount,dkf.date c_date
 from me_loan l    
 join me_daily_key_figures dkf    on dkf.loan=l.uuid   
 where dkf.kf_type='M' 
 and dkf.days_in_arrear > 0 
 and dkf.date >= '2021-07-23' 
 --and l.oid = 'R0010736'
	 ) erh  on  ech.agreement_no = erh.oid 	  
	  --144327 
	  --151000
left join luser lus on ech.collector = lus.login   
where  date(ech.date_) <= erh.c_date 
group by ech.agreement_no,ech.oid,ech.date_,lus.login ,erh.c_date,erh.amount,ech.name_,ech.lc_end_time   )a 
where rn2 = 1  and  
(c_date <= date(lc_end_time) or date(lc_end_time) is null ) 
order by date_
