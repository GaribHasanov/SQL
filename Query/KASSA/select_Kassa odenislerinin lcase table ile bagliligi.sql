with WT as ( select distinct aa.*
	from (
select distinct
lc.oid,lc.c_type , jl.date_ , jti.name_, row_number()over (partition by lc.oid order by jl.date_ desc)rn,
(select login from luser lse where lse.uuid =jl.taskactorid_)collector ,
(select login from luser lse where lse.uuid =jl.taskoldactorid_)crold ,lc.closed,lc.end_timestamp lc_end_time
from 
jbpm_variableinstance jvi 
join jbpm_processinstance jpi on jpi.id_ = jvi.processinstance_
join jbpm_log jl on jpi.roottoken_ = jl.token_
join jbpm_taskinstance jti on jl.taskinstance_ = jti.id_ 
join jbpm_task jt on jti.task_ = jt.id_
join lcase_proc lcp on jpi.id_ = lcp.process_id
join lcase lc on lcp.case_uuid = lc.uuid
where lc.c_type = 'MONYEW'
and --jl.taskactorid_ != '6564c386cfd34ebead3c94c278a2620b' and
jti.name_ = 'money in the way'
		
group by lc.oid,lc.c_type , jl.date_ , jti.name_,lc.closed,lc.end_timestamp,jl.taskactorid_,jl.taskoldactorid_
)aa	where rn = 1
	) 
	select * from WT
	where oid = '0000004491'
	
	
	
	
	
select  lc.oid,cdo.oid,cdo.c_amount,cdo.cancelled,cdo.created,cdo.c_timestamp,cdo.descr,cdo.c_comment,ls.login,cd.title
from lcase lc
join addon_money_in_the_way  mid on mid.bus_case = lc.uuid
join cash_desk_operation cdo on mid.from_uuid = cdo.uuid
join luser ls on cdo.cashier_uuid = ls.uuid
join cash_desk cd on cdo.cash_desk_uuid = cd.uuid 
where lc.c_type = 'MONYEW'
and cdo.cancelled = false
order by lc.c_timestamp desc