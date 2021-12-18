select c.oid,aggt.text,coalesce (admt.text,ag.manual_model)akse,coalesce (ag.manual_model,admt.text)man_,ag.price_val,ag.loan_price_val,l.agr_start_date
from 
contract c ---vazvrat nezere alinmayib
join loan l on c.uuid = l.contract_uuid
join analysis an on l.analysis_uuid = an.uuid
join application ap on an.appl_uuid = ap.uuid
join addon_rappl ar on an.uuid = ar.analysis_uuid
join addon_good ag on ar.uuid = ag.rappl_uuid
left join addon_good_model adm on ag.model_id = adm.id
left join addon_good_model_tx admt on adm.id = admt.pid
left join addon_good_group_tx aggt on ag.group_id = aggt.pid and aggt.lang = 'AZ'

where ag.group_id = '020' and l.status in ('S005','S006')
