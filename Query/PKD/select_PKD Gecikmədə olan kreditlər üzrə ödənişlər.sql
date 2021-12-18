select agreement_no,oid,c_date,amo,acc_type, --dense_rank() over (partition by agreement_no,acc_type)acc_rn,
	pmt_order_uuid,login,
case  
when Department = 'COL01' then  'Qrup 1-10' 
when Department = 'COL11' then  'Qrup 11-20' 
when Department = 'COL21' then  'Qrup 21-30' 
when Department = 'COL31' then  'Qrup 31-60' 
when Department = 'COL61' then  'Qrup 61-120' 
when Department = 'COL121'then  'Qrup 120+'  end as  Department_ ,SAA
from (   select ech.agreement_no,ech.oid,ech.date_,ech.lc_end_time,  SAA,
row_number() over (partition by ech.agreement_no,erh.amount ,erh.acc_type,erh.pmt_order_uuid order by ech.date_ desc )rn2,  
erh.c_date,erh.amount amo,erh.acc_type,  erh.pmt_order_uuid,coalesce(lus.login,'Yiyesiz')login,   
ech.name_ as Department            
from ( 
	  select c.oid agreement_no,lc.oid,lc.c_type,acda.cr_timestamp date_,CONCAT(p.name,' ', p.first_name,' ',p.mid_name)SAA,
	ls.login collector,acda.division name_,c.uuid c_uuid,lc.end_timestamp lc_end_time
from lcase lc  
	join addon_coll_case acc on lc.uuid = acc.bus_case 
	join contract c on   acc.loan_uuid = c.uuid
	join loan l on c.uuid = l.contract_uuid
	join partner p on l.disb_to_uuid = p.uuid
    join addon_coll_division_assign acda on acc.uuid = acda.case_uuid 
	left join luser ls on acda.user_uuid = ls.uuid )ech      
join 
(  
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
	  where  date(ech.date_) <= erh.c_date  and erh.acc_type in ('PRNC','PRNC_A','PEN')    
group by ech.agreement_no,ech.oid,ech.date_,lus.login ,erh.c_date,erh.amount,erh.acc_type,erh.pmt_order_uuid,ech.name_,ech.lc_end_time,ech.saa   )a 
where rn2 = 1  and  (c_date <= date(lc_end_time) or date(lc_end_time) is null ) 
