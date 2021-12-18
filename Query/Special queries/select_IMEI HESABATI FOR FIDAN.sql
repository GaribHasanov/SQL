with cte as (
select  c.oid,concat(p.name,' ',p.first_name,' ',p.mid_name)name_,la.outs_balance,la.arrear_princ,la.arrear_days,
coalesce (admt.text,ag.manual_model)akse,
coalesce (ag.manual_model,admt.text)man_,agi.*,
row_number()over (partition by c.oid)rn
from  contract c
join loan l on c.uuid = l.contract_uuid
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on la.contr_acc_uuid = ca.uuid
join analysis an on l.analysis_uuid = an.uuid
join application ap on an.appl_uuid = ap.uuid
join addon_rappl ar on an.uuid = ar.analysis_uuid
join addon_good ag on ar.uuid = ag.rappl_uuid
left join addon_good_imei agi on ag.uuid = agi.addon_good_uuid
left join addon_good_model adm on ag.model_id = adm.id
left join addon_good_model_tx admt on adm.id = admt.pid
where  agi.imei is not null
and l.status in ('S005','S006')

)
select distinct aa.oid,aa.name_,aa.outs_balance,aa.arrear_princ,aa.arrear_days,a.imei,b.imei,c.imei,d.imei,e.imei,f.imei
from
(select * from cte )aa
left join
(select * from cte where rn = 1)a on aa.oid = a.oid
left join
(select * from cte where rn = 2)b on aa.oid = b.oid
left join
(select * from cte where rn = 3)c on aa.oid = c.oid
left join
(select * from cte where rn = 4)d on aa.oid = d.oid
left join
(select * from cte where rn = 5)e on aa.oid = e.oid
left join
(select * from cte where rn = 6)f on aa.oid = f.oid

