select * from (
select a.*,XMLTABLE.*             
from (
select an.oid ,ad.content
from add_data ad
join addon_rclient_add_data anad on ad.uuid = anad.data_uuid
join addon_rclient arc on anad.rclient_uuid = arc.uuid
join addon_rappl ar on arc.rappl_uuid = ar.uuid
join analysis an on ar.analysis_uuid = an.uuid
where ad.config_id = 'xe_rclient'
)a,XMLTABLE ('/rclient' PASSING cast(replace((a.content), 'encoding="utf-8"', '')as xml) 
                 COLUMNS
                   salary text PATH '(client_salary /@value)[1]' 
                    ) --where a.oid = 'A0000023'
)aa
 left join (

select l.agreement_no,an.oid anoid,
json_array_elements(cast (reply as json )-> 'Response' -> 'Active'  )->'EmployeeInfo'->'MonthlySalary' asan_əmək_haqqı
from addon_asanfinance aa
left join addon_rappl ar on aa.rappl_uuid = ar.uuid
left join analysis an on ar.analysis_uuid = an.uuid
left join loan l on l.analysis_uuid = an.uuid
where service_id = '/api/v1/EmployeeInfo/' and http_status_code = '200'
)bb
on aa.oid = bb.anoid








