select a.*,b.max_arr
from (

select id,client ,datediff,term,disb_date,loan_amount,
zarr_days,loan_category,outs_balance

from (
select distinct dl.id,dl.client,dl.loan_amount,
row_number() over (partition by ml.partner order by dl.disb_date desc)rn,
dl.term,dl.disb_date,
extract(day from date(now())::timestamp - dl.disb_date::timestamp)datediff,
ml.zarr_days,ml.loan_category,la.outs_balance
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
join contract c on dl.id = c.oid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join luser ls on c.responsible_uuid = ls.uuid
where ml.status ='S005'
and not exists (select distinct lmm.contr_acc_uuid from loan_acc_mov lmm 
where lmm.write_off = true and 
lmm.cancelled = 'false' and lmm.write_off_reas = '050' and lmm.contr_acc_uuid = ca.uuid)
and not exists (
select distinct l.oid,dkf.date,days_in_arrear
 from me_loan l    
 join me_daily_key_figures dkf on dkf.loan=l.uuid   
 where dkf.kf_type='M' 
 and dkf.days_in_arrear > 15
 and dkf.date > (current_date - INTERVAL '12 months')
 and l.oid = c.oid
)
)aa
where rn = 1
)a
join 

(
 
 select distinct l.oid, max(dkf.days_in_arrear)over (partition by l.oid)max_arr
 from me_loan l    
 join me_daily_key_figures dkf on dkf.loan=l.uuid   
 where dkf.kf_type='M' 
 and dkf.days_in_arrear > 0

)b on a.id = b.oid




/*
Z?hm?t olmasa asagdaki s?rtl?r? cavab ver?n müst?ril?rin siyahisini t?qdim ed?rdin.

1.	Son 12 ayda bir d?f?y? 15 günd?n az gecikm?si olan
2.	AKTIV BORCU OLANLAR ÜZR?: Son kreditini götürdüyü günd?n minimum 6 ay keçmis. Vozvratlar son götürülmüs kredit kimi n?z?r? alinmasin.
3.	AKTIV BORCU OLMAYANLAR ÜZR?: 2-ci b?ndin s?rti n?z?r? alinmasin
4.	Aktiv ?n çoxu 1 krediti olan. (Y?ni ya bir aktiv krediti olsun ya da aktiv krediti olmasin)
5.	Cari gecikm? günü 5 günd?n az olan

Sütunlar:
1.	Kredit kodu
2.	Müst?ri S.A.A
3.	Son kreditin ilkin m?bl?gi
4.	Qaliq ?sas borc
5.	Cari gecikm?
6.	Son kreditin verilm? tarixi
7.	Müdd?t
8.	Bir d?f?y? maksimal gecikm? son kredit üzr?

*/