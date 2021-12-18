select a.*,b.max_ "Max gecikm?"
from  
(
select  l.status ,p.oid poid,dl.id,dl.client as "ASA",l.agr_start_date"Ayirma Tarixi",l.appr_term"T?sdiq olunmus müdd?t",
cast(dl.goods_price as decimal (18,2))"Vitrin qiym?ti",
cast(loan_price as decimal (18,2))"Vitrin+Faiz" ,cast(down_payment as decimal (18,2))"Ilkin öd?nis",
cast(loan_amount as decimal (18,2))"Kredit_M?b" , la.outs_balance"Cari balans",la.arrear_days"Cari gecikm?"
from me_disb_loans dl 
join contract c on dl.id = c.oid
join loan l on c.uuid = l.contract_uuid
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
where exists (select count(lo.agreement_no)cn, p.oid from loan lo where lo.disb_to_uuid = p.uuid and lo.status = 'S005' group by p.oid having count(lo.agreement_no) = 1 --Aktiv kredit sayi 1 olan;)
and  '2021-02-17' >=  l.agr_start_date and la.arrear_days = 0 and l.status = 'S005'
)a
left join(
select id,max_ from (
select dl.id,max(las.arrear_days_morning) max_ -----Bir defeye 10 günden çox gecikmesi olmayan;
from me_disb_loans dl 
join contract c on dl.id = c.oid
join loan l on c.uuid = l.contract_uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on la.contr_acc_uuid = ca.uuid
join loan_accounting_hist las on la.contr_acc_uuid = las.loan_acc_uuid
where arrear_days_morning >= 0 and l.status = 'S005'
	
group by id
)aa	
where max_ <= 10 

)b on a.id = b.id

where b.max_ is not null


