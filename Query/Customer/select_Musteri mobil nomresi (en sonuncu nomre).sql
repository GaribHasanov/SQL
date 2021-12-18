with cte as (
	select * from (
select id,ci.entry nomre,row_number() over (partition by a.id,a.partner,ci.communication_type order by ci.cr_timestamp desc)rn
	from (
select dl.id,p.oid poid,ml.partner,p.commnctn_uuid	
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
join partner p on ml.partner = p.uuid
--where ml.status = 'S005'
)a
join comm_mean cm on a.commnctn_uuid = cm.communication_uuid
join comm_item ci on cm.comm_item_uuid = ci.uuid
where ci.communication_type = ('030')
	)bb
where bb.rn = 1 
)
select distinct id,concat('+994','',nomre)nomre
from 
  cte









