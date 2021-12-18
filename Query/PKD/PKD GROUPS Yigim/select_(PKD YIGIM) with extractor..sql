select  log_,date(calendar)calendar, coalesce (max(case when (Department_='Qrup 1-10')   
then cast(summe_ as varchar) end),' ') as "Qrup 1-10", 
coalesce (max(case when (Department_='Qrup 11-20')  then cast(summe_ as varchar) end),' ') as "Qrup 11-20", 
coalesce (max(case when (Department_='Qrup 21-30')  then cast(summe_ as varchar) end),' ') as "Qrup 21-30", 
coalesce (max(case when (Department_='Qrup 31-60')  then cast(summe_ as varchar) end),' ') as "Qrup 31-60", 
coalesce (max(case when (Department_='Qrup 61-120') then cast(summe_ as varchar) end),' ') as "Qrup 61-120", 
coalesce (max(case when (Department_='Qrup 120+')   then cast(summe_ as varchar) end),' ') as "Qrup 120+"   
from   ( select distinct log_, cast('2021-07-23' as date) + (n || ' day')::INTERVAL as calendar from ( select 'Yiyesiz' log_
union select ls.login log_ from luser ls join user_group ug on ls.uuid = ug.user_uuid join lgroup lg on ug.group_uuid = lg.uuid where lg.description = 'Rep') usre,
generate_series(0, 720) n      ) usr 
left join (select distinct agreement_no,oid,c_date, sum(summe) over (partition by Department_,login,c_date)summe_,
Department,Department_,login, pmt_order_uuid  from ( select * ,  sum(amo) over (partition by pmt_order_uuid)summe, 
case  
when Department = 'COL01' then  'Qrup 1-10' 
when Department = 'COL11' then  'Qrup 11-20' 
when Department = 'COL21' then  'Qrup 21-30' 
when Department = 'COL31' then  'Qrup 31-60' 
when Department = 'COL61' then  'Qrup 61-120' 
when Department = 'COL121'then  'Qrup 120+'  end as  Department_ 
from (   select ech.agreement_no,ech.oid,ech.date_,ech.lc_end_time,  
row_number() over (partition by ech.agreement_no,erh.amount ,erh.acc_type, erh.pmt_order_uuid order by ech.date_ desc )rn2,  
erh.c_date,erh.amount amo,erh.acc_type,  erh.pmt_order_uuid,coalesce(lus.login,'Yiyesiz')login,   
ech.name_ as Department            
from ( select * from ext_collection_hist 
union all select c.oid,lc.oid lcoid,lc.c_type,acda.cr_timestamp,ls.login,acda.division,c.uuid,lc.end_timestamp 
from lcase lc  join addon_coll_case acc on lc.uuid = acc.bus_case join contract c on   acc.loan_uuid = c.uuid  
join addon_coll_division_assign acda on acc.uuid = acda.case_uuid left join luser ls on acda.user_uuid = ls.uuid )ech      
join ext_repayment_hist erh on  ech.agreement_no = erh.agreement_no    
left join luser lus on ech.collector = lus.login   where  date(ech.date_) <= erh.c_date  and erh.acc_type in ('PRNC','PRNC_A')    
group by ech.agreement_no,ech.oid,ech.date_,lus.login ,erh.c_date,erh.amount,erh.acc_type,erh.pmt_order_uuid,ech.name_,ech.lc_end_time   )a 
where rn2 = 1  and  (c_date <= date(lc_end_time) or date(lc_end_time) is null ) order by c_date   ) cte 
where Department_ is not null group by agreement_no,oid,c_date,
summe,pmt_order_uuid, Department,Department_,login order by c_date desc  )aaaa 
on usr.log_ = aaaa.login and date(usr.calendar) = aaaa.c_date --where date(calendar) > '2021-05-01'  
group by  c_date,summe_,Department_,log_,calendar
