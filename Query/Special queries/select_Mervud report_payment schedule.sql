with cte as (
select a.* , coalesce(b.arrear_days_morning,111111)gecikm?si_olub,c.son_öd?nis_tarixi
from (
select distinct c.oid,l.agreement_no,shi.total_repayment,shi.c_date ,ls.login,la.arrear_days
from
contract c 
join loan l on c.uuid = l.contract_uuid
join luser ls on c.responsible_uuid = ls.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_grp lagg on la.contr_acc_uuid = lagg.loan_acc_uuid
join schedule sh on lagg.outs_schedule = sh.uuid 
join schedule_item shi on sh.uuid = shi.schedule_uuid
where shi.c_type = 'Payment'
and shi.c_date >='2021-05-01'
and ls.login = 'MARVUDVA' 
and l.status in ('S005','S006')
	
)a 
left join
(
	select * from (
select distinct c.oid,l.agreement_no,lash.arrear_days_morning,
row_number() over (partition by c.oid order by lash.date_from)rn
from
contract c 
join loan l on c.uuid = l.contract_uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_accounting_hist lash on la.contr_acc_uuid = lash.loan_acc_uuid
where 
lash.arrear_days_morning >0

)bb where rn = 1

)b on a.oid = b.oid

left join
(
select distinct  c.oid,max(lam.c_date) over (partition by c.oid)son_öd?nis_tarixi
	from
contract c 
join loan l on c.uuid = l.contract_uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_mov lam on ca.uuid = lam.contr_acc_uuid
where lam.mov_type = 'REP' and lam.cancelled = false
)
c on a.oid = c.oid	
)
select * from cte
