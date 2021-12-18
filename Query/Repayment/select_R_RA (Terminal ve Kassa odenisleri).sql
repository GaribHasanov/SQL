select * from (
select l.agreement_no,c.oid,concat(p.name,' ',p.first_name,' ',p.mid_name)asa,case when l.status = 'S005' then 'Cari'  when l.status = 'S006' then 'Bitmiş' end as status,
po.c_date,po.amount,COALESCE(mft.text,'Ekvayrinq')terminal,mo.text,
COALESCE(po.ext_number,'')ext_number
from contract c
join loan l on c.uuid = l.contract_uuid 
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_mov lam on la.contr_acc_uuid = lam.contr_acc_uuid
join payment_order po on lam.pmt_order_uuid = po.uuid
left join movement_form_tx mft on po.movement_form = mft.pid and mft.lang = 'EN'
left join loan_acc_mov_orig_tx mo on po.origin = mo.pid and mo.lang = 'AZ'
where lam.mov_type = 'REP' and lam.cancelled = 'false' and lam.write_off = 'false' and l.status in ('S005','S006')
group by l.agreement_no,po.amount,po.c_date,po.ext_number,po.uuid,c.oid,l.status,mo.text,mft.text,
p.name,p.first_name,p.mid_name
)a
