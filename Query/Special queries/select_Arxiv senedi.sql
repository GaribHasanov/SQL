with cte as (
select  * from (
select a.oid,a.rn,a.comm,a.agreement_no,a.tarix,a.SAA,a.fin,a.aze,a.group_,a.model,XMLTABLE.*             
from (
select c.oid,en.endors_comment comm,en.results res,en.c_type,en.c_active,ad.content,l.agr_start_date tarix,id_.number fin,id2.number aze,l.agreement_no , concat(p.name,' ',p.first_name,' ',p.mid_name)SAA,
	    aggt.text group_,coalesce (admt.text,ag.manual_model)model,
	row_number()over (partition by c.oid)rn
from add_data ad
join addon_rclient_add_data anad on ad.uuid = anad.data_uuid
join addon_rclient arc on anad.rclient_uuid = arc.uuid
join addon_rappl ar on arc.rappl_uuid = ar.uuid
join analysis an on ar.analysis_uuid = an.uuid
join loan l on an.uuid = l.analysis_uuid
join contract c on l.contract_uuid = c.uuid
join addon_rappl_endors are on ar.uuid = are.rappl_uuid
join endorsement en on are.endors_uuid = en.uuid
join partner p on l.disb_to_uuid = p.uuid
join idnumber id_ on p.uuid = id_.partner_uuid and id_.c_type = 'PIN'
join idnumber id2 on p.uuid = id2.partner_uuid and id2.c_type = 'PASS'
join addon_good ag on ar.uuid = ag.rappl_uuid
left join addon_good_model adm on ag.model_id = adm.id
left join addon_good_model_tx admt on adm.id = admt.pid
left join addon_good_group_tx aggt on ag.group_id = aggt.pid and aggt.lang = 'AZ'
where l.status in ('S005','S006') and en.results in ('001','200') and ad.config_id = 'xe_rclient'
)a,XMLTABLE ('/rclient' PASSING cast(replace((a.content), 'encoding="utf-8"', '')as xml) 
                 COLUMNS
                   company text PATH '(company_name /@value)[1]' ,position_ text PATH '(position /@value)[1]' ,
			       pin text PATH '(id_pin /@value)[1]' 
			 
			 
                    ) --where a.oid ='R0009897'
)aa
 )select distinct cte.agreement_no,cte.comm,cte.tarix,cte.saa,cte.fin,cte.aze,
 concat(a.model,' / ',b.model,' / ',c.model,' / ',d.model,' / ',e.model,' / ',f.model,' / ',g.model)model,
 cte.company,cte.position_
 from cte
 left join
  (select * from cte where rn =  1)a on cte.oid = a.oid
   left join
  (select * from cte where rn =  2)b on cte.oid = b.oid
  left join
  (select * from cte where rn =  3)c on cte.oid = c.oid
  left join
  (select * from cte where rn =  4)d on cte.oid = d.oid
  left join
  (select * from cte where rn =  5)e on cte.oid = e.oid
  left join
  (select * from cte where rn =  6)f on cte.oid = f.oid
  left join
  (select * from cte where rn =  7)g on cte.oid = g.oid
  where cte.fin = cte.pin

