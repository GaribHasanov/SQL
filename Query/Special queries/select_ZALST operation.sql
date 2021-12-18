select aph.appl_id,aph.started,aph.completed,apht.text,aph.error_text
from 
application_list_history_step aph
join appl_exec_hist_status_tx apht on aph.status = apht.pid and apht.lang = 'EN'
where date(started) = date(now())
order by started 