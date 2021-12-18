select a.*,coalesce(b.countdayinarrar,'0')countdayinarrar,coalesce(b.maxarrdayinperiod,'0')maxarrdayinperiod
from (
select distinct 
dl.id,dl.client,ml.partner,dl.shop,
dl.goods_price,dl.loan_price,dl.down_payment,dl.loan_amount,dl.term,dl.disb_date,
ml.status,ml.zgoods
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
join contract c on dl.id = c.oid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join luser ls on c.responsible_uuid = ls.uuid
where ml.status = 'S006' and
	shop = 'Nizami' and not exists (select mll.oid from me_loan mll where status ='S005' and mll.partner = ml.partner)
--and dl.id = 'R0003860'
)a

left join 
(
select distinct 
dl.id,
count(*) over (partition by dl.id)countdayinarrar,
 max(dkf.days_in_arrear) over (partition by dl.id)maxarrdayinperiod
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
join me_daily_key_figures dkf on ml.uuid = dkf.loan
join contract c on dl.id = c.oid
join luser ls on c.responsible_uuid = ls.uuid
where dkf.kf_type = 'M' and dkf.days_in_arrear >0 and
	dkf.date > (current_date - INTERVAL '12 months')  
and not exists (
select ml2.oid , dkf2.days_in_arrear from me_loan ml2
join me_daily_key_figures dkf2 on ml2.uuid = dkf2.loan
where dkf2.date > (current_date - INTERVAL '12 months') and 
	dkf2.kf_type = 'M' and dkf2.days_in_arrear >45 and ml2.oid = dl.id
)
--and dl.id = 'R0003860'

)b on a.id = b.id


--birdefelik gecikmesi 45 gunden cox olmayan ve birdefelik gecikmeleri 120 gunden cox olmayan cari krediti olmayan nizami magazasindan goturulmus kreditler