with cte as (
	
select  a.*,e.yolda_olan_pul,		
	coalesce (yyyx_daily.baskass_900_daily,0) + coalesce (yyy_daily.medaxil_100_daily,0) + coalesce (x_daily.yigim_040_daily,0) as yiqdaily,
	coalesce (yy_daily.mexaric_030_daily,0) + coalesce (y_daily.oturme_050_daily,0) as otdaily
	
	
	from 
	(select distinct title tit , cast('2020-01-01' as date) + (n || ' day')::INTERVAL as calendar
	from cash_desk ,generate_series(0, 720) n
	) a
  	
	left join
	(select distinct cd.title,cdo.c_date, sum(cdo.c_amount) over (partition by cd.title)yolda_olan_pul
    from addon_money_in_the_way  mid 
    join cash_desk_operation cdo on mid.from_uuid = cdo.uuid
    join luser ls on cdo.cashier_uuid = ls.uuid
    join cash_desk cd on cdo.cash_desk_uuid = cd.uuid 
    where cdo.cancelled = false
    and mid.to_uuid is null --and cdo.c_date = '2021-06-16'
	)e
	on a.tit = e.title --and date(a.calendar) = e.c_date
	
	left join
	(select distinct ch.title,
	sum(cdo.c_amount) over (partition by ch.title)yigim_040_daily
	from cash_desk_operation cdo  
	join cash_desk ch on cdo.cash_desk_uuid = ch.uuid  
	join loan l on cdo.loan_uuid = l.contract_uuid  
	where cdo.oper_type = '040' and cdo.cancelled = 'false'
					
)x_daily
on a.tit = x_daily.title

	left join
	(select distinct cd.title,
	 sum(cdo.c_amount) over (partition by cd.title)oturme_050_daily
     from cash_desk_operation cdo 
     join cash_desk cd on cdo.cash_desk_uuid = cd.uuid 
     where cdo.oper_type = '050' and cdo.cancelled = false			
)y_daily
on a.tit = y_daily.title
	
left join
	(select distinct cd.title,
	 sum(cdo.c_amount) over (partition by cd.title)mexaric_030_daily
     from cash_desk_operation cdo 
     join cash_desk cd on cdo.cash_desk_uuid = cd.uuid 
     where cdo.oper_type = '030' and cdo.cancelled = false			
)yy_daily	
	on a.tit = yy_daily.title
	
left join
	(select distinct cd.title,
	 sum(cdo.c_amount) over (partition by cd.title)medaxil_100_daily
     from cash_desk_operation cdo 
     join cash_desk cd on cdo.cash_desk_uuid = cd.uuid 
     where cdo.oper_type = '100' and cdo.cancelled = false			
)yyy_daily
	on a.tit = yyy_daily.title
	
	left join
	(
	select distinct cd.title,
		sum(cdo.c_amount) over (partition by cd.title)baskass_900_daily
from 
cash_desk_operation cdo
join cash_desk cd on cdo.cash_desk_uuid = cd.uuid 
where cdo.cancelled = false and  cdo.oper_type = '090'	
						
)yyyx_daily
	on a.tit = yyyx_daily.title

	
	) select concat(tit,' - ','"YOP"',' = ',YOP,'  ,', ' "Balans"',' = ',dailybalans)yyssssssssssDDDDDDDDDDDDDDDDDDDDDDDDDDssssssssssssssss
	from (
	select distinct tit,coalesce(cast(yolda_olan_pul as decimal(18,2)),'0.00')YOP,
	cast(yiqdaily as decimal(18,2) ) - cast(otdaily as decimal(18,2) ) as dailybalans,date(calendar)calendar
	from  cte
    where calendar = date(now())
		)aaa