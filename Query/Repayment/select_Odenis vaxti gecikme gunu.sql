select a.*, b.days_in_arrear
from 

(
select c.oid,lam.c_date,lam.amount,lam.acc_type,lam.pmt_order_uuid
from
contract c
join loan l on c.uuid = l.contract_uuid 
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_mov lam on la.contr_acc_uuid = lam.contr_acc_uuid
join luser ls on c.responsible_uuid = ls.uuid
where lam.acc_type in ('PRNC','PRNC_A','PEN') --and c.oid = 'R0001593'
and lam.c_date >='2021-01-01'            
and lam.mov_type = 'REP' and lam.cancelled = 'false' and lam.write_off = 'false' and l.status in ('S005','S006')
group by c.oid,lam.c_date,lam.post_date,lam.amount,lam.acc_type,lam.mov_orig,lam.pmt_order_uuid,ls.lastname, ls.firstname,ls.midname
)a

left join
(
select  ml.oid,dkf.days_in_arrear,dkf.date portfeldate
from me_loan ml
join me_daily_key_figures dkf on ml.uuid = dkf.loan
join contract c on ml.oid = c.oid
where dkf.kf_type = 'M' and dkf.date >='2021-01-01'  
and dkf.days_in_arrear > '90' --and ml.oid= 'R0001593'
)b on a.oid = b.oid and  a.c_date = b.portfeldate
 where b.days_in_arrear > 90
 order by b.days_in_arrear