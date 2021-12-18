select c.oid,json_extract_path(reply::json,'Response','Active') as test 
FROM addon_asanfinance aa
 join addon_rappl ar on aa.rappl_uuid = ar.uuid
 join analysis an on ar.analysis_uuid = an.uuid
 join loan l on l.analysis_uuid = an.uuid
 join contract c on l.contract_uuid = c.uuid
where service_id = '/api/v2/EmployeeInfo/' and http_status_code = '200'
limit 5