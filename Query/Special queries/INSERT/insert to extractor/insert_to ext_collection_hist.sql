delete from ext_collection_hist where lc_end_time is null;
with WT as ( select distinct aa.*
	from (
select distinct row_number() over (partition by l.agreement_no,date(jl.date_),jl.taskactorid_ order by jl.date_)rn,
l.agreement_no,lc.oid,lc.c_type , jl.date_ , jti.name_,
(select login from luser lse where lse.uuid =jl.taskactorid_)collector ,
(select login from luser lse where lse.uuid =jl.taskoldactorid_)crold ,c.uuid as c_uuid,lc.closed,lc.end_timestamp lc_end_time
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
where lc.c_type = 'COLL' --and l.agreement_no ='R0004921'
and jl.taskactorid_ is not  null
and jl.taskactorid_ != '6564c386cfd34ebead3c94c278a2620b'
and jti.name_ in ('_ENTER ACTIONS LO','_ENTER ACTIONS SOFT COLLECTOR','ENTER ACTIONS LEGAL DEPARTMENT')
--and ( lc.end_timestamp is null or date(lc.end_timestamp) >= '2021-04-01')
group by l.agreement_no,lc.oid,lc.c_type , jl.date_ , jti.name_,c.uuid,lc.closed,lc.end_timestamp,jl.taskactorid_,jl.taskoldactorid_
)aa	where rn=1
	) 
	insert into ext_collection_hist (agreement_no,oid,c_type,date_,collector,name_,c_uuid,lc_end_time)
	select agreement_no,oid,c_type,date_,collector,name_,c_uuid,lc_end_time from WT
	group by agreement_no,oid,c_type,date_,collector,name_,c_uuid,lc_end_time
    except
	select agreement_no,oid,c_type,date_,collector,name_,c_uuid,lc_end_time from ext_collection_hist
    group by agreement_no,oid,c_type,date_,collector,name_,c_uuid,lc_end_time