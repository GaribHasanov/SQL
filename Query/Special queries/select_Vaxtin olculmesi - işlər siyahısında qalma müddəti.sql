with cte as (
select distinct c.oid,mdl.disb_date,mdl.operator,coalesce(mdl.lo,mdl.underwriter)underwriter,
	mdl.shop,mdl.goods_price,mdl.loan_price,mdl.down_payment,mdl.loan_amount,
	ls.login,jti.name_,jti.start_,jti.end_ 

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
join luser ls on ls.uuid = jl.taskactorid_
left join me_disb_loans dl on c.oid = dl.id
where lc.c_type = 'RMAIN' --and  c.oid ='R0009534'
and jti.name_ in ('confirm application' , 'underwriter endorsement' )
--group by l.agreement_no,jl.date_ , jti.name_,jti.start_,jti.end_,jl.taskactorid_,brt.text,lst.text,dl.loan_price,dl.down_payment,mdl.lo,mdl.underwriter
order by jti.start_
)
select a.*,
(DATE_PART('day', min_undw::timestamp - min_oper::timestamp) * 24 + DATE_PART('hour', min_undw::timestamp -  min_oper::timestamp)) * 60 +DATE_PART('minute', min_undw::timestamp -  min_oper::timestamp)as vaxt
from (
select distinct aa.oid,aa.shop,aa.disb_date,aa.operator,aa.underwriter,aa.goods_price,aa.loan_price,aa.down_payment,aa.loan_amount,
       min(a.end_) over (partition by  aa.oid , a.name_)min_oper,
       min(b.start_) over (partition by  aa.oid , b.name_)min_undw
	   
 from 
 (select * from cte )aa
 left join
 (select * from cte where name_ = 'confirm application')a on aa.oid = a.oid
 left join
 (select * from cte where name_ = 'underwriter endorsement')b on aa.oid = b.oid
 )a
 
 where min_undw is not null