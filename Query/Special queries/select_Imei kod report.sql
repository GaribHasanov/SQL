with cte as (
select c.oid,lus.login,
agi.imei,row_number() over (partition by c.oid)rn,l.agr_start_date
from 
contract c 
join loan l on c.uuid = l.contract_uuid
join partner p on l.disb_to_uuid = p.uuid
join analysis an on l.analysis_uuid = an.uuid
join application ap on an.appl_uuid = ap.uuid
join addon_rappl ar on an.uuid = ar.analysis_uuid
join addon_good ag on ar.uuid = ag.rappl_uuid
join addon_good_imei agi on ag.uuid = agi.addon_good_uuid
join luser lus on c.responsible_uuid = lus.uuid
where l.status in ('S005','S006')
--and c.oid = 'R0010501'

)


select distinct a.oid,a.login,b.imei,c.imei,a.agr_start_date
from 
(select * from cte)a
left join
(select * from cte where rn = 1)b on a.oid = b.oid
left join
(select * from cte where rn = 2)c on a.oid = c.oid


--where b.imei = c.imei imei kodu eyni olan kreditler
order by agr_start_date desc