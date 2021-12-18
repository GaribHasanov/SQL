	with cte as (---last true select for yigim pks legal LO 
	
	
	select * ,  sum(amo) over (partition by pmt_order_uuid)summe from (   
	select ech.agreement_no,ech.oid,ech.date_,ech.lc_end_time,  row_number() over (partition by ech.agreement_no,erh.amount ,
	erh.acc_type ,erh.pmt_order_uuid order by ech.date_ desc )rn2,  erh.c_date,erh.amount amo,erh.acc_type,  
	erh.pmt_order_uuid,coalesce(lus.login,'Yiyesiz')login,   ech.name_ as Department            
	from ( select * from ext_collection_hist union all select c.oid,lc.oid lcoid,lc.c_type,acda.cr_timestamp,ls.login,acda.division,c.uuid,lc.end_timestamp 
	from lcase lc  
	join addon_coll_case acc on lc.uuid = acc.bus_case 
	join contract c on   acc.loan_uuid = c.uuid  join addon_coll_division_assign acda on acc.uuid = acda.case_uuid 
	left join luser ls on acda.user_uuid = ls.uuid )ech      
	
	join (  
	 select c.oid,lam.c_date,lam.post_date,lam.amount,lam.acc_type,lam.mov_orig,lam.pmt_order_uuid
from
contract c
join loan l on c.uuid = l.contract_uuid 
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_mov lam on la.contr_acc_uuid = lam.contr_acc_uuid
where lam.mov_type = 'REP' and lam.cancelled = 'false' and lam.write_off = 'false' and l.status in ('S005','S006')
group by c.oid,lam.c_date,lam.post_date,lam.amount,lam.acc_type,lam.mov_orig,lam.pmt_order_uuid
	 ) erh  on  ech.agreement_no = erh.oid 	 
	
		left join luser lus on ech.collector = lus.login   
	where  date(ech.date_) <= erh.c_date  and erh.acc_type in ('PRNC','PRNC_A')    
	group by ech.agreement_no,ech.oid,ech.date_,lus.login ,erh.c_date,erh.amount,erh.acc_type,
	erh.pmt_order_uuid,ech.name_,ech.lc_end_time   )a 
	where  rn2 = 1  and  (c_date <= date(lc_end_time) or date(lc_end_time) is null ) order by c_date   ) 
	select distinct agreement_no,oid,c_date,summe,pmt_order_uuid,Department, 
	case  when Department = 'COL01' then  'Qrup 1-10' 
	when Department = 'COL11' then  'Qrup 11-20' 
	when Department = 'COL21' then  'Qrup 21-30' 
	when Department = 'COL31' then  'Qrup 31-60' 
	when Department = 'COL61' then  'Qrup 61-120' 
	when Department = 'COL121'then  'Qrup 120+' 
	when Department = '_ENTER ACTIONS SOFT COLLECTOR' then  'PKD - Qruplasmadan önc?' 
	when Department = 'ENTER ACTIONS LEGAL DEPARTMENT' then  'Hüquq' when Department = 'LEG' then  'Hüquq' 
	when Department = '_ENTER ACTIONS LO' then  'Kredit'  end as  Department_,login,lc_end_time from cte --where department like 'COL%' --where agreement_no = 'R0000862'  
	group by agreement_no,oid,c_date,summe,pmt_order_uuid, Department,login,lc_end_time order by c_date desc