select  c.oid kredit_kodu,CONCAT(p.name,' ', p.first_name,' ',p.mid_name)"SAA",l.agr_start_date "Ayrilma Tarixi",
l.approved_amount "Kredit Məbləği",l.approved_amount-las.outs_balance_evening "Ödəniş Məbləği",
las.outs_balance_evening "Qalıq Kapital"
from contract c
join loan l on c.uuid = l.contract_uuid
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_accounting_hist las on la.contr_acc_uuid = las.loan_acc_uuid
where l.status in ('S005','S006') 
and ('2021-01-31' between las.date_from and las.date_to)
and (l.completion_date is null or l.completion_date > '2021-08-31' )
group by  c.oid,p.name,la.outs_balance,l.approved_amount,
las.outs_balance_evening,las.outs_balance_morning,las.date_from,las.date_to,p.first_name,p.mid_name,
l.agr_start_date

--DATE_PART('day', '2021-08-17'::timestamp - las.date_from::timestamp) + las.arrear_days_morning arr_day

