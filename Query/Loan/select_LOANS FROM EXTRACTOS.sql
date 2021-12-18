select distinct 
dl.id,dl.client,coalesce (dl.lo,dl.underwriter)olLO,dl.shop,
CONCAT(ls.lastname,' ', ls.firstname,' ',ls.midname)currentLO,dl.goods_price,dl.loan_price,dl.down_payment,dl.loan_amount,dl.term,dl.disb_date,
ml.status,ml.completion_date,ml.zgoods,ml.zarr_days,ml.zmax_arr,ml.zmin_arr,ml.zarr_count,ml.loan_category,la.outs_balance
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
join contract c on dl.id = c.oid
join contract_accounting ca on c.uuid = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join luser ls on c.responsible_uuid = ls.uuid
where ml.status in ('S005','S006')


