select distinct CONCAT(ls.lastname,' ', ls.firstname,' ',ls.midname)currentLO
from contract c 
join luser ls on c.responsible_uuid = ls.uuid