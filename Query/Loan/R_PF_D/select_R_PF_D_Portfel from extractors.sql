select distinct 
ls.login,coalesce (dl.lo,dl.underwriter)olLO,dl.id,dkf.outstanding_balance,dkf.days_in_arrear,dkf.date portfeldate,
CONCAT(ls.lastname,' ', ls.firstname,' ',ls.midname)currentLO,(date_trunc('month', now())::date - 1) as last_month_date
from me_disb_loans dl
join me_loan ml on dl.id = ml.oid
join me_daily_key_figures dkf on ml.uuid = dkf.loan
join contract c on dl.id = c.oid
join luser ls on c.responsible_uuid = ls.uuid
where dkf.kf_type = 'E'  
and coalesce (dl.lo,dl.underwriter) = CONCAT(ls.lastname,' ', ls.firstname,' ',ls.midname) -- this condition retrives only not assigned portfel which is not tranfered from one LO to other
and dkf.date = (date_trunc('month', now())::date - 1) -- this condition retrieves end of the last month
