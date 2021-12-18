select (max_disb_dt - INTERVAL '6 months'),a.* , b.sum_other_loans_
from (
	select * from (
select  
dl.id,dl.client,ml.partner,dl.gender,max(dl.disb_date) over (partition by ml.partner)max_disb_dt,
dl.goods_price,dl.loan_price,dl.down_payment,dl.loan_amount,row_number() over (partition by ml.partner order by dl.loan_amount desc)maxl,
dl.term,dl.disb_date,
ml.status,ml.zgoods
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
where ml.status = 'S006' and
not exists ( ----Aktiv borcu olmayan
select mll.oid from me_loan mll where status ='S005' and mll.partner = ml.partner)
and ml.partner = 'D5D3A4ECAFE944F8BAAA2D5E87E159CA'
)inquery
	where not exists (
--- SON kreditinden GERI 6 ay erzinde bir defeye 20 günden çox gecikmeyen
select ml2.oid ,ml2.partner, dkf2.days_in_arrear 
from me_loan ml2 
join me_daily_key_figures dkf2 on ml2.uuid = dkf2.loan
where dkf2.date between (max_disb_dt - INTERVAL '6 months') and  max_disb_dt and 
	dkf2.kf_type = 'M' and dkf2.days_in_arrear >20
	and ml2.partner = 'D5D3A4ECAFE944F8BAAA2D5E87E159CA' 
	and ml2.partner = inquery.partner
	
)
	
)a
left join
(
--- cari kreditlerin cem balansi
select distinct p.uuid p_uuid, p.oid,sum(la.outs_balance) over (partition by p.uuid)sum_other_loans_
from contract c 
join loan l on c.uuid = l.contract_uuid	
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid 
where l.status in ('S005','S006') --and p.oid = '0000031859'
	and p.uuid = 'D5D3A4ECAFE944F8BAAA2D5E87E159CA'

)b
on a.partner = b.p_uuid

where a.maxl = 1

1.	Aktiv borcu olmayan;
2.	SON kreditinden GERI 6 ay erzinde bir defeye 20 günden çox gecikmeyen
