select agreement_no,status,min_,max_,mağaza,collector,(vaxt * interval '1 min') as cem,
COALESCE(cast(loan_price as varchar),'')as loan_price,COALESCE(cast(down_payment as varchar),'')as down_payment,LO
from (select *,
(DATE_PART('day', max_::timestamp - min_::timestamp) * 24 + DATE_PART('hour', max_::timestamp -  min_::timestamp)) * 60 +DATE_PART('minute', max_::timestamp -  min_::timestamp)as vaxt
from (select l.agreement_no,lst.text status,
row_number()over(partition by l.agreement_no)rn,
min(jti.start_)over(partition by l.agreement_no)min_,max(jti.end_)over(partition by l.agreement_no)max_,
jl.date_ , --jti.name_,--jti.start_,jti.end_,
(select login from luser lse where lse.uuid =jl.taskactorid_)collector,brt.text mağaza,dl.loan_price,dl.down_payment,
 coalesce(mdl.lo,mdl.underwriter)LO
from 
me_disb_loans mdl 
join contract c on mdl.id = c.oid
join loan l on c.uuid = l.contract_uuid 
join jbpm_variableinstance jvi on c.uuid = jvi.STRINGVALUE_
join jbpm_processinstance jpi on jpi.id_ = jvi.processinstance_
join jbpm_log jl on jpi.roottoken_ = jl.token_
join jbpm_taskinstance jti on jl.taskinstance_ = jti.id_
join jbpm_task jt on jti.task_ = jt.id_
join lcase_proc lcp on jpi.id_ = lcp.process_id
join lcase lc on lcp.case_uuid = lc.uuid
join branch br on c.branch_uuid = br.uuid
join branch_tx brt on br.uuid = brt.branch_uuid and lang='AZ'
join loan_status_tx lst on l.status = lst.pid and lst.lang='AZ'
left join me_disb_loans dl on c.oid = dl.id
where lc.c_type = 'RMAIN' and l.agreement_no ='R0012087'
and jl.taskactorid_ is not  null
and jl.taskactorid_ != '6564c386cfd34ebead3c94c278a2620b' and l.status in('S005','S006')
group by l.agreement_no,jl.date_ , jti.name_,jti.start_,jti.end_,jl.taskactorid_,brt.text,lst.text,dl.loan_price,dl.down_payment,mdl.lo,mdl.underwriter
)a
where rn=1
)b

--select * from me_disb_loans limit 5