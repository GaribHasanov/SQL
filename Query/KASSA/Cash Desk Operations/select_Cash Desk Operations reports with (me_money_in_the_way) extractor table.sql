with cte as (
   
select  a.*,b.*,c.medaxil,d.mexaric,f.tesdiq_pul_by_kenan,g.kocurme,  
	coalesce (yyyx_daily.baskass_900_daily,0) + coalesce (yyy_daily.medaxil_100_daily,0) + coalesce (x_daily.yigim_040_daily,0) as yiqdaily,  
	coalesce (yy_daily.mexaric_030_daily,0) + coalesce (y_daily.oturme_050_daily,0) as otdaily,chb.end_balance,mid.morning,mid.evening
	from   (select distinct title tit , cast('2020-01-01' as date) + (n || ' day')::INTERVAL as calendar  
			from cash_desk ,generate_series(0, 720) n  ) a     
	left join   (  select distinct ch.title,  cdo.c_amount,cdo.created,cdo.c_date,  
				 sum(cdo.c_amount) over (partition by ch.title , cdo.c_date)sm  
				 from cash_desk_operation cdo    
				 join cash_desk ch on cdo.cash_desk_uuid = ch.uuid    
				 join loan l on cdo.loan_uuid = l.contract_uuid    
				 join luser ls on cdo.created_by = ls.uuid    
				 join luser ls2 on cdo.cashier_uuid = ls2.uuid     
				 where cdo.oper_type = '040' and cdo.cancelled = 'false'  
				 group by l.agreement_no,cdo.oid,ch.title,  
				 cdo.c_amount,cdo.created,cdo.c_date    )   
	b on a.tit = b.title and date(a.calendar) = b.c_date    
	left join  (select distinct ch.title,cdo.c_date,  
				sum(cdo.c_amount) over (partition by ch.title , cdo.c_date )medaxil  
				from cash_desk_operation cdo    join cash_desk ch on cdo.cash_desk_uuid = ch.uuid    
				where cdo.oper_type = '100' and cdo.cancelled = 'false'  )c  on a.tit = c.title and date(a.calendar) = c.c_date    
	left join  (select distinct ch.title,cdo.c_date,  sum(cdo.c_amount) over (partition by ch.title , cdo.c_date)mexaric  
				from cash_desk_operation cdo    join cash_desk ch on cdo.cash_desk_uuid = ch.uuid    
				where cdo.oper_type = '030' and cdo.cancelled = 'false'  )d  on a.tit = d.title and date(a.calendar) = d.c_date    
	
	   
	left join  (select distinct cd.title,cdo.c_date,sum(cdo.c_amount) over (partition by cd.title , cdo.c_date)tesdiq_pul_by_kenan     
				from addon_money_in_the_way  mid      
				join cash_desk_operation cdo on mid.from_uuid = cdo.uuid     
				join luser ls on cdo.cashier_uuid = ls.uuid     
				join cash_desk cd on cdo.cash_desk_uuid = cd.uuid      
				where cdo.cancelled = false and      
				mid.to_uuid is not null)f  on a.tit = f.title and date(a.calendar) = f.c_date    
	left join  (select distinct cd.title,cdo.c_date,sum(cdo.c_amount) over (partition by cd.title , cdo.c_date)kocurme     
				from addon_money_in_the_way  mid      
				join cash_desk_operation cdo on mid.from_uuid = cdo.uuid     
				join luser ls on cdo.cashier_uuid = ls.uuid     
				join cash_desk cd on cdo.cash_desk_uuid = cd.uuid      
				where cdo.cancelled = false   )g  on a.tit = g.title and date(a.calendar) = g.c_date   
		
	left join  (select distinct ch.title,  sum(cdo.c_amount) over (partition by ch.title)yigim_040_daily  
				from cash_desk_operation cdo    join cash_desk ch on cdo.cash_desk_uuid = ch.uuid    
				join loan l on cdo.loan_uuid = l.contract_uuid    
				where cdo.oper_type = '040' and cdo.cancelled = 'false'       )x_daily on a.tit = x_daily.title   
	left join  (select distinct cd.title,   sum(cdo.c_amount) over (partition by cd.title)oturme_050_daily      
				from cash_desk_operation cdo       
				join cash_desk cd on cdo.cash_desk_uuid = cd.uuid       
				where cdo.oper_type = '050' and cdo.cancelled = false    )y_daily on a.tit = y_daily.title   
	left join  (select distinct cd.title,   sum(cdo.c_amount) over (partition by cd.title)mexaric_030_daily      
				from cash_desk_operation cdo       join cash_desk cd on cdo.cash_desk_uuid = cd.uuid       
				where cdo.oper_type = '030' and cdo.cancelled = false    )yy_daily   on a.tit = yy_daily.title   
	left join  (select distinct cd.title,   sum(cdo.c_amount) over (partition by cd.title)medaxil_100_daily      
				from cash_desk_operation cdo       
				join cash_desk cd on cdo.cash_desk_uuid = cd.uuid       
				where cdo.oper_type = '100' and cdo.cancelled = false    )yyy_daily  on a.tit = yyy_daily.title    
	left join  (  select distinct cd.title,sum(cdo.c_amount) over (partition by cd.title)baskass_900_daily 
				from  cash_desk_operation cdo join cash_desk cd on cdo.cash_desk_uuid = cd.uuid  
				where cdo.cancelled = false and  cdo.oper_type = '090'         )yyyx_daily  on a.tit = yyyx_daily.title    
	left join  (select title,date,end_balance from me_cash_desk_amounts)chb  on a.tit = chb.title and date(a.calendar) = chb.date    
	
	left join 
	(select distinct cd.title,mid.date,mid.morning,mid.evening
	 from cash_desk cd
     join me_money_in_the_way mid on cd.uuid = mid.cash_desk
	 )mid
    on a.tit = mid.title and date(a.calendar) = mid.date 

)   
	
	select distinct tit,date(calendar)calendar,
	sm "Kredit ödenisi üzre",medaxil ,mexaric, kocurme,tesdiq_pul_by_kenan Bas_kassa_tesdiq,
	cast(end_balance as decimal(18,2))end_balance,  cast(yiqdaily as decimal(18,2)) - cast(otdaily as decimal(18,2)) dailybalans,
	cast(morning as decimal(18,2))morning,cast(evening as decimal(18,2))evening
	from  cte
    where calendar = '2021-06-30'		   
		   
		   
		   