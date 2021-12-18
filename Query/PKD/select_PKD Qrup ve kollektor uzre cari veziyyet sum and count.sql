select  distinct aa.Department_,aa.collector,
sum(bb.outs_balance) over (partition by aa.collector,aa.Department_)sum_out_balance,
count(aa.coid) over (partition by aa.collector,aa.Department_)count_case,
sum(cc.due) over (partition by aa.collector,aa.Department_)due -- , 
--sum(cc.due) over (partition by cc.dkfdate)dueall
from   
( select c.oid coid,lc.oid lcoid,
 row_number()over (partition by c.oid  order by acda.cr_timestamp desc)rn, 
 acda.version,coalesce(ls.login,'KOLLEKTORU OLMAYAN')collector, 
 lc.end_timestamp,acda.c_timestamp,acda.cr_timestamp,  
 case   
 when acda.division = 'COL01' then  'Qrup 1-10'  
 when acda.division = 'COL11' then  'Qrup 11-20'  
 when acda.division = 'COL21' then  'Qrup 21-30'  
 when acda.division = 'COL31' then  'Qrup 31-60'  
 when acda.division = 'COL61' then  'Qrup 61-120'  
 when acda.division = 'COL121'then  'Qrup 120+'  
 when acda.division = 'LEG' then  'Hüquq' end as  Department_  
 from lcase lc   
 join addon_coll_case acc on lc.uuid = acc.bus_case  
 join contract c on   acc.loan_uuid = c.uuid   
 join addon_coll_division_assign acda on acc.uuid = acda.case_uuid  
 left join luser ls on acda.user_uuid = ls.uuid  
 where (lc.end_timestamp is null )
 group by c.oid,lc.oid ,ls.login,acda.division,acda.version,lc.end_timestamp,acda.cr_timestamp,acda.c_timestamp )aa  
 left join ( select c.oid,la.outs_balance  
			from contract c  
			join loan l on c.uuid = l.contract_uuid 
			join contract_accounting ca on c.uuid = ca.contract_uuid  
			join loan_accounting la on ca.uuid = la.contr_acc_uuid  
			where l.status = 'S005' ) bb on aa.coid = bb.oid   
			left join 
			( select l.oid,cast(dkf.principal_in_arrear  as decimal (18,2))as due,dkf.date dkfdate
			 from me_loan l    
			 join me_daily_key_figures dkf    on dkf.loan=l.uuid   
			 where dkf.kf_type='M' and dkf.days_in_arrear>0 and dkf.date= date(now())
			 order by dkf.date desc       )  cc on aa.coid = cc.oid   
			 where aa.rn = 1  and collector !='admin' 
			 and Department_ != 'Hüquq'  
			 order by collector

