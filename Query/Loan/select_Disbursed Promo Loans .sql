select l.agreement_no"Müqavilə nömrəsi",lus.login "Operator",brt.text "Mağaza",
case when b.oid = 'FST' then 'Bəli' else 'Xeyr' end as "Fast Loan",
case when infs.description = 'Promo' then 'Bəli' else 'Xeyr' end as "Promo",
aggt.text"Qrup" ,admt.text"Məhsulun adı",
ag.quantity"Miqdarı",ag.price_val "Vitrin qiyməti",ag.loan_price_val "Kredit məbləği"
from 
contract c 
join loan l on c.uuid = l.contract_uuid
join analysis an on l.analysis_uuid = an.uuid
join application ap on an.appl_uuid = ap.uuid
join boc_version bc on c.prod_ver_uuid = bc.uuid
join boc b on bc.boc_uuid = b.uuid
join branch br on c.branch_uuid = br.uuid
join branch_tx brt on br.uuid = brt.branch_uuid and brt.lang = 'AZ'
join luser lus on c.responsible_uuid = lus.uuid
join addon_rappl ar on an.uuid = ar.analysis_uuid
join addon_good ag on ar.uuid = ag.rappl_uuid
join addon_good_model adm on ag.model_id = adm.id
join addon_good_model_tx admt on adm.id = admt.pid
join addon_good_group_tx aggt on ag.group_id = aggt.pid and aggt.lang = 'AZ'
left join inf_source infs on ap.inf_source_uuid = infs.uuid
where l.status in ('S005','S006') and ag.group_id in ('010','030','040')
limit 5