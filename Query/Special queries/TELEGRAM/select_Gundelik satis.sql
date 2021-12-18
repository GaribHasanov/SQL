select concat('Kredit_sayi = ',count_ ,';  C?m_m?bl?g = ' ,cast(sume_ as decimal(18,2)),' azn;')Gundeliksatis
from 
(select sum(l.approved_amount)sume_,count(c.oid)count_
from contract c 
join loan l on c.uuid = l.contract_uuid
where l.status in ('S005','S006')
and l.agr_start_date = date(NOW())
)a