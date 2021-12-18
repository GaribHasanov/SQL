with cte as (
select c.oid,en.results,ls.login HOLA,ls2.login UNDW,en.c_type,en.compl_date,en.endors_comment,
count(c.oid) over (partition by ls.login)counte
from 
contract c 
join loan l on l.contract_uuid = c.uuid
join analysis an on an.uuid = l.analysis_uuid
join addon_rappl ar on ar.analysis_uuid = an.uuid
join addon_rappl_endors are on ar.uuid = are.rappl_uuid
join endorsement en on are.endors_uuid = en.uuid
join luser ls on en.endorser = ls.uuid
join luser ls2  on en.initiator = ls2.uuid
where en.results = '400'  --and c.oid ='R0015523'
)
select distinct oid,HOLA,UNDW,compl_date,results,counte
from 
cte