select m?lumat,
case when (replace(cast( a.status as varchar),'"',''))= 'Successful' then 'Ugurlu' else (replace(cast( a.status as varchar),'"','')) end as status,
cavab,pin,asa,date(request_timestamp)Tarix,request_timestamp,login,sifaris_kodu,müqavil?_kodu,exception_text,sorgu_müdd?ti,http_status_code,uuid
 from (
select asan.uuid,cast(asan.reply as json)->'Status' -> 'Name' as status,
                 cast(asan.reply as json)->'Status' -> 'Message' as cavab,
case when asan.service_id = '/api/v1/PersonalInfo/' then  'V?siq?'
                      when asan.service_id = '/api/v2/PersonalInfo/' then  'V?siq?'
                      when asan.service_id = '/api/v1/EmployeeInfo/' then  'Is yeri' 
					  when asan.service_id = '/api/v2/EmployeeInfo/' then  'Is yeri'
					  when asan.service_id = '/api/v1/PensionInfo/'  then  'T?qaüd'
					  when asan.service_id = '/api/v2/PensionInfo/'  then  'T?qaüd' end as m?lumat,
asan.pin,concat(p.name,' ',p.first_name,' ',p.mid_name)asa,asan.request_timestamp,
--case when asan.success = true then 'ugurlu' when asan.success = false then 'ugursuz' end as status,
ls.login ,ap.oid sifaris_kodu,coalesce(l.agreement_no,'imtina') müqavil?_kodu,asan.exception_text,
DATE_PART('minute', asan.reply_timestamp::timestamp -  asan.request_timestamp::timestamp) * 60 + DATE_PART('second', asan.reply_timestamp::timestamp -  asan.request_timestamp::timestamp)as sorgu_müdd?ti,asan.http_status_code
from addon_asanfinance asan
left join luser ls on asan.user_uuid = ls.uuid
left join partner p on asan.person_uuid = p.uuid
left join addon_rappl ar on asan.rappl_uuid = ar.uuid
left join application ap on ar.appl_uuid = ap.uuid
left join analysis an on ap.uuid = an.appl_uuid
left join loan l on an.uuid = l.analysis_uuid
where asan.http_status_code = '200'
--and date(asan.request_timestamp) = '2021-04-23'
--limit 10
	)a 
	