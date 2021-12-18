with cte as (
select c.oid,coalesce (en.endors_comment,'')comment_ ,
row_number() over (partition by c.oid)rn
from 
contract c 
join loan l on l.contract_uuid = c.uuid
join analysis an on an.uuid = l.analysis_uuid
join addon_rappl ar on ar.analysis_uuid = an.uuid
join addon_rappl_endors are on ar.uuid = are.rappl_uuid
join endorsement en on are.endors_uuid = en.uuid
where en.results in ('001','200') and c.oid ='R0015681'
)
select  aa.oid,concat(a.comment_ ,' ',b.comment_ ,' ', c.comment_ ,' ', d.comment_ )comment_
from 
(select * from cte )aa
left join
(select * from cte where rn = 1)a on aa.oid = a.oid
left join
(select * from cte where rn = 2)b on aa.oid = b.oid
left join
(select * from cte where rn = 3)c on aa.oid = c.oid
left join
(select * from cte where rn = 4)d on aa.oid = d.oid
left join
(select * from cte where rn = 5)e on aa.oid = e.oid
group by aa.oid,a.comment_ , b.comment_ , c.comment_ , d.comment_