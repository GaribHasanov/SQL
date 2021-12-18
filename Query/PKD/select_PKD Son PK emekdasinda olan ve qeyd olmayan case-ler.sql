select c.oid agreement_no,lc.oid oid,date(acda.cr_timestamp)date_,date(now())today,
 extract(day from date(now())::timestamp - date(acda.cr_timestamp)::timestamp)datediffff,
ls.login collector,acda.division name_ ,c.uuid,acda.manual
from lcase lc  
join addon_coll_case acc on lc.uuid = acc.bus_case 
join contract c on   acc.loan_uuid = c.uuid  
join addon_coll_division_assign acda on acc.uuid = acda.case_uuid
left join luser ls on acda.user_uuid = ls.uuid
WHERE  ls.login != 'admin' and lc.end_timestamp is null --and c.oid  = 'R0011910'
and  not exists (

select distinct cc.oid kreditkodu,date(aca.cr_timestamp)cr_timestamp2,aca.uuid,aca.c_comment,ls.login
from contract cc 
join loan l on cc.uuid = l.contract_uuid 
join addon_coll_case acc on l.contract_uuid = acc.loan_uuid  
join addon_coll_action aca on acc.uuid = aca.case_uuid 
join lcase lc on acc.bus_case = lc.uuid 
join luser ls on aca.created_by = ls.uuid 
where  cc.oid = c.oid and aca.cr_timestamp >= '2021-07-23' and date(acda.cr_timestamp) <= aca.cr_timestamp 
--and cc.oid = 'R0011910'	

) and not exists (

select ccc.oid agreement_no,lc.oid oid,date(acda.cr_timestamp)date_,date(now())today,
ls.login collector,acda.division name_ ,c.uuid,acda.manual
from lcase lc  
join addon_coll_case acc on lc.uuid = acc.bus_case 
join contract ccc on   acc.loan_uuid = ccc.uuid  
join addon_coll_division_assign acda on acc.uuid = acda.case_uuid
left join luser ls on acda.user_uuid = ls.uuid
WHERE  ccc.oid = c.oid and acda.division = 'LEG'

)
ORDER BY datediffff DESC
 --and c.oid  = 'R0004956'
 
 
