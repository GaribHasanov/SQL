select 
coalesce (dl.lo,dl.underwriter)LO,dl.id,dl.disb_date,dl.loan_amount,ml.status  
from me_disb_loans dl  
join me_loan ml on dl.id = ml.oid  
where dl.disb_date BETWEEN date_trunc('month', date(now()) ) - interval '1 month' AND date_trunc('month', now())::date - 1 
--date between first date and last date of the last month

