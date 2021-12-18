select agreement_no,status,asa,lpd,amount,login,title,cd,loan_price
from (
select l.agreement_no,concat(p.name,' ',p.first_name,' ',p.mid_name)asa,
case when l.status = 'S005' then 'Cari'  when l.status = 'S006' then 'Bitmiş' end as status,max(po.c_date)over (partition by l.agreement_no)lpd,po.origin,po.amount,
sum(po.amount)over (partition by l.agreement_no,po.cash_desk_uuid)summe,     
po.movement_form,lam.uuid,ls.login,cd.title,l.completion_date cd,dl.loan_price,
row_number() over (partition by l.agreement_no,po.cash_desk_uuid order by lam.c_timestamp)rn,
row_number() over (partition by l.agreement_no,date(lam.c_timestamp) order by lam.c_timestamp desc )rn2,lam.c_timestamp
from contract c
join loan l on c.uuid = l.contract_uuid 
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_mov lam on la.contr_acc_uuid = lam.contr_acc_uuid
join payment_order po on lam.pmt_order_uuid = po.uuid
join luser ls on lam.created_by = ls.uuid
join cash_desk cd on po.cash_desk_uuid = cd.uuid
left join disb_loans dl on c.oid = dl.id
where --agreement_no = 'WTCN-003128/20' and
l.status = 'S006' and
lam.mov_type = 'REP' and lam.cancelled = 'false' and
po.origin = 'S001'
and po.movement_form = '010' and l.completion_date = po.c_date
group by l.agreement_no,po.c_date,po.amount,po.origin,po.movement_form,l.status,po.uuid,p.name,p.first_name,p.mid_name,
l.status,po.c_date,po.amount,po.origin,po.movement_form,lam.uuid,ls.login,cd.title,l.completion_date,dl.loan_price
)a
where rn2=1 --and agreement_no = 'R0005457'


