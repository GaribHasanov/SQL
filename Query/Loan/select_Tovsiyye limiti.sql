select distinct SAA,login,cast(recomm_sum as decimal(18,2)),
cast(recomm_outs_balance as decimal(18,2)),limit_ ,limit_ - cast(recomm_outs_balance as decimal(18,2))curr_remain_limit
from (
select ls.login,cast('50000' as decimal(18,2)) as limit_ , 
sum(la.disb_amount)  over (partition by ls.login)recomm_sum,
sum(la.outs_balance) over (partition by ls.login)recomm_outs_balance,concat(ls.firstname,' ',ls.lastname,' ',ls.midname)SAA

from contract c 
join loan l on c.uuid = l.contract_uuid
join contract_accounting ca on c.uuid  = ca.contract_uuid
join loan_accounting la on ca.uuid = la.contr_acc_uuid
join addon_rappl ar on l.contract_uuid = ar.loan_uuid
join luser ls on ar.recommended_by_uuid = ls.uuid
where l.status in ('S005','S006') and 
not exists (select distinct lmm.contr_acc_uuid from loan_acc_mov lmm 
where lmm.cancelled = 'false' and lmm.write_off = true and lmm.write_off_reas = '050' and lmm.contr_acc_uuid = ca.uuid)
)a
