select * 
from (
	
select agreement_no,max(lus.login) lg,ech.date_,
	   row_number() over (partition by agreement_no order by ech.date_ desc )rn
	   	   
from 
	ext_collection_hist ech 
	left join luser lus on ech.collector = lus.login
	where date(ech.date_) <= '2021-01-19' 
	group by agreement_no,ech.c_uuid,ech.date_,lus.login 
	
	
)a
where 
a.agreement_no = 'R0004929' and 
rn = 1

