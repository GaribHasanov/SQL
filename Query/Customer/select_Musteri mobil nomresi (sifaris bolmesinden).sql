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
                   Mobil_nomre text PATH '(mob_phone /@value)[1]',
			       pin text PATH '(id_pin /@value)[1]' 
			 
			 
                    ) where a.oid ='R0001727'
)aa
 )select oid,concat('+994','',Mobil_nomre)nomre
 from cte
where number = pin