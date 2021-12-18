select a.* ,c.*, b.sum_other_loans_,b.count_curr_all_loans_,d.count_rep,b.arrear_days curr_arr_days
from (
select  
dl.id,
	dl.client,ml.partner,dl.gender,dl.disb_date,dl.down_payment,dl.loan_amount,
ml.status,ml.zgoods,count(dl.id) over (partition by ml.partner)count_all_loans__int
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
where ml.status = 'S005'	
	and not exists (

select ml2.oid ,ml2.partner, dkf2.days_in_arrear 
from me_loan ml2 
join me_daily_key_figures dkf2 on ml2.uuid = dkf2.loan
where dkf2.date > (current_date - INTERVAL '12 months') and 
	dkf2.kf_type = 'M' and dkf2.days_in_arrear >20
	and ml2.partner = '7EEED78FD9FC4E21B90B7C5D10735DD8' 
	and ml2.partner = ml.partner
)
	
	and ml.partner = '7EEED78FD9FC4E21B90B7C5D10735DD8'
)a
left join
(
select distinct p.uuid p_uuid, p.oid,
	sum(la.outs_balance) over (partition by p.uuid)sum_other_loans_,
	count(c.oid) over (partition by p.uuid)count_curr_all_loans_,la.arrear_days
from contract c
join loan l on c.uuid = l.contract_uuid	
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid 
where l.status = 'S005'
	and p.uuid = '7EEED78FD9FC4E21B90B7C5D10735DD8'
)b
on a.partner = b.p_uuid

left join
(
select  
dl.id,ml.partner,
dl.goods_price,dl.loan_price,dl.down_payment,dl.loan_amount,
row_number() over (partition by ml.partner order by dl.loan_amount desc)maxl,
dl.term
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid

)
c
on a.partner = c.partner
left join
(
select * from (
select  distinct p_uuid,count(*) over (partition by p_uuid)count_rep
from (
select distinct p.uuid p_uuid,
	to_char(po.c_date, 'YYYY-MM')
from
contract c
join loan l on c.uuid = l.contract_uuid 
join partner p on l.disb_to_uuid = p.uuid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join loan_acc_mov lam on la.contr_acc_uuid = lam.contr_acc_uuid
join payment_order po on lam.pmt_order_uuid = po.uuid
where lam.mov_type = 'REP' and lam.cancelled = 'false' and l.status in ('S005','S006')

)aa
)aaa

)
d
on a.partner = d.p_uuid
where c.maxl = 1
and d.count_rep >=12 and b.arrear_days <=5


--1.	Aktiv 1 borcu olan; --( column olaraq elave edilib amma sertde nezere alinnmayib)
--2.	Minimum 12 ayliq kredit tarixçesi olan ve ya aktiv borcu üzre 6 müxtelif ayda ödenisi olan
--3.	Son 12 ayda bir defeye 20 günden çox gecikmesi olmayan
--4.	Cari gecikmesi 5 günden çox olmayan
