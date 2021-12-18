select c.oid,lam.c_date,lam.amount,lam.acc_type,CONCAT(ls.lastname,' ', ls.firstname,' ',ls.midname)currentLO,lam.pmt_order_uuid
from
contract c
join loan l on c.uuid = l.contract_uuid 
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_mov lam on la.contr_acc_uuid = lam.contr_acc_uuid
join luser ls on c.responsible_uuid = ls.uuid
where lam.acc_type in ('PRNC','PRNC_A') 
and lam.c_date BETWEEN date_trunc('month', date(now()) ) - interval '1 month' AND date_trunc('month', now())::date - 1 
               --date between first date and last date of the last month
and lam.mov_type = 'REP' and lam.cancelled = 'false' and lam.write_off = 'false' and l.status in ('S005','S006')
group by c.oid,lam.c_date,lam.post_date,lam.amount,lam.acc_type,lam.mov_orig,lam.pmt_order_uuid,ls.lastname, ls.firstname,ls.midname
