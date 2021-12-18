select date(calendar)calendarcalendar
from (select distinct 
cast('2020-01-31' as date) + (n || 'month')::INTERVAL as calendar  
			from generate_series(0, 35) n )a
			order by calendar desc