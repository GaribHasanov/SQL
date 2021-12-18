with cte as (
select * from (
select concat(p.name,' ',p.first_name,' ',p.mid_name)SAA,c.oid,coalesce (ag.manual_model,admt.text)marka_,agim.imei,ci.entry,agim.idx,
row_number() over (partition by p.oid,ci.communication_type order by ci.cr_timestamp desc)rn
from 
contract c ---vazvrat nezere alinmayib
join loan l on c.uuid = l.contract_uuid
join partner p on l.disb_to_uuid = p.uuid
join comm_mean cm on p.commnctn_uuid = cm.communication_uuid
join comm_item ci on cm.comm_item_uuid = ci.uuid and ci.communication_type ='030'
join analysis an on l.analysis_uuid = an.uuid
join application ap on an.appl_uuid = ap.uuid
join addon_rappl ar on an.uuid = ar.analysis_uuid
join addon_good ag on ar.uuid = ag.rappl_uuid
left join addon_good_imei agim on ag.uuid = agim.addon_good_uuid
left join addon_good_model adm on ag.model_id = adm.id
left join addon_good_model_tx admt on adm.id = admt.pid
left join addon_good_group_tx aggt on ag.group_id = aggt.pid and aggt.lang = 'AZ'
where ag.group_id = '010' and l.status in ('S005','S006')
--and c.oid = 'R0000002'
)a
)

select distinct aa.oid,a.saa,a.marka_,
a.imei,b.imei,a.entry,a.rn
from
(select * from cte )aa
left join
(select * from cte where idx = 0)a on aa.oid = a.oid
left join
(select * from cte where idx = 1)b on aa.oid = b.oid