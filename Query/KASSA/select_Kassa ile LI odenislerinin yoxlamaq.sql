select c.oid,cdop.operation_uuid,cdo.c_amount,cdo.c_date,count(*) countt
from 
cash_desk_operation cdo 
join cash_desk_operation_pmt_orders cdop on cdop.operation_uuid = cdo.uuid
join payment_order po on cdop.pmt_order_uuid = po.uuid
join contract c on cdo.loan_uuid = c.uuid
where --c.oid = 'R0017989' and 
cdo.c_date between '2021-11-01' and '2021-11-30'
group by c.oid,cdop.operation_uuid,cdo.c_amount,cdo.c_date
having count(*)>1