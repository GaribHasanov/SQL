with cte as (
select  * from (
select a.oid,a.number,XMLTABLE.*             
from (
select c.oid ,ad.content,id_.number
from add_data ad
join addon_rclient_add_data anad on ad.uuid = anad.data_uuid
join addon_rclient arc on anad.rclient_uuid = arc.uuid
join addon_rappl ar on arc.rappl_uuid = ar.uuid
join analysis an on ar.analysis_uuid = an.uuid
join loan l on an.uuid = l.analysis_uuid
join contract c on l.contract_uuid = c.uuid
join partner p on l.disb_to_uuid = p.uuid
join idnumber id_ on p.uuid = id_.partner_uuid and id_.c_type = 'PIN'
where l.status in ('S005','S006') and  ad.config_id = 'xe_rclient'
)a,XMLTABLE ('/rclient' PASSING cast(replace((a.content), 'encoding="utf-8"', '')as xml) 
                 COLUMNS
                   company text PATH '(company_name /@value)[1]' ,position_ text PATH '(position /@value)[1]' ,
			       pin text PATH '(id_pin /@value)[1]' ,
			      
			       qohum_adı text PATH '(contacts /contactsItem /contact_name/@value)[1]',
			       qohumluq text PATH '(contacts /contactsItem /rel_type_c/title_az/@value)[1]',
                   qohumluqnum text PATH '(contacts /contactsItem /phone_number/ @value)[1]',
			 
			      qohum_adı2 text PATH '(contacts /contactsItem /contact_name/@value)[2]',
			       qohumluq2 text PATH '(contacts /contactsItem /rel_type_c/title_az/@value)[2]',
                   qohumluqnum2 text PATH '(contacts /contactsItem /phone_number/ @value)[2]',
			 
			    qohum_adı3 text PATH '(contacts /contactsItem /contact_name/@value)[3]',
			       qohumluq3 text PATH '(contacts /contactsItem /rel_type_c/title_az/@value)[3]',
                   qohumluqnum3 text PATH '(contacts /contactsItem /phone_number/ @value)[3]'
			 
			 
                    ) --where a.oid ='R0001727'
)aa
 )select *
 from cte
where number = pin















--select c.oid from  contract C join loan l  on l.contract_uuid = c.uuid where l.status in ('S005','S006')


