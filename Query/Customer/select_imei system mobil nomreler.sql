with cte as (
select * from (
select l.agreement_no,concat(p.name ,' ',p.first_name,' ',p.mid_name)SAA,
coalesce (admt.text,ag.manual_model)akse,
coalesce (ag.manual_model,admt.text)man_,agi.imei,ci.entry,ci.communication_type,agi.idx,
row_number() over (partition by l.agreement_no,p.oid,ci.communication_type order by ci.cr_timestamp )rn
from 
contract c 
join loan l on c.uuid = l.contract_uuid
join partner p on l.disb_to_uuid = p.uuid
join comm_mean cm on p.commnctn_uuid = cm.communication_uuid
join comm_item ci on cm.comm_item_uuid = ci.uuid
join analysis an on l.analysis_uuid = an.uuid
join application ap on an.appl_uuid = ap.uuid
join addon_rappl ar on an.uuid = ar.analysis_uuid
join addon_good ag on ar.uuid = ag.rappl_uuid
join addon_good_imei agi on ag.uuid = agi.addon_good_uuid
left join addon_good_model adm on ag.model_id = adm.id
left join addon_good_model_tx admt on adm.id = admt.pid
where l.status in ('S005','S006')
--and l.agreement_no = 'R0002003'
and ci.communication_type = '030'
)a

)
select distinct cte.agreement_no,cte.saa,cte.akse,cte.man_,cte.entry,a.imei,b.imei,cte.rn
from cte
left join
(select * from cte where idx = '0')a on cte.agreement_no = a.agreement_no
left join
(select * from cte where idx = '1')b on cte.agreement_no = b.agreement_no
where cte.rn = 1
order by cte.entry
