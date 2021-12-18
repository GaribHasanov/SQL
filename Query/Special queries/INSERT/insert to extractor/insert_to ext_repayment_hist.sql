delete from ext_repayment_hist where c_date >='2021-01-01';
insert into ext_repayment_hist (agreement_no,c_date,post_date,amount,acc_type,mov_orig,pmt_order_uuid)
select c.oid,lam.c_date,lam.post_date,lam.amount,lam.acc_type,lam.mov_orig,lam.pmt_order_uuid
from
contract c
join loan l on c.uuid = l.contract_uuid 
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_mov lam on la.contr_acc_uuid = lam.contr_acc_uuid
where --l.agreement_no = 'WTCN-000544/20'and 
lam.mov_type = 'REP' and lam.cancelled = 'false' and lam.write_off = 'false' and l.status in ('S005','S006')
group by c.oid,lam.c_date,lam.post_date,lam.amount,lam.acc_type,lam.mov_orig,lam.pmt_order_uuid
except
select agreement_no,c_date,post_date,amount,acc_type,mov_orig,pmt_order_uuid from ext_repayment_hist
group by agreement_no,c_date,post_date,amount,acc_type,mov_orig,pmt_order_uuid
