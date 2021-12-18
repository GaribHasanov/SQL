select mb.code as branchCode,
       mb.branch_name as branchName,
		l.oid as loanCode,
		dkf.amount_disbursed as disbursedAmount,
		l.currency as currency,
		dkf.outstanding_balance as outstandingBalance,
		l.disbursement_date as disbursementDate,
		l.planned_completion_date as plannedEndDate,
		dkf.last_rep_date as lastRepaymentDate,
		dkf.last_rep_amount	as lastRepaymentAmount,
		l.zlo as loanOfficer,
		dkf.days_in_arrear as daysInArrear,
		dkf.principal_in_arrear as arearsAmount,	
		dkf.pen_due as accruedPenalty,
		dkf.total_rep_pen as paidPenalty,
		l.zarr_count as arrearsCount,
		l.zmax_arr as maxDaysArrears,
		l.zmin_arr as minDaysArrears,
		mp.oid as clientCode,
		mp.full_legal_name as clientName,
		l.zguar1 as guarantor1Code,
		l.zguar1_name  as guarantor1Name,
		l.zguar2  as guarantor2Code,
		l.zguar2_name  as guarantor2Name,
		l.zgoods  as goods,
		mc.lo as responsibleLo,
		mc.soft as responsibleSoft,
		mc.comment_date as lastCommentDate,
		mc.comment1 as comment1,
		mc.comment2 as comment2,
		mc.comment3 as comment3,
		mc.promise_date as promiseDate,
		mc.promise_amount as promiseAmount
from me_loan l 	
	inner join me_daily_key_figures dkf 
		on dkf.loan=l.uuid
	inner join me_branch mb 
		on mb.uuid=l.branch
	inner join me_partner mp 
		on mp.uuid=l.partner
	left join me_coll_cases mc
        on mc.loan=l.uuid and mc.active=TRUE	
where dkf.date='2020-09-25' and dkf.kf_type='M' and dkf.days_in_arrear>0 



