select  row_number() over (partition by a.poid)index_,a.*,coalesce (b.max,0)"Max gecikmə"
from  
(select p.oid as poid,dl.id,dl.client as "ASA",l.agr_start_date"Ayırma Tarixi",l.appr_term"Təsdiq olunmuş müddət",
concat(+994,ci.entry)"Əlaqə nömrəsi",cast(dl.goods_price as decimal (18,2))"Vitrin qiyməti",
cast(loan_price as decimal (18,2))"Vitrin+Faiz" ,cast(down_payment as decimal (18,2))"Ilkin ödəniş",
cast(loan_amount as decimal (18,2))"Kredit_Məb" , la.outs_balance"Cari balans",la.arrear_days"Cari gecikmə"
from me_disb_loans dl 
join contract c on dl.id = c.oid
join loan l on c.uuid = l.contract_uuid
join partner p on l.disb_to_uuid = p.uuid
join comm_mean cm on  p.commnctn_uuid = cm.communication_uuid and cm.idx = 0
join comm_item ci on cm.comm_item_uuid = ci.uuid and ci.communication_type = '030'
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
where not exists (select * from loan lo where lo.disb_to_uuid = p.uuid and lo.status = 'S005')
and l.status ='S006' 

)a
left join(select dl.id,max(las.arrear_days_morning)
from me_disb_loans dl join contract c on dl.id = c.oid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on la.contr_acc_uuid = ca.uuid
join loan_accounting_hist las on la.contr_acc_uuid = las.loan_acc_uuid
where  las.arrear_days_morning  > 0
group by dl.id)b on a.id = b.id

