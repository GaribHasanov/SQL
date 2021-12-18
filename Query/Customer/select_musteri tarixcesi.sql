---kreditleri uzre 12 aydan yuxari (daxil olmaqla) kredit tarixcesi formalasmis musteriler
select * from (
select  distinct p_uuid,count(*) over (partition by p_uuid)count_rep
from (
select distinct p.uuid p_uuid,
	to_char(po.c_date, 'YYYY-MM')
from
contract c
join loan l on c.uuid = l.contract_uuid 
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_mov lam on la.contr_acc_uuid = lam.contr_acc_uuid
join payment_order po on lam.pmt_order_uuid = po.uuid
where lam.mov_type = 'REP' and lam.cancelled = 'false' and l.status in ('S005','S006')
--and p.uuid = 'F78D64B74B76449E84606AB9A113792A'

)aa
)aaa
where count_rep >=12
