select ls.login,rc.* 
from report_call rc
join luser ls on rc.user_uuid = ls.uuid
where rc.report_id = 'R_PF_D' and ls.login = 'NATIQMY'
and rc.started between '2021-10-01' and '2021-10-31'