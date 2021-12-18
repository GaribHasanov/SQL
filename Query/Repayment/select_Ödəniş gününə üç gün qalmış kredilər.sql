with cte as (
select a.oid ,a.SAA,a.approved_amount-b.qrafik_cem qrafik_cari_balans, c.outs_balance,a.total_repayment,a.c_date
from (
select distinct c.oid,l.approved_amount,shi.total_repayment,shi.c_date,CONCAT(p.name,' ', p.first_name,' ',p.mid_name)SAA
from
contract c ---- odenis gunune 3 gun qalmis kreditler
join loan l on c.uuid = l.contract_uuid
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_grp lagg on la.contr_acc_uuid = lagg.loan_acc_uuid
join schedule sh on lagg.outs_schedule = sh.uuid 
join schedule_item shi on sh.uuid = shi.schedule_uuid
where shi.c_type = 'Payment' 
and shi.c_date = CURRENT_DATE + INTERVAL '3 day' --and c.oid = 'R0002749'
and l.status = 'S005'	
	
)a 

left join
	
(
select distinct c.oid,sum(shi.total_repayment) over (partition by c.oid)qrafik_cem
from
contract c 
join loan l on c.uuid = l.contract_uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_grp lagg on la.contr_acc_uuid = lagg.loan_acc_uuid
join schedule sh on lagg.outs_schedule = sh.uuid 
join schedule_item shi on sh.uuid = shi.schedule_uuid
where shi.c_type = 'Payment' 
and shi.c_date <= CURRENT_DATE + INTERVAL '3 day'
and l.status = 'S005'	
	
)b on a.oid = b.oid
	
	
	
left join
(
select distinct  c.oid,la.outs_balance
	from
contract c 
join loan l on c.uuid = l.contract_uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
where  l.status = 'S005'
)
c on a.oid = c.oid	
)
select * from cte
where qrafik_cari_balans <= outs_balance