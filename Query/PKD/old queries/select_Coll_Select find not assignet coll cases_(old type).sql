with WT as ( select distinct aa.*,row_number()over (partition by aa.agreement_no order by aa.date_ desc)rn2
	from (
select distinct row_number() over (partition by l.agreement_no,date(jl.date_) order by jl.date_ desc)rn,
l.agreement_no,lc.oid,lc.c_type , jl.date_ , jti.name_,
(select login from luser lse where lse.uuid =jl.taskactorid_)collector ,
(select login from luser lse where lse.uuid =jl.taskoldactorid_)crold ,c.uuid as c_uuid,lc.closed
from 
contract c
join loan l on c.uuid = l.contract_uuid 
join jbpm_variableinstance jvi on c.uuid = jvi.STRINGVALUE_
join jbpm_processinstance jpi on jpi.id_ = jvi.processinstance_
join jbpm_log jl on jpi.roottoken_ = jl.token_
join jbpm_taskinstance jti on jl.taskinstance_ = jti.id_ 
join jbpm_task jt on jti.task_ = jt.id_ 
join lcase_proc lcp on jpi.id_ = lcp.process_id
join lcase lc on lcp.case_uuid = lc.uuid
where lc.c_type = 'COLL' and lc.closed = false --and l.agreement_no = 'WTCN-000830/20'  --'WTCN-002488/20' -- 'WTCN-000025/20'
--and jl.taskactorid_ is  null
--and ( date(jti.end_) is null )

)aa	where rn=1
	) 
	select rn,rn2,agreement_no,oid,c_type,date_,collector,name_,c_uuid  from WT
	where collector is null and
	rn2 = 1
	group by rn,rn2,agreement_no,oid,c_type,date_,collector,name_,c_uuid
---order by collector
	

