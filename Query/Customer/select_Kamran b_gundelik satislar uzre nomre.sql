with cte as (
select * from (
select coalesce(dl.lo,underwriter)lo,dl.id,dl.disb_date,dl.loan_amount,dl.term,
dl.client,dl.shop,la.outs_balance,ci.entry,
ci.communication_type,ci.created,
row_number() over (partition by dl.id,p.oid,ci.communication_type order by ci.cr_timestamp desc)rn
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
join contract c on dl.id = c.oid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join partner p on ml.partner = p.uuid
join comm_mean cm on p.commnctn_uuid = cm.communication_uuid
join comm_item ci on cm.comm_item_uuid = ci.uuid
where ci.communication_type in ('010', '020', '030')
--and p.oid = '0000000853'
)a
where a.rn = 1
)
select distinct cte.id,cte.lo,cte.disb_date,cte.loan_amount,cte.term,
cte.client,cte.shop,cte.outs_balance,
a.entry ev,b.entry ish,c.entry mob
from 
  cte
  left join
  (select * from cte where communication_type = '010') a on cte.id = a.id
  left join 
  (select * from cte where communication_type = '020') b on cte.id = b.id
  left join 
  (select * from cte where communication_type = '030') c on cte.id = c.id
